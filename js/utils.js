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


function createPopUpWindow(game, platforms, option) {
    // Generate platform radio inputs dynamically
    let platformOptions = platforms.map((platformObj, index) => {
        return `
          <label for="${platformObj.Platform.toLowerCase()}">
              <input type="radio" 
                     id="${platformObj.Platform.toLowerCase()}" 
                     name="platform" 
                     value="${platformObj.Platform}" 
                     required 
                     aria-label="${platformObj.Platform}"
                     ${index === 0 ? 'checked' : ''}/> <!-- Automatically check the first radio button -->
              <img src="upload/icons/${platformObj.Platform}.svg" alt="${platformObj.Platform}"/>
          </label>
      `;
    }).join('');

    // Generate price details dynamically based on Discount
    let priceDetails = game.Discount
        ? `
          <span>-${game.Discount}%</span>
          <span>${game.Price}€</span>
          <span>${(game.Price * (1 - game.Discount / 100)).toFixed(2)}€</span>
        `
        : `<span>${game.Price}€</span>`;
    let buttonText = option === "acquista" ? "Acquista" : "Aggiungi al carrello";

    // Complete popup HTML
    let popupHtml = `
  <section>
      <h2>Conferma</h2>
      <figure>
          <img src="../media/covers/${game.Id}.jpg" alt="Game" onerror="this.onerror=null; this.src='../media/noimage.jpg';"/>
          <p>${priceDetails}</p>
          <figcaption>${game.Name}</figcaption>
      </figure>
      <form id="purchaseForm">
          <fieldset>
              <legend>Select a Platform and quantity</legend>
              <div>
                  ${platformOptions}
              </div>

              <label for="quantity">Choose a quantity</label>
              <div>
                  <button type="button" aria-label="Decrease quantity">
                      <img src="upload/icons/minus.png" alt=""/>
                  </button>
                  <input type="number" id="quantity" name="quantity" min="1" max="999" value="1" required>
                  <button type="button" aria-label="Increase quantity">
                      <img src="upload/icons/plus.png" alt=""/>
                  </button>
              </div>
          </fieldset>
          <button type="submit" id="${option}">${buttonText}</button>
          <button id="annulla"> Annulla</button>
      </form>
  </section>
  `;

    // Move quantity buttons functionality here
    let popup = document.createElement("div");
    popup.id = "popup";
    popup.innerHTML = popupHtml;

    // Listener for the + button
    popup.querySelector("button[aria-label='Increase quantity']").addEventListener("click", function (event) {
        let quantityInput = popup.querySelector("#quantity");
        let currentQuantity = parseInt(quantityInput.value);
        quantityInput.value = currentQuantity + 1;
    });

    // Listener for the - button
    popup.querySelector("button[aria-label='Decrease quantity']").addEventListener("click", function (event) {
        let quantityInput = popup.querySelector("#quantity");
        let currentQuantity = parseInt(quantityInput.value);
        if (currentQuantity > 1) {
            quantityInput.value = currentQuantity - 1;
        }
    });

    //listener per il bottone annulla

    popup.querySelector("#annulla").addEventListener("click", function (event) {
        event.preventDefault();
        popup.remove();
    });

    return popup;
}

async function buyGame(gameId, platform, quantity) {

    const formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Platform", platform);
    formData.append("Quantity", quantity);

    // Send a POST request to the server with the purchase details
    let response = await fetch("api/buy-game-api.php", {
        method: "POST",
        body: formData

    });

    let data = await response.json();

    if (data["success"]) {
        createNotificaton("Success", "Game bought successfully", "positive");
    } else {
        switch (data["message"]) {
            case "not_logged":
                createNotificaton("Error", "Log in to buy games", "negative");
                break;
            case "no_funds":
                createNotificaton("Error", "Not enough funds", "negative");
                break;
            case "internal_error":
                createNotificaton("Error", "Internal error", "negative");
                break;
            case "invalid_request":
                createNotificaton("Error", "Invalid Request", "negative");
                break;
            case "no_stock":
                createNotificaton("Error", "The game is out of stock for the selected platform and quantity", "negative");
                break;
            default:
                createNotificaton("Error", "Unknown error", "negative");
                break;
        }
    }
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