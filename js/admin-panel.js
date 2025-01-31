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

            } else {
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
                        input.min = 1;
                        input.step = 1;
                        label.textContent = "PC Quantity";
                        input.required = true;

                        break;
                    case "Xbox":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 1;
                        input.step = 1;
                        label.textContent = "Xbox Quantity";
                        input.required = true;

                        break;
                    case "PlayStation":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 1;
                        input.step = 1;
                        label.textContent = "PlayStation Quantity";
                        input.required = true;

                        break;

                    case "Nintendo_Switch":
                        input.type = "number";
                        //has to be > 0 and integer
                        input.min = 1;
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