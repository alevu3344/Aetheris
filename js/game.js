let currentStart = 0; 
let reviewsPerPage = 3; 




const scriptUrl = new URL(document.currentScript.src); // Get the script's URL
const gameData = scriptUrl.searchParams.get("gameData"); // Get the game parameter

//gameData is an associative array
const game = JSON.parse(gameData).game;
const platforms = JSON.parse(gameData).platforms;
getMoreReviews(currentStart, currentStart + reviewsPerPage-1);

document.addEventListener("DOMContentLoaded", function () {
    //ratring is in the span under the .stars
    const rating =document.querySelector("div:nth-of-type(1) > span").innerText;
    const stars = document.querySelectorAll("div:nth-of-type(1) > .stars .star");

    stars.forEach((star, index) => {
        // Calculate how much of the star should be filled
        const fillAmount = Math.min(Math.max(rating - index, 0), 1);
        // Set the custom property for each star, fill it with white, from left to right
        star.style.setProperty("--fill-width", `${fillAmount * 100}%`);
    });
});



/*Listener per acquista ora*/
document.querySelector(".game_content > main > div:nth-of-type(2) > button:nth-of-type(1)").addEventListener("click",function (event) {
    event.preventDefault();
    let popup = createPopUpWindow(game, platforms, option="acquista");

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
    document.body.insertBefore(popup, document.body.firstChild);

});


/*Listener per aggiungi al carrello*/
document.querySelector(".game_content > main > div:nth-of-type(2) > button:nth-of-type(2)").addEventListener("click",function (event) {
    event.preventDefault();
    event.preventDefault();
    let popup = createPopUpWindow(game, platforms, option="carrello");

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


async function buyGame(gameId, platform, quantity) {

    const formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Platform", platform);
    formData.append("Quantity", quantity);

    // Send a POST request to the server with the purchase details
    let response = await fetch("buy-game-api.php", {
        method: "POST",
        body: formData

    });

    if (response.ok) {
        let data = await response.json();
        createNotificaton("Success", "Game purchased", "positive");
    } else {
        console.error("HTTP-Error: " + response.status);
        createNotificaton("Error", data.message, "negative");
    }
}

async function addToCart(gameId, platform, quantity) {

    const formData = new FormData();
    formData.append("GameId", gameId);
    formData.append("Platform", platform);
    formData.append("Quantity", quantity);

    // Send a POST request to the server with the purchase details
    let response = await fetch("add-to-cart-api.php", {
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



async function getMoreReviews(start, end) {
    const url = `load-more-reviews-api.php?start=${start}&end=${end}&id=${game.Id}`;
    try{
        const response = await fetch(url, {
            method: "GET"
        });

 
        const reviews = await response.json();
        console.log(reviews);
        appendNewReviews(reviews);
        
        currentStart = end+1;
        if (reviews.length < reviewsPerPage) {
            document.querySelector("main > div:last-of-type").remove();

        } else {
            
            document.querySelector("main > div:last-of-type button").addEventListener("click", async function () {
                console.log("ciao");
                getMoreReviews(currentStart, currentStart + reviewsPerPage);
            });
        }
    
        
    }
    catch(error){
        console.log(error.message);
    }
}



function appendNewReviews(reviews) {
    
    const reviewsList = document.querySelector("#reviewsList"); // Modifica il selettore secondo il tuo HTML

    reviews.forEach(review => {
        
        const reviewHTML = `
            <li>
                <article>
                    <header>
                        <img src="../media/avatars/${review.Avatar}" alt="avatar">
                        <section>
                            <div>
                                <span>${review.Username}</span>
                                <div class="stars">
                                    <span>${review.Rating}</span>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                </div>
                            </div>
                        </section>
                    </header>
                    <h2>${review.Title}</h2>
                    <p>${review.Comment}</p>
                    <footer>
                        <span>${review.CreatedAt}</span>
                    </footer>
                </article>
            </li>
        `;

    
        reviewsList.insertAdjacentHTML("beforeend", reviewHTML);
    });
    /*for each list item in the .game_content > main > ul*/
    document.querySelectorAll(".game_content > main > ul:last-of-type li").forEach((li) => { 
        //ratring is in the span under the .stars
        const rating = li.querySelector("article > header > section > div > .stars").innerText;
      

        const stars = li.querySelectorAll("article > header > section > div > .stars .star");
       

        stars.forEach((star, index) => {
            const fillAmount = Math.min(Math.max(rating - index, 0), 1); // Calculate how much of the star should be filled
            star.style.setProperty("--fill-width", `${fillAmount * 100}%`); // Set the custom property for each star
        });
    });
}
