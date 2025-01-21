function generateRelevantGame(games,index){

    let game = `
    <figure>
      <div></div>
      <img src="../media/covers/${games[index]["Id"]}.jpg" alt="${games[index]["Name"]}">
      <figcaption>
        <p>${games[index]["Name"]}</p>
        <p>${games[index]["Description"]}</p>
      </figcaption>

      <div>
        <div>
          <span>${games[index]["Price"]}</span>
          <button>Acquista</button>
        </div>
        <button>
          <img src="upload/icons/add-to-cart.svg" alt="Add to cart icon"/>Aggiungi al carrello
        </button>
      </div>
    </figure>
    `;

    return game;
}


async function getRelevantGame(index) {
    const url = 'front-page-game.php';
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const json = await response.json();
        const relevantGame = generateRelevantGame(json,index);
        const figure = document.querySelector(".home_content > main > div:first-child > article");
        figure.innerHTML = relevantGame;
    } catch (error) {
        console.log(error.message);
    }
}

function animateFigure() {
    const curFigure = document.querySelector(".home_content >main>div:nth-child(1)>article>figure");
    curFigure.classList.add("slide-out-left");

    setTimeout(() => {
        curFigure.classList.remove("slide-out-left");
        curFigure.classList.add("slide-in-right");

        setTimeout(() => {
            curFigure.classList.remove("slide-in-right");
            curFigure.classList.add("active");
            
        }, 1000);
    }, 1000);
}

let currentIndex = 0;
  document.querySelector(".home_content > main > div:first-child > button:first-child").addEventListener("click", function(e){
    currentIndex = (currentIndex - 1 + dim) % 10;
    e.preventDefault();
    getRelevantGame(currentIndex);
    animateFigure();
});

document.querySelector(".home_content > main > div:first-child > button:last-child").addEventListener("click", function(e){
    currentIndex = (currentIndex+1) % 10;
    e.preventDefault();
    getRelevantGame(currentIndex);
    animateFigure();
});

getRelevantGame(0);