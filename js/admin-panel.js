const scriptUrlAdmin = new URL(document.currentScript.src); // Get the script's URL
const publishers = scriptUrlAdmin.searchParams.get("publishers"); // Get the game parameter
const categories = scriptUrlAdmin.searchParams.get("categories"); // Get the game parameter

let publishersList = [];
try {
    publishersList = JSON.parse(decodeURIComponent(publishers)); // Parse the JSON
} catch (error) {
    console.error("Error parsing publishers:", error);
}

console.log("Publishers:", publishers);

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

document.querySelectorAll(".edit").forEach(button => {
    button.addEventListener("click", function () {
        let dtContainer = this.parentElement; // Contains <button> and <dt>
        let dd = dtContainer.parentElement.querySelector("dd"); // Find the associated <dd>
        let dt = dtContainer.querySelector("dt"); // Find the <dt> for the label

        if (!dd) return;

        let isEditing = this.innerText === "Save"; // Check if we are already in edit mode

        if (isEditing) {
            // 🔹 Save the value and revert to "Edit"
            let input = dd.querySelector("input, select");
            if (input) {
                let newValue = input.value.trim();
                dd.innerText = newValue || input.defaultValue; // If empty, restore the old value
            }
            this.innerText = "Edit";
            this.style.backgroundColor = ""; // Revert to the original color
        } else {
            let currentValue = dd.innerText.trim();

            // If the field is "Sviluppatore", use a <select>
            if (dt && dt.innerText.trim() === "Sviluppatore:") {
                let select = document.createElement("select");



                // 🔹 Generate the options for the select element
                publishersList.forEach(publisher => {
                    let option = document.createElement("option");
                    option.value = publisher.PublisherName; // Use PublisherName as the option value
                    option.textContent = publisher.PublisherName; // Set the display text
                    if (publisher.PublisherName === currentValue) {
                        option.selected = true; // Pre-select the option if it matches the current value
                    }
                    select.appendChild(option);
                });

                select.classList.add("edit-select");

                // Clear the <dd> and append the select dropdown
                dd.innerHTML = "";
                dd.appendChild(select);
                select.focus();

                this.innerText = "Save";
                this.style.backgroundColor = "green";

                // Save the selected value when the select loses focus or changes
                function saveEdit() {
                    let newValue = select.value.trim();
                    dd.innerText = newValue || currentValue; // Save the new value or revert to old if empty
                    button.innerText = "Edit";
                    button.style.backgroundColor = "";
                }

                select.addEventListener("blur", saveEdit);
                select.addEventListener("change", saveEdit);
            } else {
                // 🔹 For other fields, use an <input>
                let input = document.createElement("input");
                input.type = "text";
                input.value = currentValue;
                input.classList.add("edit-input");

                // Clear the <dd> and append the input field
                dd.innerHTML = "";
                dd.appendChild(input);
                input.focus();

                this.innerText = "Save";
                this.style.backgroundColor = "green";

                // Save the edited value when the input loses focus or the Enter key is pressed
                function saveEdit() {
                    let newValue = input.value.trim();
                    dd.innerText = newValue || currentValue; // Save the new value or revert to old if empty
                    button.innerText = "Edit";
                    button.style.backgroundColor = "";
                }

                function revertEdit() {
                    dd.innerText = currentValue;
                    button.innerText = "Edit";
                    button.style.backgroundColor = "";
                }

                input.addEventListener("blur", revertEdit);
                input.addEventListener("keypress", function (event) {
                    if (event.key === "Enter") saveEdit();
                });
            }
        }
    });
});


function updateField(fieldContainer, newValue) {
    let gameId = fieldContainer.closest("li.game").id;
    let fieldName = fieldContainer.querySelector("dt").innerText.replace(":", "").trim();

    fetch("../api/update_game.php", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            gameId: gameId,
            field: fieldName,
            value: newValue
        })
    })
        .then(response => response.json())
        .then(data => {
            if (!data.success) {
                alert("Errore nell'aggiornamento");
            }
        })
        .catch(error => console.error("Errore:", error));
}