document.querySelectorAll(".platform-button").forEach(label => {
    const checkbox = label.querySelector(".platform-checkbox");
    const quantityInput = label.querySelector("input[type='number']");

    label.addEventListener("click", (event) => {
        if (event.target !== quantityInput) {
            checkbox.checked = !checkbox.checked;
            quantityInput.disabled = !checkbox.checked;

            if (!checkbox.checked) {
                quantityInput.value = ""; // Clear value if unchecked
                quantityInput.removeAttribute("required"); // Remove required if unchecked
            } else {
                quantityInput.setAttribute("required", "required"); // Add required if checked
            }
        }
    });

    checkbox.addEventListener("change", () => {
        quantityInput.disabled = !checkbox.checked;
        if (!checkbox.checked) {
            quantityInput.value = "";
            quantityInput.removeAttribute("required");
        } else {
            quantityInput.setAttribute("required", "required");
        }
    });
});

document.getElementById("add-game-form").addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent normal submission

    let isValid = true;
    document.querySelectorAll(".platform-checkbox").forEach(checkbox => {
        const quantityInput = checkbox.closest("label").querySelector("input[type='number']");

        if (checkbox.checked) {
            if (!quantityInput.value || quantityInput.value <= 0) {
                isValid = false;
                quantityInput.setCustomValidity("Enter a valid quantity!");
                quantityInput.reportValidity(); // Show validation message
            } else {
                quantityInput.setCustomValidity(""); // Reset validation
            }
        }
    });

    if (!isValid) return; // Stop form submission if validation fails

    var formData = new FormData(this);
    console.log(formData);
    addGame(formData);
});




document.querySelector("#checkbox-PC").addEventListener("change", function () {
    console.log("checkbox-PC changed");

    if (this.checked) {
        console.log("checked");
        addGameRequirements();
        let pcRequirements = document.querySelector("#pc-requirements");
    } else {
        console.log("unchecked");
        let pcRequirements = document.querySelector("#pc-requirements");
        document.querySelector("#pc-requirements").remove();

        // Reset input values inside the fieldset
        pcRequirements.querySelectorAll("input").forEach(input => {
            input.value = "";
        });
    }

});

function addGameRequirements() {

    let fieldset = `
    <fieldset id="pc-requirements">
                <legend>Minimum System Requirements</legend>

                <label for="min-os"> Operating System:
                    <input type="text" id="min-os" name="pc_requirements[os]"/>
                </label>

                <label for="min-ram">RAM (GB):
                    <input type="number" id="min-ram" name="pc_requirements[ram]" min="1"/>
                </label>

                <label for="min-gpu">GPU:
                    <input type="text" id="min-gpu" name="pc_requirements[gpu]"/>
                </label>

                <label for="min-cpu">CPU:
                    <input type="text" id="min-cpu" name="pc_requirements[cpu]"/>
                </label>

                <label for="min-ssd">SSD (GB):
                    <input type="number" id="min-ssd" name="pc_requirements[ssd]" min="1"/>
                </label>
            </fieldset>
    `;

     // Find the element where you want to insert the new fieldset
     let platformsFieldset = document.querySelector("#platforms-fieldset");

     // Insert the fieldset after the platform section (it will move all content below it)
     platformsFieldset.insertAdjacentHTML("afterend", fieldset);


}



async function addGame(formData) {

    const url = "api/add-new-game-api.php";
    const response = await fetch(url, {
        method: "POST",
        body: formData
    })

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", "Game added successfully", "positive");
    }
    else {
        switch (data["message"]) {
            case "not-logged":
                createNotificaton("Error", "You need to be logged in to add a game", "negative");
                break;
            case "not_admin":
                createNotificaton("Error", "You need to be an admin to add a game", "negative");
                break;
            case "upload-error":
                createNotificaton("Error", "There was an error uploading the image", "negative");
                break;
            case "game_add_error":
                createNotificaton("Error", "There was an error adding the game", "negative");
                break;
            case "no_image_uploaded":
                createNotificaton("Error", "You need to upload an image", "negative");
                break;
            case "invalid_request":
                createNotificaton("Error", "Invalid request", "negative");
                break;
            case "invalid_image_extension":
                createNotificaton("Error", "Invalid image extension", "negative");
                break;
            default:
                createNotificaton("Error", data["message"], "negative");
        }
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

