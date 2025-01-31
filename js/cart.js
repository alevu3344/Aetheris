//add a listener to the trash bin img inside the a 
document.addEventListener("DOMContentLoaded", () => {
    // Select all trash buttons
    const trashButtons = document.querySelectorAll('ul > li > div > section > header button');


    // Add event listener to each button
    trashButtons.forEach((trashButton, index) => {

        const closestLi = trashButton.closest('li');
        const gameId = closestLi.querySelector('a').href.split('id=')[1];
        const platform = closestLi.querySelector("div > section > p > img").getAttribute("alt");

        trashButton.addEventListener("click", (event) => {
            event.preventDefault();
            console.log(`Game with ID ${gameId} and platform ${platform} has been removed.`);
            removeFromCart(gameId, platform, -1);
            closestLi.remove();
        });

        //decrease button
        closestLi.querySelector("div > section > footer > div > button:nth-child(1)").addEventListener("click", (event) => {
            event.preventDefault();

            console.log(`Game with ID ${gameId} and platform ${platform} decreased.`);
            removeFromCart(gameId, platform, 1);
            //update the span text
            let quantityText = closestLi.querySelector("div > section > footer > div > span");
            let quantity = parseInt(quantityText.innerText);
            quantity--;
            if (quantity <= 0) {
                closestLi.remove();
            } else {
                quantityText.innerText = quantity;
            }

        });

        //increase button
        closestLi.querySelector("div > section > footer > div > button:nth-child(3)").addEventListener("click", (event) => {
            event.preventDefault();


            addToCart(gameId, platform, 1);
            //update the span text
            let quantityText = closestLi.querySelector("div > section > footer > div > span");
            let quantity = parseInt(quantityText.innerText);
            quantity++;
            quantityText.innerText = quantity;


        });
    });
});



//add a listener to the checkout button
document.addEventListener("DOMContentLoaded", () => {
    const checkoutButton = document.querySelector("main > #checkout");
    checkoutButton.addEventListener("click", (event) => {
        event.preventDefault();
        //se non ci sono elementi nel carrello (non ci sono li), trasforma il colore del bottone in rosso, modifica il testo in carrello vuoto e non fare nulla
        if (document.querySelectorAll("main > ul > li").length == 0) {
            checkoutButton.style.backgroundColor = "red";
            checkoutButton.innerText = "Carrello vuoto";
            return;
        }
        else {
            checkout();
        }

    });
});


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

    if (data["success"]) {

        createNotificaton("Success", "Game added to cart", "positive");
    } else {
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

    if (data["success"]) {
        switch(data["message"]) {
            case "game_removed":
                createNotificaton("Success", "Game removed from cart", "positive");
                break;
            case "quantity_decreased":
                createNotificaton("Success", "Quantity of game decreased", "positive");
                break;
            default:
                createNotificaton("Success", "Unknown Action", "negative");
                break;
        }
    
    } else {
        console.error("HTTP-Error: " + response.status);
        createNotificaton("Error", data.message, "negative");
    }
}

