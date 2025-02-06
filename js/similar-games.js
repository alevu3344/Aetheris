const scriptUrlSimilarGames = new URL(document.currentScript.src); 
const idGame = scriptUrlSimilarGames.searchParams.get("id"); 

function generateSimilarGames(games){
    let result = "";
    games.forEach(game => {
        const discountText = game['Discount']>0 ? `<span>-${game["Discount"]}%</span>` : "";
        const discountedPrice = game['Discount']>0 ? `<span>${(game['Price'] * (1 - game["Discount"] / 100)).toFixed(2)}€</span>` : "";
        let placeholder = `
        <li>
            <a href = "game.php?id=${game["Id"]}">
                <article>
                    <header>
                        <h3>${game["Name"]}</h3>
                        <div>
                            <img src="../media/covers/${game["Id"]}.jpg" alt="${game["Name"]}" onerror="this.onerror=null; this.src='../media/noimage.jpg';"/>
                        </div>
                    </header>
                    <footer>
                        ${discountText}
                        <span>${game["Price"]}€</span>
                        ${discountedPrice}
                    </footer>
                </article>
            </a>
        </li>
        `;
        result += placeholder;
    });

    return result;
}

async function createSimilarGames(games) {
  const launchOffers = generateSimilarGames(games);
  const listOfGames = document.querySelector(".game_content > main > div:nth-of-type(4) > div > ul");
  listOfGames.innerHTML = launchOffers;
}

function animateUlSimilarGames(games,direction) {
    curUl = document.querySelector(".game_content > main > div:nth-of-type(4) > div > ul");
    curUl.classList.add(direction ? "slide-out-left" : "slide-out-right");

    setTimeout(() => {
        curUl.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        createSimilarGames(games);
        curUl = document.querySelector(".game_content > main > div:nth-of-type(4) > div > ul");
        curUl.classList.add(direction ? "slide-out-right" : "slide-out-left");
        setTimeout(() => {
          curUl.classList.add(direction ? "slide-out-left" : "slide-out-right");
          curUl.classList.remove(direction ? "slide-out-right" : "slide-out-left");
          curUl.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        }, 100);
    }, 100);
} 

async function generateSimilarGameBuffer(url) {
    try {
        const response = await fetch(url, {method: "GET"});
        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }

        const json = await response.json();
        return json;
    } catch (error) {
        console.log(error.message);
    }
  }

async function initializeSimilarGames(url) {
  bufferSimilarGames = await generateSimilarGameBuffer(url);
  if (bufferSimilarGames && bufferSimilarGames.length > 0) {
    createSimilarGames(bufferSimilarGames.slice(0,4));
  } else {
    console.error("Buffer vuoto");
  }
}

document.querySelector(".game_content > main > div:nth-of-type(4) > img").addEventListener("click", function(e){
    e.preventDefault();
    let currentSimilarGames = [];
    indexSimilarGames = (indexSimilarGames - sliceSimilarGames + bufferSimilarGames.length) % bufferSimilarGames.length;
    let k=indexSimilarGames;

    for(let i=0; i < sliceSimilarGames; i++){
        currentSimilarGames.push(bufferSimilarGames[k]);
        k = (k - 1 + bufferSimilarGames.length) % bufferSimilarGames.length;
    }
    animateUlSimilarGames(currentSimilarGames,0);
});

document.querySelector(".game_content > main > div:nth-of-type(4) > img:nth-of-type(2)").addEventListener("click", function(e){
    e.preventDefault();
    let currentSimilarGames = [];
    indexSimilarGames = (indexSimilarGames + sliceSimilarGames) % bufferSimilarGames.length;
    let k=indexSimilarGames;

    for(let i=0; i < sliceSimilarGames; i++){
        currentSimilarGames.push(bufferSimilarGames[k]);
        k=(k + 1) % bufferSimilarGames.length;
    }
    animateUlSimilarGames(currentSimilarGames,1);
});

let sliceSimilarGames = 4;
let indexSimilarGames = 0;
let bufferSimilarGames = [];

initializeSimilarGames(`api/similar-games.php?id=${idGame}`);