document.getElementById("add-game-form").addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent the form from submitting normally


    var formData = new FormData(this);

    console.log(formData);

    addGame(formData);




});

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

