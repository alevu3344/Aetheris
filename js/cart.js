const trashButtons = document.querySelectorAll('ul > li > div > section > header button');

// Add event listener to each button
trashButtons.forEach((trashButton, index) => {
    const closestLi = trashButton.closest('li');
    const gameId = closestLi.querySelector('a').href.split('id=')[1];
    const platform = closestLi.querySelector("div > section > p > img").getAttribute("alt");

    // Trash button: remove entire item from cart
    trashButton.addEventListener("click", async (event) => {
        event.preventDefault();
        console.log(`Game with ID ${gameId} and platform ${platform} has been removed.`);
        await removeFromCart(gameId, platform, -1);
        closestLi.remove();
    });

    // Decrease button: decrease quantity
    closestLi.querySelector("div > section > footer > div > button:nth-child(1)").addEventListener("click", async (event) => {
        event.preventDefault();
        console.log(`Game with ID ${gameId} and platform ${platform} decreased.`);
        await removeFromCart(gameId, platform, 1);
        
        // Update the quantity in the DOM only after the async call returns
        let quantityText = closestLi.querySelector("div > section > footer > div > span");
        let quantity = parseInt(quantityText.innerText);
        quantity--;
        if (quantity <= 0) {
            closestLi.remove();
        } else {
            quantityText.innerText = quantity;
        }
    });

    // Increase button: increase quantity
    closestLi.querySelector("div > section > footer > div > button:nth-child(3)").addEventListener("click", async (event) => {
        event.preventDefault();
        await addToCart(gameId, platform, 1);
        
        // Update the quantity in the DOM only after the async call returns
        let quantityText = closestLi.querySelector("div > section > footer > div > span");
        let quantity = parseInt(quantityText.innerText);
        quantity++;
        quantityText.innerText = quantity;
    });
});


const checkoutButton = document.querySelector("main > #checkout");
checkoutButton.addEventListener("click", async (event) => {
    event.preventDefault();

    // If no items in the cart, show error style
    if (document.querySelectorAll("main > ul > li").length == 0) {
        checkoutButton.style.backgroundColor = "red";
        checkoutButton.innerText = "Carrello vuoto";
        return;
    }

    // Show the custom confirmation popup
    const confirmed = await showConfirmationPopup();
    if (confirmed) {
        checkout();
    }
});


function showConfirmationPopup() {
    return new Promise((resolve) => {
        // Create overlay for the popup
        const overlay = document.createElement('div');
        overlay.style.position = 'fixed';
        overlay.style.top = 0;
        overlay.style.left = 0;
        overlay.style.width = '100%';
        overlay.style.height = '100%';
        overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
        overlay.style.display = 'flex';
        overlay.style.alignItems = 'center';
        overlay.style.justifyContent = 'center';
        overlay.style.zIndex = 1000;

        // Create popup container
        const popup = document.createElement('div');
        popup.style.backgroundColor = '#fff';
        popup.style.padding = '20px';
        popup.style.borderRadius = '5px';
        popup.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';
        popup.style.minWidth = '300px';
        popup.style.textAlign = 'center';

        // Create message element
        const message = document.createElement('p');
        message.innerText = "Sei sicuro di voler procedere al checkout?";
        popup.appendChild(message);

        // Create buttons container
        const buttonsContainer = document.createElement('div');
        buttonsContainer.style.marginTop = '20px';
        buttonsContainer.style.display = 'flex';
        buttonsContainer.style.justifyContent = 'space-around';

        // Create Confirm button
        const confirmButton = document.createElement('button');
        confirmButton.innerText = "Conferma";
        confirmButton.style.padding = '10px 20px';
        confirmButton.style.backgroundColor = '#4CAF50';
        confirmButton.style.color = '#fff';
        confirmButton.style.border = 'none';
        confirmButton.style.borderRadius = '3px';
        confirmButton.style.cursor = 'pointer';
        confirmButton.addEventListener('click', () => {
            document.body.removeChild(overlay);
            resolve(true);
        });

        // Create Cancel button
        const cancelButton = document.createElement('button');
        cancelButton.innerText = "Annulla";
        cancelButton.style.padding = '10px 20px';
        cancelButton.style.backgroundColor = '#f44336';
        cancelButton.style.color = '#fff';
        cancelButton.style.border = 'none';
        cancelButton.style.borderRadius = '3px';
        cancelButton.style.cursor = 'pointer';
        cancelButton.addEventListener('click', () => {
            document.body.removeChild(overlay);
            resolve(false);
        });

        // Append buttons to container and container to popup
        buttonsContainer.appendChild(confirmButton);
        buttonsContainer.appendChild(cancelButton);
        popup.appendChild(buttonsContainer);

        // Append popup to overlay and overlay to the body
        overlay.appendChild(popup);
        document.body.appendChild(overlay);
    });
}



async function addToCart(gameId, platform, quantity) {

    const formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Platform", platform);
    formData.append("Quantity", quantity);
    formData.append("Action", "add");

    // Send a POST request to the server with the purchase details
    let response = await fetch("api/cart-api.php", {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (!data["success"]) {
        switch (data["message"]) {
            case "not_logged":
                createNotificaton("Error", "Log in to add games to your cart", "negative");
                break;
            case "invalid_request":
                createNotificaton("Error", "Invalid Request", "negative");
                break;
            default:
                createNotificaton("Error", "Unknown error", "negative");
                break;

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

//use the GET method, the server already has everything, its simpy a message to checkout
async function checkout() {
    const url = "api/cart-api.php?action=checkout";
    let response = await fetch(url, {
        method: "GET"
    });

    let data = await response.json();

    if (data["success"]) {

        createNotificaton("Success", "Checkout was succesful", "positive");
    } else {

        switch (data["message"]) {
            case "not_logged":
                createNotificaton("Error", "Log in to checkout", "negative");
                break;
            case "empty_cart":
                createNotificaton("Error", "Cart is empty", "negative");
                break;
            case "no_funds":
                createNotificaton("Error", "Not enough funds", "negative");
                break;
            case "out_of_stock":
                createNotificaton("Error", `${data["game_name"]} for ${data["platform"]} has only ${data["available_stock"]} in stock, you requested ${data["requested_quantity"]}`, "negative");
                break;
            default:
                createNotificaton("Error", "Unknown error", "negative");
                break;
        }
    }
}


async function removeFromCart(gameId, platform, quantity) {

    const formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Platform", platform);
    formData.append("Quantity", quantity);
    formData.append("Action", "remove");

    // Send a POST request to the server with the purchase details
    let response = await fetch("api/cart-api.php", {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (!data.success) {
        console.error("HTTP-Error: " + response.status);
        createNotificaton("Error", data.message, "negative");
    }
}

