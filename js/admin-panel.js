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



document.querySelectorAll(".edit").forEach(button => {
    button.addEventListener("click", function() {
        const dtContainer = this.parentElement;
        const dd = dtContainer.parentElement.querySelector("dd");
        const dt = dtContainer.querySelector("dt");
        
        if (!dd) return;
        
        // If we're currently editing (button says "Save")
        if (this.innerText === "Save") {
            const input = dd.querySelector("input, select");
            if (!input) return;
            
            // Save the new value
            const newValue = input.value.trim();
            
            // Update the field in the database
            const gameId = button.closest(".game").id;
            const fieldName = dt.innerText.trim().replace(":", "");
            modifyField(gameId, fieldName, newValue);
            
            // Update the display
            dd.textContent = newValue;
            this.innerText = "Edit";
            this.style.backgroundColor = "";
            
        } else {
            // Starting to edit (button currently says "Edit")
            const currentValue = dd.textContent.trim();
            
            // Check if this is the Sviluppatore field
            if (dt && dt.innerText.trim() === "Sviluppatore:") {
                // Create select element
                const select = document.createElement("select");
                select.classList.add("edit-select");
                
                // Add options
                publishersList.forEach(publisher => {
                    const option = document.createElement("option");
                    option.value = publisher.PublisherName;
                    option.textContent = publisher.PublisherName;
                    option.selected = (publisher.PublisherName === currentValue);
                    select.appendChild(option);
                });
                
                // Replace content with select
                dd.textContent = "";
                dd.appendChild(select);
                select.focus();
                
                // Add blur handler for reverting
                select.addEventListener("blur", () => {
                    // Short timeout to allow click events to process first
                    setTimeout(() => {
                        if (button.innerText === "Save") {  // Only revert if we haven't saved
                            dd.textContent = currentValue;
                            button.innerText = "Edit";
                            button.style.backgroundColor = "";
                        }
                    }, 200);
                });
                
            } else {
                // Create input for other fields
                const input = document.createElement("input");
                input.type = "text";
                input.value = currentValue;
                
                input.classList.add("edit-input");
                
                // Replace content with input
                dd.textContent = "";
                dd.appendChild(input);
                input.focus();
                
                // Add blur handler for reverting
                input.addEventListener("blur", () => {
                    // Short timeout to allow click events to process first
                    setTimeout(() => {
                        if (button.innerText === "Save") {  // Only revert if we haven't saved
                            dd.textContent = currentValue;
                            button.innerText = "Edit";
                            button.style.backgroundColor = "";
                        }
                    }, 200);
                });
                
                // Add enter key handler
                input.addEventListener("keypress", (event) => {
                    if (event.key === "Enter") {
                        const newValue = input.value.trim();
                        const gameId = button.closest(".game").id;
                        const fieldName = dt.innerText.trim().replace(":", "");
                        modifyField(gameId, fieldName, newValue);
                        
                        dd.textContent = newValue;
                        button.innerText = "Edit";
                        button.style.backgroundColor = "";
                    }
                });
            }
            
            // Update button state
            this.innerText = "Save";
            this.style.backgroundColor = "green";
        }
    });
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