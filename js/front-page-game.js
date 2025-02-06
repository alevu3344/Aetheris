function generateRelevantGame(game) {
    const realPrice = game['Discount'] ? `${(game['Price'] * (1 - game["Discount"] / 100)).toFixed(2)}` : `${game["Price"]}`;
    let placeholder = `
    <a href = "game.php?id=${game["Id"]}">
      <article>
        <header>
          <h3>${game["Name"]}</h3>
        </header>
        <section>
          <div></div>
          <img src="../media/covers/${game["Id"]}.jpg" alt="${game["Name"]} " onerror="this.onerror=null; this.src='../media/noimage.jpg';"/>
          <div>
            <p>${game["Description"]}</p>
          </div>
        </section>
        <footer>
          <div>
            <p>${realPrice}€</p>
            <p>Buy</p>
          </div>
          <div>
            <img src="upload/icons/add-to-cart.svg" alt="Add to cart icon"/>
            <p>Add to cart</p>
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
    gameToShow.querySelector("a > article > footer > div:first-child > p:nth-child(2)").addEventListener("click", function (e) {
        e.preventDefault();
        let popup = createPopUpWindow(game, game.Platforms, option = "buy");

        //listener per il bottone acquista
        popup.querySelector("button[type='submit']").addEventListener("click", async (event) => {
            event.preventDefault();
            let form = popup.querySelector("#purchaseForm");
            let formData = new FormData(form);
            let platform = formData.get("platform");
            let quantity = formData.get("quantity");
            // Show the custom confirmation popup
            const confirmed = await showConfirmationPopup("Are you sure you want to buy this game?");
            if (confirmed) {
                buyGame(game.Id, platform, quantity);
            }
        });
        //metti l'elemento in testa al body
        document.body.insertBefore(popup, document.body.firstChild);
    });

    gameToShow.querySelector("a > article > footer > div:nth-child(2)").addEventListener("click", function (e) {
        e.preventDefault();
        let popup = createPopUpWindow(game, game.Platforms, option = "cart");

        //listener per il bottone acquista
        popup.querySelector("button[type='submit']").addEventListener("click", function (event) {
            event.preventDefault();
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

function animateFigure(game, direction) {
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

document.querySelector(".home_content > main > section:nth-child(1) > div > button:first-child").addEventListener("click", function (e) {
    indexFrontPage = (indexFrontPage - 1 + bufferFrontPage.length) % bufferFrontPage.length;
    e.preventDefault();
    animateFigure(bufferFrontPage[indexFrontPage], 0);
});

document.querySelector(".home_content > main > section:nth-child(1) > div > button:last-child").addEventListener("click", function (e) {
    indexFrontPage = (indexFrontPage + 1) % bufferFrontPage.length;
    e.preventDefault();
    animateFigure(bufferFrontPage[indexFrontPage], 1);
});

let indexFrontPage = 0;
let bufferFrontPage = [];

initializeFrontPage('api/front-page-game.php');






