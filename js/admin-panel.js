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

async function addCategory(category, gameId) {
    let formData = new FormData();
    formData.append("Category", category);
    formData.append("GameId", gameId);
    formData.append("Action", "add");

    const url = "api/modify-categories-api.php";
    // Send a POST request to the server with the purchase details
    let response = await fetch(url, {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", `${data["category"]} added to game ${data["gameName"]}`, "positive");
    } else {
        createNotificaton("Error", `Failed to add ${data["category"]} to game ${data["gameName"]}`, "negative");
    }
}


async function removeCategory(category, gameId) {
    let formData = new FormData();
    formData.append("Category", category);
    formData.append("GameId", gameId);
    formData.append("Action", "remove");

    const url = "api/modify-categories-api.php";
    // Send a POST request to the server with the purchase details
    let response = await fetch(url, {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", `${data["category"]} removed from game ${data["gameName"]}`, "positive");
    } else {
        createNotificaton("Error", `Failed to remove ${data["category"]} from game ${data["gameName"]}`, "negative");
    }
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
    if (event.target.classList.contains("edit-categories")) {
        let button = event.target;
        const dtContainer = button.parentElement;
        let dd = dtContainer.parentElement.querySelector("dd");
        const gameId = button.closest(".game").id;

        if (!dd) {
            return;
        }

        const containerDiv = dd.closest(".possible-form");


        // Poiché searchParams.get() restituisce una stringa, la parsiamo in un array di oggetti
        const categoryObjects = JSON.parse(categories);

        // Mappiamo l'array per ottenere solo i nomi delle categorie
        const availableCategories = categoryObjects.map(category => category.CategoryName);

        // Funzione per aggiornare (o creare) il select in base alle categorie mancanti
        function updateOrCreateSelect() {
            // Calcola le categorie già presenti
            const present = Array.from(dd.querySelectorAll("span")).map(span => span.textContent);
            // Determina le categorie che possono essere aggiunte (disponibili)
            const missing = availableCategories.filter(p => present.indexOf(p) === -1);

            let select = containerDiv.querySelector("select.add-category-select");
            if (missing.length === 0) {
                // Se non ci sono piattaforme mancanti, rimuovo il select se esiste
                if (select) {
                    select.remove();
                }
                return;
            }
            // Se il select non esiste e il numero di span è inferiore alla lunghezza di categories, lo creo
            if (!select && dd.querySelectorAll("span").length < availableCategories.length) {
                const dt = dtContainer.querySelector("dt");
                select = document.createElement("select");
                select.classList.add("add-category-select");
                select.style.backgroundColor = "blue";
                select.style.marginLeft = "10px"; // per separarlo un po' dal dt

                // Opzione di default
                const defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.text = "Aggiungi categoria...";
                defaultOption.disabled = true;
                defaultOption.selected = true;
                select.appendChild(defaultOption);
                dt.insertAdjacentElement("afterend", select);

                // Aggiungo il listener al select
                select.addEventListener("change", (e) => {
                    const selectedCategory = e.target.value;
                    if (selectedCategory) {
                        // Crea un nuovo span per la categoria
                        addCategory(selectedCategory, button.closest(".game").id)
                        const newSpan = document.createElement("span");
                        newSpan.textContent = selectedCategory;
                        dd.appendChild(newSpan);

                        // Elimina l'opzione selezionata
                        const optionToRemove = Array.from(e.target.options).find(opt => opt.value === selectedCategory);
                        if (optionToRemove) {
                            optionToRemove.remove();
                        }
                        // Se dopo l'aggiunta raggiungiamo la lunghzza di categories, rimuovo il select
                        if (dd.querySelectorAll("img.platform-icon").length === availableCategories.length) {
                            e.target.remove();
                        }

                        // Aggiungo il delete button per il nuovo span
                        const deleteIcon = document.createElement("img");
                        const deleteButton = document.createElement("button");

                        deleteIcon.src = "upload/icons/delete.png";
                        deleteIcon.classList.add("delete-icon");
                        deleteButton.classList.add("delete-button");
                        deleteButton.appendChild(deleteIcon);
                        newSpan.insertAdjacentElement("beforebegin", deleteButton);

                        // Listener per il delete button del nuovo span
                        deleteButton.addEventListener("click", (e) => {
                            if (confirm(`Are you sure you want to delete the ${selectedCategory} category?`)) {
                                removeCategory(selectedCategory, gameId)
                                    .then(() => {
                                        newSpan.remove();
                                        deleteButton.remove();
                                        // Reinserisco l'opzione nel select
                                        reinsertOption(selectedCategory);
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
            select = containerDiv.querySelector("select.add-category-select");
            if (select) {
                missing.forEach(category => {
                    // Evito duplicati
                    if (!Array.from(select.options).some(opt => opt.value === category)) {
                        const option = document.createElement("option");
                        option.value = category;
                        option.text = category;
                        select.appendChild(option);
                    }
                });
            }
        }

        // Funzione per reinserire un'opzione nel select (creandolo se necessario)
        function reinsertOption(category) {
            let select = containerDiv.querySelector("select.add-category-select");
            // Se non esiste e il numero di span è minore della lunghezza di categories, crealo
            if (!select && dd.querySelectorAll("span").length < availableCategories.length) {
                updateOrCreateSelect();
                select = containerDiv.querySelector("select.add-category-select");
            }
            if (select) {
                // Evito duplicati
                if (!Array.from(select.options).some(opt => opt.value === category)) {
                    const option = document.createElement("option");
                    option.value = category;
                    option.text = category;
                    select.appendChild(option);
                }
            }
        }

        // Modalità "Save": aggiorno dd con le icone rimanenti e rimuovo il select se presente
        if (button.innerText === "Save") {
            const spans = dd.querySelectorAll("span");
            const newValue = Array.from(spans).map(span => span.textContent);

            dd.innerHTML = newValue.map(categoryName => {
                return `<span>${categoryName}</span>`;
            }).join("");

            let newButton = containerDiv.querySelector(".edit-categories");
            newButton.innerText = "Edit";
            newButton.style.backgroundColor = "";

            const extraSelect = containerDiv.querySelector("select.add-category-select");
            if (extraSelect) {
                extraSelect.remove();
            }
        }
        else {
            // Modalità "Edit": cambio il bottone in Save
            button.innerText = "Save";
            button.style.backgroundColor = "green";


            // Se il numero di piattaforme è inferiore a 4, aggiorno/creo il select
            if (dd.querySelectorAll("span").length < availableCategories.length) {
                updateOrCreateSelect();
            }

            // Aggiungo (o aggiorno) i delete buttons per ogni icona esistente
            dd.querySelectorAll("span").forEach(span => {
                // Evito duplicati
                if (span.previousElementSibling && span.previousElementSibling.classList.contains("delete-button")) {
                    return;
                }
                const deleteIcon = document.createElement("img");
                const deleteButton = document.createElement("button");

                deleteIcon.src = "upload/icons/delete.png";
                deleteIcon.classList.add("delete-icon");
                deleteButton.classList.add("delete-button");
                deleteButton.appendChild(deleteIcon);
                span.insertAdjacentElement("beforebegin", deleteButton);

                let categoryName = span.textContent;

                deleteButton.addEventListener("click", (e) => {
                    if (confirm(`Are you sure you want to delete the ${categoryName} category?`)) {
                        removeCategory(categoryName, gameId)
                            .then(() => {
                                span.remove();
                                deleteButton.remove();
                                // Reinserisco l'opzione della piattaforma eliminata nel select
                                reinsertOption(categoryName);
                            })
                            .catch(error => console.error("Errore:", error));
                    }
                });
            });
        }
    }
});


document.addEventListener("click", function (event) {
    if (event.target.classList.contains("add")) {
        let button = event.target;
        const gameId = button.closest(".game").id;
        createDiscountPopup(gameId, button.closest(".game").querySelector("#Name").textContent);
    }
});


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

        // Function to remove the possible-form when deleting a platform
        function removePossibleForm(platform) {
            //selected the .possible-form div that has id="platform" in the same <li> as the button
            const possibleFormDiv = button.closest("li").querySelector(`.possible-form#${platform}`);

            if (possibleFormDiv) {
                possibleFormDiv.remove();
            }
        }

        // Function to create a new possible-form when adding a platform
        function createNewPossibleForm(platform) {
            const newPossibleForm = document.createElement("div");
            newPossibleForm.classList.add("possible-form");
            newPossibleForm.id = platform;

            // Creating the structure for the new possible-form (set quantity to 0)
            newPossibleForm.innerHTML = `
                <div>
                    <button class="edit">Edit</button>
                    <dt>${platform}(stock):</dt>
                </div>
                <dd id="${platform}" class="expired">0</dd>
            `;

            // Append the new possible-form after the div with id="platforms"
            button.closest("li").querySelector("#platforms").insertAdjacentElement("afterend", newPossibleForm);
        }

        // Function to update or create the select dropdown for adding platforms
        function updateOrCreateSelect() {
            // Calculate the existing platforms
            const present = Array.from(dd.querySelectorAll("img.platform-icon")).map(icon => icon.src.split("/").pop().split(".")[0]);
            const missing = availablePlatforms.filter(p => present.indexOf(p) === -1);

            let select = containerDiv.querySelector("select.add-platform-select");
            if (missing.length === 0) {
                if (select) {
                    select.remove();
                }
                return;
            }

            if (!select && dd.querySelectorAll("img.platform-icon").length < 4) {
                const dt = dtContainer.querySelector("dt");
                select = document.createElement("select");
                select.classList.add("add-platform-select");
                select.style.backgroundColor = "green";
                select.style.marginLeft = "10px";

                const defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.text = "Aggiungi piattaforma...";
                defaultOption.disabled = true;
                defaultOption.selected = true;
                select.appendChild(defaultOption);
                dt.insertAdjacentElement("afterend", select);

                select.addEventListener("change", (e) => {
                    const selectedPlatform = e.target.value;
                    if (selectedPlatform) {
                        addPlatform(selectedPlatform, gameId);
                        createNewPossibleForm(selectedPlatform);
                        const newIcon = document.createElement("img");
                        newIcon.classList.add("platform-icon");
                        newIcon.src = `upload/icons/${selectedPlatform}.svg`;
                        dd.appendChild(newIcon);

                        const optionToRemove = Array.from(e.target.options).find(opt => opt.value === selectedPlatform);
                        if (optionToRemove) {
                            optionToRemove.remove();
                        }

                        if (dd.querySelectorAll("img.platform-icon").length === 4) {
                            e.target.remove();
                        }

                        const deleteIcon = document.createElement("img");
                        const deleteButton = document.createElement("button");

                        deleteIcon.src = "upload/icons/delete.png";
                        deleteIcon.classList.add("delete-icon");
                        deleteButton.classList.add("delete-button");
                        deleteButton.appendChild(deleteIcon);
                        newIcon.insertAdjacentElement("beforebegin", deleteButton);

                        deleteButton.addEventListener("click", (e) => {
                            if (confirm(`Are you sure you want to delete the ${selectedPlatform} platform?`)) {
                                removePlatform(selectedPlatform, gameId)
                                    .then(() => {
                                        newIcon.remove();
                                        deleteButton.remove();
                                        reinsertOption(selectedPlatform);
                                        // Add the new possible-form div
                                        removePossibleForm(selectedPlatform);
                                    })
                                    .catch(error => console.error("Error:", error));
                            }
                        });

                        e.target.selectedIndex = 0;
                    }
                });
            } else if (select) {
                Array.from(select.options).forEach((opt, index) => {
                    if (index !== 0) {
                        opt.remove();
                    }
                });
            }

            select = containerDiv.querySelector("select.add-platform-select");
            if (select) {
                missing.forEach(platform => {
                    if (!Array.from(select.options).some(opt => opt.value === platform)) {
                        const option = document.createElement("option");
                        option.value = platform;
                        option.text = platform;
                        select.appendChild(option);
                    }
                });
            }
        }

        function reinsertOption(platform) {
            let select = containerDiv.querySelector("select.add-platform-select");
            if (!select && dd.querySelectorAll("img.platform-icon").length < 4) {
                updateOrCreateSelect();
                select = containerDiv.querySelector("select.add-platform-select");
            }
            if (select) {
                if (!Array.from(select.options).some(opt => opt.value === platform)) {
                    const option = document.createElement("option");
                    option.value = platform;
                    option.text = platform;
                    select.appendChild(option);
                }
            }
        }

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
            button.innerText = "Save";
            button.style.backgroundColor = "green";

            if (dd.querySelectorAll("img.platform-icon").length < 4) {
                updateOrCreateSelect();
            }

            dd.querySelectorAll("img.platform-icon").forEach(icon => {
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
                                reinsertOption(platformName);
                                // Remove the corresponding possible-form div
                                removePossibleForm(platformName);
                            })
                            .catch(error => console.error("Error:", error));
                    }
                });
            });
        }
    }
});





document.addEventListener("click", function (event) {
    if (event.target.classList.contains("edit")) {
        event.preventDefault();
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
                // Special validation for StartDate and EndDate
                if ((input.id === "StartDate" && new Date(input.value) > new Date(convertDateFormat(document.querySelector("#EndDate").textContent.trim()))) ||
                    (input.id === "EndDate" && new Date(input.value) < new Date(convertDateFormat(document.querySelector("#StartDate").textContent.trim())))) {
                    console.log("End date must be later than start date.");
                    input.setCustomValidity("End date must be later than start date.");
                    input.reportValidity();
                    input.setCustomValidity(""); // Reset custom validity after reporting
                    return;
                }
                // Special validation for game name
                else if (input.id === "Name") {
                    // Check if game name is unique using fetch and then
                    checkGameNameUnique(input.value).then(isUnique => {
                        if (!isUnique) {
                            console.log("Game name must be unique.");
                            input.setCustomValidity("Game name must be unique.");
                            input.reportValidity();
                            input.setCustomValidity(""); // Reset custom validity after reporting
                            return;
                        }

                        // If game name is unique, proceed with saving
                        modifyField(gameId, fieldName, newValue);

                        dd.textContent = newValue;
                        if (dd.classList.contains("expired") || dd.classList.contains("available")) {
                            dd.classList = "";
                            dd.classList.add(newValue > 0 ? "available" : "expired");
                        }
                        button.innerText = "Edit";
                        button.style.backgroundColor = "";
                        event.preventDefault();
                    }).catch(error => {
                        console.error("Error checking game name uniqueness:", error);
                    });
                    return; // Prevent further execution until the name check completes
                }

                modifyField(gameId, fieldName, newValue);

                dd.textContent = newValue;
                if (dd.classList.contains("expired") || dd.classList.contains("available")) {
                    dd.classList = "";
                    dd.classList.add(newValue > 0 ? "available" : "expired");
                }
                button.innerText = "Edit";
                button.style.backgroundColor = "";

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
        createNotificaton("Success", `${fieldName} successfully modified to ${newValue}`, "positive");
    } else {
        createNotificaton("Error", data["message"], "negative");
    }
}


document.querySelector(".add").addEventListener("click", function () {


});



function createDiscountPopup(gameId, gameName) {
    // Remove any existing popup before creating a new one
    let existingPopup = document.getElementById("discount-popup");
    if (existingPopup) {
        existingPopup.remove();
    }

    let bigDiv = document.createElement("div");
    bigDiv.classList.add("popup");
    bigDiv.id = "discount-popup";

    let html = `
    <div class="popup-content">
        <h2>Aggiungi sconto</h2>
        <h3>${gameName}</h3>
        <form id="discount-form">
            <div>
                <label for="discount">Sconto (-%):</label>
                <input type="number" id="discount" name="discount" min="1" max="100" required>
            </div>
            <div>
                <label for="start-date">Inizio:</label>
                <input type="date" id="start-date" name="start-date" required>
            </div>
            <div>
                <label for="end-date">Fine:</label>
                <input type="date" id="end-date" name="end-date" required>
            </div>
        </form>
        <button id="add-discount" disabled>Aggiungi</button>
        <button id="cancel-discount">Annulla</button>
    </div>
    `;

    bigDiv.innerHTML = html;
    document.body.insertBefore(bigDiv, document.body.firstChild);

    const startDateInput = bigDiv.querySelector("#start-date");
    const endDateInput = bigDiv.querySelector("#end-date");
    const addDiscountBtn = bigDiv.querySelector("#add-discount");

    // Set default start date to today
    let today = new Date().toISOString().split("T")[0];
    startDateInput.value = today;
    startDateInput.min = today;
    endDateInput.min = today;

    function validateDates() {
        let startDate = new Date(startDateInput.value);
        let endDate = new Date(endDateInput.value);

        if (startDate >= endDate) {
            endDateInput.setCustomValidity("La data di fine deve essere successiva alla data di inizio.");
        } else {
            endDateInput.setCustomValidity("");
        }

        addDiscountBtn.disabled = startDate >= endDate;
    }

    startDateInput.addEventListener("change", () => {
        endDateInput.min = startDateInput.value;
        validateDates();
    });



    endDateInput.addEventListener("change", validateDates);

    bigDiv.querySelector("#cancel-discount").addEventListener("click", function () {
        bigDiv.remove();
    });

    //listener for the add discount button
    bigDiv.querySelector("#add-discount").addEventListener("click", function () {
        let discount = bigDiv.querySelector("#discount").value;
        let startDate = bigDiv.querySelector("#start-date").value;
        let endDate = bigDiv.querySelector("#end-date").value;

        addDiscount(gameId, discount, startDate, endDate)
            .then(() => {
                bigDiv.remove();
                //reload the page to show the new discount
                location.reload();
            })
            .catch(error => console.error("Error:", error));
    });
}


async function addDiscount(gameId, discount, startDate, endDate) {
    let formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Discount", discount);
    formData.append("StartDate", startDate);
    formData.append("EndDate", endDate);

    const url = "api/add-discount-api.php";
    let response = await fetch(url, {
        method: "POST",
        body: formData
    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", "Discount added successfully!", "positive");
    } else {
        switch (data["message"]) {
            case "not_logged":
                createNotificaton("Error", "You must be logged in to add a discount", "negative");
                break;
            case "missing_params":
                createNotificaton("Error", "Missing parameters", "negative");
                break;
            default:
                createNotificaton("Error", "An unknown error occurred while adding the discount", "negative");
        }
    }
}

function convertDateFormat(dateStr) {
    // Supponiamo che il formato della data sia "DD/MM/YY"
    const parts = dateStr.split('/');
    // Converte in formato "YYYY-MM-DD" (aggiunge 20 per l'anno)
    const year = '20' + parts[2];
    const month = parts[1].padStart(2, '0'); // Aggiunge 0 per mesi a una cifra
    const day = parts[0].padStart(2, '0'); // Aggiunge 0 per giorni a una cifra

    return `${year}-${month}-${day}`;
}

// Async function to check if the game name is unique
async function checkGameNameUnique(gameName) {
    const response = await fetch('api/check-game-name-api.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ gameName: gameName })
    });

    const data = await response.json();
    return data.isUnique;
}