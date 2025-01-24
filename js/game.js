
const scriptUrl = new URL(document.currentScript.src); // Get the script's URL
const gameData = scriptUrl.searchParams.get("gameData"); // Get the game parameter

//gameData is an associative array
const game = JSON.parse(gameData).game;
const platforms = JSON.parse(gameData).platforms;
console.log(game);
console.log(platforms);

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


document.addEventListener("DOMContentLoaded", function () {

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
});

/*Listener per acquista ora*/
document.querySelector(".game_content > main > div:nth-of-type(2) > button:nth-of-type(1)").addEventListener("click",function (event) {
    event.preventDefault();
    let gameId = document.querySelector(".game_content > main > div:nth-of-type(2)").id;
    let popupHtml = createPopUpWindow(game, platforms);
    let popup = document.createElement("div");
    popup.id = "popup";
    popup.innerHTML = popupHtml;


    //listener per il bottone acquista
    popup.querySelector("button[type='submit']").addEventListener("click", function (event) {
        event.preventDefault();
        console.log("Acquista");
        let form = popup.querySelector("#purchaseForm");
        let formData = new FormData(form);
        let platform = formData.get("platform");
        let quantity = formData.get("quantity");
        console.log(platform, quantity);
        popup.remove();
    });

    //listener per il bottone annulla

    popup.querySelector("#annulla").addEventListener("click", function (event) {   
        event.preventDefault();
        popup.remove();
    });
    //metti l'elemento in testa al body
    document.body.insertBefore(popup, document.body.firstChild);

    

});


/*Listener per aggiungi al carrello*/
document.querySelector(".game_content > main > div:nth-of-type(2) > button:nth-of-type(2)").addEventListener("click",function (event) {
    event.preventDefault();
    let gameId = document.querySelector(".game_content > main > div:nth-of-type(2)").id;
    

});


function createPopUpWindow(game, platforms) {
    // Generate platform radio inputs dynamically
    let platformOptions = platforms.map(platformObj => `
        <label for="${platformObj.Platform.toLowerCase()}">
            <input type="radio" id="${platformObj.Platform.toLowerCase()}" name="platform" value="${platformObj.Platform}" required aria-label="${platformObj.Platform}">
            <img src="upload/icons/${platformObj.Platform}.svg" alt="${platformObj.Platform}">
        </label>
    `).join('');

    // Complete popup HTML
    let popupHtml = `
    <section>
        <h2>Conferma</h2>
        <figure>
            <img src="../media/covers/${game.Id}.jpg" alt="Game">
            <p>
                <span>59.99€</span>
                <span>-50%</span>
                <span>29.99€</span>
            </p>
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
            <button type="submit">Acquista</button>
            <button id="annulla"> Annulla</button>
        </form>
    </section>
    `;
    return popupHtml;
}
