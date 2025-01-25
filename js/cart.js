//add a listener to the trash bin img inside the a 
document.addEventListener("DOMContentLoaded", () => {
    // Select all trash buttons
    const trashButtons = document.querySelectorAll('ul > li > div > section > header button');

    // Add event listener to each button
    trashButtons.forEach((trashButton, index) => {
        trashButton.addEventListener("click", (event) => {
            event.preventDefault();
            const gameId = trashButton.closest('li').querySelector('a').href.split('id=')[1];
            const platform = trashButton.closest('li').querySelector("div > section > p > img").getAttribute("alt");

            console.log(`Game with ID ${gameId} and platform ${platform} has been removed.`);
            removeFromCart(gameId, platform, -1);
            trashButton.closest("li").remove();

        });
    });
});






function createNotificaton(title,message, type){
    let notification = document.createElement("div");
    notification.id = "notification";
    notification.classList.add(type);
    notification.innerHTML = `
    <h2>${title}</h2>
    <p>${message}</p>
    <button>OK</button>
    `

    if(type == "positive"){
        //set the background color to green
        notification.style.backgroundColor = "green";
        //set the button color to darker green
        notification.querySelector("button").style.backgroundColor = "darkgreen";
    }
    else{
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


async function removeFromCart(gameId, platform, quantity) {

    const formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Platform", platform);
    formData.append("Quantity", quantity);
    formData.append("Action", "remove");

    // Send a POST request to the server with the purchase details
    let response = await fetch("cart-api.php", {
        method: "POST",
        body: formData

    });

    if (response.ok) {
        let data = await response.json();
        createNotificaton("Success", data.message, "positive");
    } else {
        console.error("HTTP-Error: " + response.status);
        createNotificaton("Error", data.message, "negative");
    }
}

