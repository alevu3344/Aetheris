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

