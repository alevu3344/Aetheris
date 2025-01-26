function generateRelevantGame(game){
    const realPrice = game['Discount'] ? `${(game['Price'] * (1 - game["Discount"] / 100)).toFixed(2)}` : `${game["Price"]}`;
    let placeholder = `
    <a href = "game.php?id=${game["Id"]}">
      <article>
        <header>
          <h3>${game["Name"]}</h3>
        </header>
        <section>
          <div></div>
          <img src="../media/covers/${game["Id"]}.jpg" alt="${game["Name"]}"/>
          <div>
            <p>${game["Description"]}</p>
          </div>
        </section>
        <footer>
          <div>
            <p>${realPrice}€</p>
            <p>Acquista</p>
          </div>
          <div>
            <img src="upload/icons/add-to-cart.svg" alt="Add to cart icon"/>
            <p>Aggiungi al carrello</p>
          </div>
        </footer>
      </article>
    </a>
    `;
    return placeholder;
}

async function generateGameBuffer(url) {
  try {
      const response = await fetch(url);
      if (!response.ok) {
          throw new Error(`Response status: ${response.status}`);
      }
      const json = await response.json();
      return json;
  } catch (error) {
      console.log(error.message);
  }
}

async function createRelevantGame(game) {
  
  const relevantGame = generateRelevantGame(game);
  const gameToShow = document.querySelector(".home_content > main > section:nth-child(1) > div > div");
  gameToShow.innerHTML = relevantGame;
  gameToShow.querySelector("a > article > footer > div:first-child > p:nth-child(2)").addEventListener("click", function(e){
    e.preventDefault();
    let popup = createPopUpWindow(game, game.Platforms, option="acquista");

    //listener per il bottone acquista
    popup.querySelector("button[type='submit']").addEventListener("click", function (event) {
        event.preventDefault();
        console.log("Acquista");
        let form = popup.querySelector("#purchaseForm");
        let formData = new FormData(form);
        let platform = formData.get("platform");
        let quantity = formData.get("quantity");
        console.log(game.Id, platform, quantity);

        buyGame(game.Id, platform, quantity);
    });
    //metti l'elemento in testa al body
    document.body.insertBefore(popup, document.body.firstChild);;
  });

  gameToShow.querySelector("a > article > footer > div:nth-child(2) > img").addEventListener("click", function(e){
    e.preventDefault();
    let popup = createPopUpWindow(game, game.Platforms, option="carrello");

    //listener per il bottone acquista
    popup.querySelector("button[type='submit']").addEventListener("click", function (event) {
        event.preventDefault();
        console.log("Aggiungi al carrello");
        let form = popup.querySelector("#purchaseForm");
        let formData = new FormData(form);
        let platform = formData.get("platform");
        let quantity = formData.get("quantity");
        addToCart(game.Id, platform, quantity);
    });
    //metti l'elemento in testa al body
    document.body.insertBefore(popup, document.body.firstChild);
  });
}

function animateFigure(game,direction) {
    curFigure = document.querySelector(".home_content > main > section:nth-child(1) > div > div > a");
    curFigure.classList.add(direction ? "slide-out-left" : "slide-out-right");

    setTimeout(() => {
        curFigure.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        createRelevantGame(game);
        curFigure = document.querySelector(".home_content > main > section:nth-child(1) > div > div > a");
        curFigure.classList.add(direction ? "slide-out-right" : "slide-out-left");
        setTimeout(() => {
          curFigure.classList.add(direction ? "slide-out-left" : "slide-out-right");
          curFigure.classList.remove(direction ? "slide-out-right" : "slide-out-left");
          curFigure.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        }, 100);
    }, 100);
}

async function initializeFrontPage(url) {
  bufferFrontPage = await generateGameBuffer(url);
  if (bufferFrontPage && bufferFrontPage.length > 0) {
    createRelevantGame(bufferFrontPage[0]);
  } else {
    console.error("Buffer vuoto");
  }
}

  document.querySelector(".home_content > main > section:nth-child(1) > div > button:first-child").addEventListener("click", function(e){
    indexFrontPage = (indexFrontPage - 1 + bufferFrontPage.length) % bufferFrontPage.length;
    e.preventDefault();
    animateFigure(bufferFrontPage[indexFrontPage],0);
});

document.querySelector(".home_content > main > section:nth-child(1) > div > button:last-child").addEventListener("click", function(e){
    indexFrontPage = (indexFrontPage+1) % bufferFrontPage.length;
    e.preventDefault();
    animateFigure(bufferFrontPage[indexFrontPage],1);
});

let indexFrontPage = 0;
let bufferFrontPage = [];

initializeFrontPage('api/front-page-game.php');





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

  if (response.ok) {
      let data = await response.json();
      createNotificaton("Success", "Game added to cart", "positive");
  } else {
      console.error("HTTP-Error: " + response.status);
      createNotificaton("Error", data.message, "negative");
  }
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

  if (response.ok) {
      createNotificaton("Success", "Game bought successfully", "positive");
  } else {
      console.error("HTTP-Error: " + response.status);
      createNotificaton("Error", response.message, "negative");
  }
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
          <img src="../media/covers/${game.Id}.jpg" alt="Game">
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
                      <img src="upload/icons/minus.png" alt="">
                  </button>
                  <input type="number" id="quantity" name="quantity" min="1" max="999" value="1" required>
                  <button type="button" aria-label="Increase quantity">
                      <img src="upload/icons/plus.png" alt="">
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
