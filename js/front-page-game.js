function generateRelevantGame(game){
    let placeholder = `
    <a href = "game.php?id=${game["Id"]}">
      <figure>
        <div></div>
        <img src="../media/covers/${game["Id"]}.jpg" alt="${game["Name"]}"/>
        <figcaption>
          <p>${game["Name"]}</p>
          <p>${game["Description"]}</p>
        </figcaption>

        <div>
          <div>
            <span>${game["Price"]}</span>
            <button>Acquista</button>
          </div>
          <button>
            <img src="upload/icons/add-to-cart.svg" alt="Add to cart icon"/>
            Aggiungi al carrello
          </button>
        </div>
      </figure>
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
  const figure = document.querySelector(".home_content > main > div:first-child > article");
  figure.innerHTML = relevantGame;

  document.querySelector(".home_content >main>div:nth-child(1)>article>a>figure>div:nth-child(4)>div>button").addEventListener("click", function(e){
    e.preventDefault();
  });
}

function animateFigure(game,direction) {
    curFigure = document.querySelector(".home_content >main>div:nth-child(1)>article>a>figure");
    curFigure.classList.add(direction ? "slide-out-left" : "slide-out-right");

    setTimeout(() => {
        curFigure.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        createRelevantGame(game);
        curFigure = document.querySelector(".home_content >main>div:nth-child(1)>article>a>figure");
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
