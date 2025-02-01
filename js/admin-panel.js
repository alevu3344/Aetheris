const scriptUrlAdmin = new URL(document.currentScript.src); // Get the script's URL
const publishers = scriptUrlAdmin.searchParams.get("publishers"); // Get the game parameter
const categories = scriptUrlAdmin.searchParams.get("categories"); // Get the game parameter

let publishersList = [];
try {
    publishersList = JSON.parse(decodeURIComponent(publishers)); // Parse the JSON
} catch (error) {
    console.error("Error parsing publishers:", error);
}


document.querySelectorAll(".game").forEach((game) => {
    game.querySelector(".actions > .delete").addEventListener("click", () => {
        if (confirm("Are you sure you want to delete this game?")) {
            deleteGame(game);
        }
    });
});


async function deleteGame(game) {
    let id = game.querySelector(".actions > .delete").getAttribute("data-id");
    formData = new FormData();
    formData.append("GameId", id);
    const url = "api/delete-game.php";
    // Send a POST request to the server with the purchase details
    let response = await fetch(url, {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", "Game deleted", "positive");
        game.remove();
    } else {
        createNotificaton("Error", data["message"], "negative");
    }
}



function createNotificaton(title, message, type) {
    let notification = document.createElement("div");
    notification.id = "notification";
    notification.classList.add(type);
    notification.innerHTML = `
    <h2>${title}</h2>
    <p>${message}</p>
    <button>OK</button>
    `

    if (type == "positive") {
        //set the background color to green
        notification.style.backgroundColor = "green";
        //set the button color to darker green
        notification.querySelector("button").style.backgroundColor = "darkgreen";
    }
    else {
        //set the background color to red
        notification.style.backgroundColor = "red";
        //set the button color to darker red
        notification.querySelector("button").style.backgroundColor = "darkred";
    }



    document.body.insertBefore(notification, document.body.firstChild);

    document.querySelector("#notification > button").addEventListener("click", function (event) {
        event.preventDefault();
        notification.remove();
    });


    setTimeout(() => {
        notification.remove();
    }, 5000);


}

async function addPlatform(platform, gameId) {
    let formData = new FormData();
    formData.append("Platform", platform);
    formData.append("GameId", gameId);
    formData.append("Action", "add");

    const url = "api/modify-platforms-api.php";
    // Send a POST request to the server with the purchase details
    let response = await fetch(url, {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", `${data["platform"]} added to game ${data["gameName"]}`, "positive");
    } else {
        createNotificaton("Error", `Failed to add ${data["platform"]} to game ${data["gameName"]}`, "negative");
    }
}


async function removePlatform(platform, gameId) {
    let formData = new FormData();
    formData.append("Platform", platform);
    formData.append("GameId", gameId);
    formData.append("Action", "remove");

    const url = "api/modify-platforms-api.php";
    // Send a POST request to the server with the purchase details
    let response = await fetch(url, {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", `${data["platform"]} removed from game ${data["gameName"]}`, "positive");
    } else {
        createNotificaton("Error", `Failed to remove ${data["platform"]} from game ${data["gameName"]}`, "negative");
    }
}


document.addEventListener("click", function (event) {
    if (event.target.classList.contains("edit-platforms")) {
        let button = event.target;
        const dtContainer = button.parentElement;
        let dd = dtContainer.parentElement.querySelector("dd");
        const gameId = button.closest(".game").id;

        if (!dd) {
            return;
        }

        const containerDiv = dd.closest(".possible-form");
        const availablePlatforms = ["PC", "Xbox", "PlayStation", "Nintendo_Switch"];

        // Funzione per aggiornare (o creare) il select in base alle piattaforme mancanti
        function updateOrCreateSelect() {
            // Calcola le piattaforme già presenti
            const present = Array.from(dd.querySelectorAll("img.platform-icon")).map(icon => icon.src.split("/").pop().split(".")[0]);
            // Determina le piattaforme che possono essere aggiunte (disponibili)
            const missing = availablePlatforms.filter(p => present.indexOf(p) === -1);

            let select = containerDiv.querySelector("select.add-platform-select");
            if (missing.length === 0) {
                // Se non ci sono piattaforme mancanti, rimuovo il select se esiste
                if (select) {
                    select.remove();
                }
                return;
            }
            // Se il select non esiste e il numero di icone è inferiore a 4, lo creo
            if (!select && dd.querySelectorAll("img.platform-icon").length < 4) {
                const dt = dtContainer.querySelector("dt");
                select = document.createElement("select");
                select.classList.add("add-platform-select");
                select.style.backgroundColor = "green";
                select.style.marginLeft = "10px"; // per separarlo un po' dal dt

                // Opzione di default
                const defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.text = "Aggiungi piattaforma...";
                defaultOption.disabled = true;
                defaultOption.selected = true;
                select.appendChild(defaultOption);
                dt.insertAdjacentElement("afterend", select);

                // Aggiungo il listener al select
                select.addEventListener("change", (e) => {
                    const selectedPlatform = e.target.value;
                    if (selectedPlatform) {
                        // Crea una nuova icona per la piattaforma
                        addPlatform(selectedPlatform, button.closest(".game").id)
                        const newIcon = document.createElement("img");
                        newIcon.classList.add("platform-icon");
                        newIcon.src = `upload/icons/${selectedPlatform}.svg`;
                        dd.appendChild(newIcon);

                        // Elimina l'opzione selezionata
                        const optionToRemove = Array.from(e.target.options).find(opt => opt.value === selectedPlatform);
                        if (optionToRemove) {
                            optionToRemove.remove();
                        }
                        // Se dopo l'aggiunta raggiungiamo 4 icone, rimuovo il select
                        if (dd.querySelectorAll("img.platform-icon").length === 4) {
                            e.target.remove();
                        }

                        // Aggiungo il delete button per la nuova icona
                        const deleteIcon = document.createElement("img");
                        const deleteButton = document.createElement("button");

                        deleteIcon.src = "upload/icons/delete.png";
                        deleteIcon.classList.add("delete-icon");
                        deleteButton.classList.add("delete-button");
                        deleteButton.appendChild(deleteIcon);
                        newIcon.insertAdjacentElement("beforebegin", deleteButton);

                        // Listener per il delete button della nuova icona
                        deleteButton.addEventListener("click", (e) => {
                            if (confirm(`Are you sure you want to delete the ${selectedPlatform} platform?`)) {
                                removePlatform(selectedPlatform, gameId)
                                    .then(() => {
                                        newIcon.remove();
                                        deleteButton.remove();
                                        // Reinserisco l'opzione nel select
                                        reinsertOption(selectedPlatform);
                                    })
                                    .catch(error => console.error("Errore:", error));
                            }
                        });
                        // Resetta il select
                        e.target.selectedIndex = 0;
                    }
                });
            } else if (select) {
                // Se esiste già il select, ricostruisco le opzioni basandomi su quelle mancanti
                // Rimuovo tutte le opzioni tranne quella di default
                Array.from(select.options).forEach((opt, index) => {
                    if (index !== 0) {
                        opt.remove();
                    }
                });
            }

            // Aggiungo le opzioni mancanti al select (se esiste)
            select = containerDiv.querySelector("select.add-platform-select");
            if (select) {
                missing.forEach(platform => {
                    // Evito duplicati
                    if (!Array.from(select.options).some(opt => opt.value === platform)) {
                        const option = document.createElement("option");
                        option.value = platform;
                        option.text = platform;
                        select.appendChild(option);
                    }
                });
            }
        }

        // Funzione per reinserire un'opzione nel select (creandolo se necessario)
        function reinsertOption(platform) {
            let select = containerDiv.querySelector("select.add-platform-select");
            // Se non esiste e il numero di icone è minore di 4, crealo
            if (!select && dd.querySelectorAll("img.platform-icon").length < 4) {
                updateOrCreateSelect();
                select = containerDiv.querySelector("select.add-platform-select");
            }
            if (select) {
                // Evito duplicati
                if (!Array.from(select.options).some(opt => opt.value === platform)) {
                    const option = document.createElement("option");
                    option.value = platform;
                    option.text = platform;
                    select.appendChild(option);
                }
            }
        }

        // Modalità "Save": aggiorno dd con le icone rimanenti e rimuovo il select se presente
        if (button.innerText === "Save") {
            const icons = dd.querySelectorAll("img.platform-icon");
            const newValue = Array.from(icons).map(icon => icon.src.split("/").pop().split(".")[0]);

            dd.innerHTML = newValue.map(platformName => {
                return `<img class="platform-icon" src="upload/icons/${platformName}.svg" />`;
            }).join("");

            let newButton = containerDiv.querySelector(".edit-platforms");
            newButton.innerText = "Edit";
            newButton.style.backgroundColor = "";

            const extraSelect = containerDiv.querySelector("select.add-platform-select");
            if (extraSelect) {
                extraSelect.remove();
            }
        }
        else {
            // Modalità "Edit": cambio il bottone in Save
            button.innerText = "Save";
            button.style.backgroundColor = "green";
            

            // Se il numero di piattaforme è inferiore a 4, aggiorno/creo il select
            if (dd.querySelectorAll("img.platform-icon").length < 4) {
                updateOrCreateSelect();
            }

            // Aggiungo (o aggiorno) i delete buttons per ogni icona esistente
            dd.querySelectorAll("img.platform-icon").forEach(icon => {
                // Evito duplicati
                if (icon.previousElementSibling && icon.previousElementSibling.classList.contains("delete-button")) {
                    return;
                }
                const deleteIcon = document.createElement("img");
                const deleteButton = document.createElement("button");

                deleteIcon.src = "upload/icons/delete.png";
                deleteIcon.classList.add("delete-icon");
                deleteButton.classList.add("delete-button");
                deleteButton.appendChild(deleteIcon);
                icon.insertAdjacentElement("beforebegin", deleteButton);

                let platformName = icon.src.split("/").pop().split(".")[0];

                deleteButton.addEventListener("click", (e) => {
                    if (confirm(`Are you sure you want to delete the ${platformName} platform?`)) {
                        removePlatform(platformName, gameId)
                            .then(() => {
                                icon.remove();
                                deleteButton.remove();
                                // Reinserisco l'opzione della piattaforma eliminata nel select
                                reinsertOption(platformName);
                            })
                            .catch(error => console.error("Errore:", error));
                    }
                });
            });
        }
    }
});








document.addEventListener("click", function (event) {
    if (event.target.classList.contains("edit")) {
        let button = event.target;
        console.log(button.innerText);

        const dtContainer = button.parentElement;
        let dd = dtContainer.parentElement.querySelector("dd");
        let dt = dtContainer.querySelector("dt");

        const containerDiv = dd.closest(".possible-form");
        let divInner = containerDiv.innerHTML;

        if (!dd) return;

        if (button.innerText === "Save") {
            console.log("Save");
            const input = dd.querySelector("input, select");
            const newValue = input.value.trim();
            const gameId = button.closest(".game").id;
            const fieldName = dd.id;

            // Check input validity before saving
            if (input.checkValidity()) {
                modifyField(gameId, fieldName, newValue);

                dd.textContent = newValue;
                if(dd.classList.contains("expired") || dd.classList.contains("available")){ 
                    dd.classList = "";
                    dd.classList.add(newValue > 0 ? "available" : "expired");
                }
                button.innerText = "Edit";
                button.style.backgroundColor = "";
                event.preventDefault();
            } else {
                // If the input is not valid, show feedback
                input.setCustomValidity("Please enter a valid value.");
                input.reportValidity();
                //reset the input validity
                input.setCustomValidity("");
                return;
            }

        } else {
            const currentValue = dd.textContent.trim();

            //SVILUPPATORE
            if (dt && dt.innerText.trim() === "Sviluppatore:") {
                const select = document.createElement("select");
                select.classList.add("edit-select");

                publishersList.forEach(publisher => {
                    const option = document.createElement("option");
                    option.value = publisher.PublisherName;
                    option.textContent = publisher.PublisherName;
                    option.selected = (publisher.PublisherName === currentValue);
                    select.appendChild(option);
                });

                dd.textContent = "";
                dd.appendChild(select);
                select.focus();

                select.addEventListener("blur", () => {
                    setTimeout(() => {
                        if (button.innerText === "Save") {
                            dd.textContent = currentValue;
                            button.innerText = "Edit";
                            button.style.backgroundColor = "";
                            containerDiv.innerHTML = divInner;
                        }
                    }, 200);
                });

            }

            //ALTRO
            else {
                console.log("Edit");
                const form = document.createElement("form");
                form.innerHTML = divInner;

                containerDiv.innerHTML = "";
                containerDiv.appendChild(form);
                dd = form.querySelector("dd");
                button = form.querySelector("button");




                const input = document.createElement("input");

                input.id = dd.id;
                input.value = currentValue;
                input.classList.add("edit-input");

                const label = document.createElement("label");
                label.for = input.id;
                label.classList.add("visually-hidden");

                //switch the input id to set the validation
                switch (input.id) {
                    case "GameName":
                        input.type = "text";
                        label.textContent = "Game Name";
                        input.required = true;
                        break;
                    case "Trailer":
                        input.type = "text";
                        label.textContent = "Trailer";
                        input.required = true;
                        //needs to be a valid url
                        input.pattern = "https?://.+";
                        break;
                    case "Price":
                        input.type = "number";
                        //has to be > 0
                        input.min = 0.01;
                        input.step = 0.01;
                        label.textContent = "Price";
                        input.required = true;
                        break;
                    case "ReleaseDate":
                        input.type = "date";
                        label.textContent = "Release Date";
                        input.required = true;
                        break;
                    case "StartDate":
                        input.type = "date";
                        label.textContent = "Start Date for Sale";
                        input.required = true;
                        break;
                    case "EndDate":
                        input.type = "date";
                        label.textContent = "End Date for Sale";
                        input.required = true;
                        break;
                    case "PC":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 0;
                        input.step = 1;
                        label.textContent = "PC Quantity";
                        input.required = true;

                        break;
                    case "Xbox":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 0;
                        input.step = 1;
                        label.textContent = "Xbox Quantity";
                        input.required = true;

                        break;
                    case "PlayStation":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 0;
                        input.step = 1;
                        label.textContent = "PlayStation Quantity";
                        input.required = true;

                        break;

                    case "Nintendo_Switch":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 0;
                        input.step = 1;
                        label.textContent = "Nintendo Switch Quantity";
                        input.required = true;

                        break;
                    case "Discount":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 0;
                        input.max = 100;
                        input.step = 1;
                        label.textContent = "Discount";
                        input.required = true;
                        break;
                    case "OS":
                        input.type = "text";
                        label.textContent = "OS";
                        input.required = true;
                        break;
                    case "CPU":
                        input.type = "text";
                        label.textContent = "CPU";
                        input.required = true;
                        break;
                    case "GPU":
                        input.type = "text";
                        label.textContent = "GPU";
                        input.required = true;
                        break;
                    case "RAM":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 1;
                        input.step = 1;
                        label.textContent = "RAM";
                        input.required = true;
                        break;
                    case "SSD":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 1;
                        input.step = 1;
                        label.textContent = "SSD";
                        input.required = true;
                        break;
                    default:
                        input.type = "text";
                        label.textContent = "Default";
                        input.required = true;
                        break;
                }

                dd.textContent = "";
                dd.appendChild(label);
                dd.appendChild(input);
                input.focus();

                input.addEventListener("blur", () => {
                    setTimeout(() => {
                        if (button.innerText === "Save") {
                            dd.textContent = currentValue;
                            button.innerText = "Edit";
                            button.style.backgroundColor = "";
                            containerDiv.innerHTML = divInner;
                        }
                    }, 200);
                });

            }

            // Set the button text and background color before making changes
            button.innerText = "Save";
            button.style.backgroundColor = "green";
            button.type = "submit";
        }
    }
});

async function modifyField(gameId, fieldName, newValue) {
    let formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Field", fieldName);
    formData.append("Value", newValue);
    const url = "api/modify-game-api.php";
    // Send a POST request to the server with the purchase details
    let response = await fetch(url, {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", data["message"], "positive");
    } else {
        createNotificaton("Error", data["message"], "negative");
    }
}