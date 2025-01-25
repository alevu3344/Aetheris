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
  const gameToShow = document.querySelector(".home_content > main > div:first-child > div");
  gameToShow.innerHTML = relevantGame;
}

function animateFigure(game,direction) {
    curFigure = document.querySelector(".home_content > main > div:first-child > div > a");
    curFigure.classList.add(direction ? "slide-out-left" : "slide-out-right");

    setTimeout(() => {
        curFigure.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        createRelevantGame(game);
        curFigure = document.querySelector(".home_content > main > div:first-child > div > a");
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

  document.querySelector(".home_content > main > div:first-child > button:first-child").addEventListener("click", function(e){
    indexFrontPage = (indexFrontPage - 1 + bufferFrontPage.length) % bufferFrontPage.length;
    e.preventDefault();
    animateFigure(bufferFrontPage[indexFrontPage],0);
});

document.querySelector(".home_content > main > div:first-child > button:last-child").addEventListener("click", function(e){
    indexFrontPage = (indexFrontPage+1) % bufferFrontPage.length;
    e.preventDefault();
    animateFigure(bufferFrontPage[indexFrontPage],1);
});

let indexFrontPage = 0;
let bufferFrontPage = [];

initializeFrontPage('front-page-game.php');
