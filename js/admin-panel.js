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
    game.querySelector(".actions > .delete").addEventListener("click", async () => {
        const confirmed = await showConfirmationPopup("Are you sure you want to delete this game?");
        if (confirmed) {
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
                        deleteButton.addEventListener("click", async (e) => {
                            const confirmed = await showConfirmationPopup("Are you sure you want to delete this category?");
                            if (confirmed) {
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

                deleteButton.addEventListener("click", async (e) => {
                    const confirmed = await showConfirmationPopup("Are you sure you want to delete this category?");
                    if (confirmed) {
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

                        deleteButton.addEventListener("click", async (e) => {
                            const confirmed = await showConfirmationPopup("Are you sure you want to delete this platform?");
                            if (confirmed) {
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

                deleteButton.addEventListener("click", async (e) => {
                    const confirmed = await showConfirmationPopup("Are you sure you want to delete this platform?");
                    if (confirmed) {
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

        const dtContainer = button.parentElement;
        let dd = dtContainer.parentElement.querySelector("dd");
        let dt = dtContainer.querySelector("dt");

        const containerDiv = dd.closest(".possible-form");
        let divInner = containerDiv.innerHTML;

        if (!dd) return;

        if (button.innerText === "Save") {
            const input = dd.querySelector("input, select");
            const newValue = input.value.trim();
            const gameId = button.closest(".game").id;
            const fieldName = dd.id;

            // Check input validity before saving
            if (input.checkValidity()) {
                // Special validation for StartDate and EndDate
                if ((input.id === "StartDate" && new Date(input.value) > new Date(convertDateFormat(document.querySelector("#EndDate").textContent.trim()))) ||
                    (input.id === "EndDate" && new Date(input.value) < new Date(convertDateFormat(document.querySelector("#StartDate").textContent.trim())))) {
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
            if (dt && dt.innerText.trim() === "Publisher:") {
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


document.addEventListener("click", async function (event) {
    if (event.target.classList.contains("remove-discount")) {
        let button = event.target;
        const gameId = button.closest(".game").id;
        const confirmed = await showConfirmationPopup("Are you sure you want to remove this discount?");
        if (confirmed) {
            removeDiscount(gameId).then(
                () => {
                    location.reload();
                }
            )
                .catch(error => console.error("Error:", error));
        }
    }
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
        <h2>Add a discount</h2>
        <h3>${gameName}</h3>
        <form id="discount-form">
            <div>
                <label for="discount">Discount (-%):</label>
                <input type="number" id="discount" name="discount" min="1" max="100" required>
            </div>
            <div>
                <label for="start-date">Start:</label>
                <input type="date" id="start-date" name="start-date" required>
            </div>
            <div>
                <label for="end-date">End:</label>
                <input type="date" id="end-date" name="end-date" required>
            </div>
        </form>
        <button id="add-discount" disabled>Add</button>
        <button id="cancel-discount">Cancel</button>
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
        const input = document.querySelector("#discount-form #discount");
        if (!input.checkValidity()) {
            input.setCustomValidity("The discount must be a number between 1 and 100.");
            input.reportValidity();
            input.setCustomValidity("");
            return;
        }

        addDiscount(gameId, discount, startDate, endDate)
            .then(() => {
                bigDiv.remove();
                //reload the page to show the new discount
                location.reload();
            })
            .catch(error => console.error("Error:", error));
    });
}

async function removeDiscount(gameId) {
    let formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Action", "remove");

    const url = "api/add-discount-api.php";
    let response = await fetch(url, {
        method: "POST",
        body: formData
    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", "Discount removed successfully!", "positive");
    } else {
        switch (data["message"]) {
            case "not_logged":
                createNotificaton("Error", "You must be logged in to add a discount", "negative");
                break;
            case "missing_params":
                createNotificaton("Error", "Missing parameters", "negative");
                break;
            default:
                createNotificaton("Error", "An unknown error occurred while removing the discount", "negative");
        }
    }
}


async function addDiscount(gameId, discount, startDate, endDate) {
    let formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Discount", discount);
    formData.append("StartDate", startDate);
    formData.append("EndDate", endDate);
    formData.append("Action", "add")

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





document.addEventListener("click", function (event) {
    if (event.target.classList.contains("modify-images")) {
        event.preventDefault();
        let button = event.target;

        // Save the initial content for restoring when clicking Cancel
        const containerDiv = button.closest(".images");
        let divInner = containerDiv.innerHTML;

        const form = document.createElement("form");
        form.classList.add("images");
        form.innerHTML = divInner;

        const section = button.closest("section");
        // Remove the containerDiv and add the form
        containerDiv.remove();
        // Insert the form as the first child of section
        section.insertBefore(form, section.firstChild);

        // Create a Cancel button and put it before the button
        const cancelButton = document.createElement("button");
        cancelButton.innerText = "Cancel";
        cancelButton.classList.add("cancel");
        // Put the cancel button as the first child of form
        form.insertBefore(cancelButton, form.firstChild);
        cancelButton.addEventListener("click", function (e) {
            e.preventDefault();
            // Restore the previous content
            form.remove(); // Remove the form
            containerDiv.innerHTML = divInner;
            section.insertBefore(containerDiv, section.firstChild); // Restore the original content
        });

        // Change the modify-images button into a Save button
        button = form.querySelector(".modify-images");
        button.innerText = "Save";
        button.classList.remove("modify-images");
        button.classList.add("save-images");
        button.type = "submit";

        // Add the "exchange" button in the top-right corner of each image
        form.querySelectorAll("img").forEach(img => {
            // Create a wrapper div for the image
            const wrapper = document.createElement("div");
            wrapper.classList.add("image-wrapper");
            img.parentNode.replaceChild(wrapper, img);
            wrapper.appendChild(img);

            // Create the change (exchange) button
            const changeButton = document.createElement("button");
            changeButton.classList.add("change-image");
            changeButton.innerHTML = `<img src="upload/icons/change.png" alt="Change image"/>`;
            wrapper.appendChild(changeButton);

            // Event listener for changing the image
            changeButton.addEventListener("click", function (e) {
                e.preventDefault();

                // Create a file input
                const fileInput = document.createElement("input");
                fileInput.type = "file";
                fileInput.accept = "image/*";
                fileInput.classList.add("image-input");

                // Replace the current wrapper (using the current parent of the button) with the file input
                this.parentNode.replaceWith(fileInput);

                // Auto-click the file input to prompt selection
                fileInput.click();

                // When a file is selected, update the image
                fileInput.addEventListener("change", function () {
                    if (fileInput.files.length > 0) {
                        const reader = new FileReader();
                        reader.onload = (e) => {
                            // Create an image object from the uploaded file
                            const imgObj = new Image();
                            imgObj.onload = function () {
                                // Determine original dimensions and desired aspect ratio
                                const origWidth = imgObj.width;
                                const origHeight = imgObj.height;
                                const desiredAspect = 16 / 9;
                                const currentAspect = origWidth / origHeight;

                                let cropWidth, cropHeight, offsetX, offsetY;
                                if (currentAspect > desiredAspect) {
                                    // Image is too wide: crop the sides
                                    cropHeight = origHeight;
                                    cropWidth = cropHeight * desiredAspect;
                                    offsetX = (origWidth - cropWidth) / 2;
                                    offsetY = 0;
                                } else {
                                    // Image is too tall: crop the top and bottom
                                    cropWidth = origWidth;
                                    cropHeight = cropWidth / desiredAspect;
                                    offsetX = 0;
                                    offsetY = (origHeight - cropHeight) / 2;
                                }

                                // Create a canvas to perform the cropping
                                const canvas = document.createElement("canvas");
                                canvas.width = cropWidth;
                                canvas.height = cropHeight;
                                const ctx = canvas.getContext("2d");

                                // Draw the cropped area onto the canvas
                                ctx.drawImage(imgObj, offsetX, offsetY, cropWidth, cropHeight, 0, 0, cropWidth, cropHeight);

                                // Get the data URL for the cropped image
                                const croppedDataUrl = canvas.toDataURL("image/jpeg");

                                // Create a new image element for the cropped image
                                const newImg = document.createElement("img");
                                newImg.src = croppedDataUrl;
                                newImg.alt = "New uploaded image";
                                newImg.classList.add("modified");


                                // Create a new wrapper, append the new image and reattach the same change button
                                const newWrapper = document.createElement("div");
                                newWrapper.classList.add("image-wrapper");
                                newWrapper.appendChild(newImg);
                                newWrapper.appendChild(changeButton); // reattach the existing button

                                // Replace the file input with the new wrapper
                                fileInput.replaceWith(newWrapper);
                            };
                            // Set the source of the image object to trigger onload
                            imgObj.src = e.target.result;
                        };
                        reader.readAsDataURL(fileInput.files[0]);
                    }
                });

            });
        });
        // Add a click listener to the Save button that calls the async function
        button.addEventListener("click", async function (e) {
            e.preventDefault();
            const gameId = button.closest(".game").id;

            // Check if there is any modified image in the form
            const modifiedImages = form.querySelectorAll("img.modified");
            if (modifiedImages.length === 0) {
                //restore the previous content
                form.remove(); // Remove the form
                section.insertBefore(containerDiv, section.firstChild); // Restore the original content
                return;
            }

            try {

                const result = await sendModifiedImages(gameId);
                if (result) {
                    location.reload();
                }
            } catch (error) {
                console.error("Error uploading images:", error);
            }
        });
    }
});





function dataURLToBlob(dataURL) {
    const [header, data] = dataURL.split(',');
    const mimeMatch = header.match(/:(.*?);/);
    if (!mimeMatch) {
        throw new Error("Invalid data URL");
    }
    const mime = mimeMatch[1];
    const binary = atob(data);
    const array = [];
    for (let i = 0; i < binary.length; i++) {
        array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], { type: mime });
}


async function sendModifiedImages(gameId) {
    const formData = new FormData();

    formData.append("GameId", gameId);

    // Process Cover Image
    const coverImg = document.querySelector("form > .image-wrapper > img");
    if (coverImg && coverImg.classList.contains("modified")) {
        const coverBlob = dataURLToBlob(coverImg.src);
        formData.append("cover", coverBlob, "cover.jpg");
    }

    // Process Screenshots
    const screenshots = document.querySelectorAll(".screenshots > .image-wrapper > img");
    const modifiedScreenshots = [];

    screenshots.forEach((img, index) => {
        if (img.classList.contains("modified")) {
            const blob = dataURLToBlob(img.src);
            const screenshotNumber = index + 1;
            formData.append(`screenshot_${screenshotNumber}`, blob, `screenshot_${screenshotNumber}.jpg`);
            modifiedScreenshots.push({ imgElement: img, number: screenshotNumber });
        }
    });

    try {
        // Send the FormData to the server
        const response = await fetch("api/modify-images-api.php", {
            method: "POST",
            body: formData,
        });

        if (!response.ok) {
            throw new Error(`Server error: ${response.status}`);
        }

        const result = await response.json();

        // If the update succeeds, update the images in containerDiv
        if (coverImg && coverImg.classList.contains("modified")) {
            coverImg.src = `${coverImg.src}?t=${new Date().getTime()}`;
            coverImg.classList.remove("modified");
        }

        modifiedScreenshots.forEach(({ imgElement, number }) => {
            imgElement.src = `${imgElement.src}?t=${new Date().getTime()}`;
            imgElement.classList.remove("modified");
        });

        return result;
    } catch (error) {
        console.error("Error uploading images:", error);
        throw error;
    }
}

