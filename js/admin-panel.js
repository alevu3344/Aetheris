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
        let dtContainer = this.parentElement; // Contiene <button> e <dt>
        let dd = dtContainer.parentElement.querySelector("dd"); // Trova il <dd> associato

        if (!dd) return;

        let isEditing = this.innerText === "Save"; // Controlla se siamo già in modalità modifica

        if (isEditing) {
            // 🔹 Salva il valore e torna a "Edit"
            let input = dd.querySelector("input");
            if (input) {
                let newValue = input.value.trim();
                dd.innerText = newValue || input.defaultValue; // Se vuoto, ripristina vecchio valore
            }
            this.innerText = "Edit";
            this.style.backgroundColor = ""; // Torna al colore originale
        } else {
            // 🔹 Entra in modalità modifica
            let currentValue = dd.innerText.trim();
            let input = document.createElement("input");
            input.type = "text";
            input.value = currentValue;
            input.classList.add("edit-input");

            dd.innerHTML = "";
            dd.appendChild(input);
            input.focus();

            this.innerText = "Save";
            this.style.backgroundColor = "green";

            // 🔹 Salva anche con ENTER o quando l'input perde il focus
            function saveEdit() {
                let newValue = input.value.trim();
                dd.innerText = newValue || currentValue;
                button.innerText = "Edit";
                button.style.backgroundColor = "";
            }

            input.addEventListener("blur", saveEdit);
            input.addEventListener("keypress", function (event) {
                if (event.key === "Enter") saveEdit();
            });
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