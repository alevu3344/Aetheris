function generateLaunchOffers(games){
    let result = "";
    games.forEach(game => {
        const discountText = game['Discount'] ? `<span>-${game["Discount"]}%</span>` : "";
        const discountedPrice = game['Discount'] ? `<span>${(game['Price'] * (1 - game["Discount"] / 100)).toFixed(2)}€</span>` : "";
        let placeholder = `
        <li>
            <a href = "game.php?id=${game["Id"]}">
                <article>
                    <figure>
                        <img src="../media/covers/${game["Id"]}.jpg" alt="${game["Name"]}"/>
                        <figcaption>${game["Name"]}</figcaption>
                    </figure>
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

async function createLaunchOffers(games) {
  const launchOffers = generateLaunchOffers(games);
  const listOfGames = document.querySelector(".home_content > main > #home-offers > div > nav > ul");
  listOfGames.innerHTML = launchOffers;

}

function animateUl(games,direction) {
    curUl = document.querySelector(".home_content > main > #home-offers > div > nav > ul");
    curUl.classList.add(direction ? "slide-out-left" : "slide-out-right");

    setTimeout(() => {
        curUl.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        createLaunchOffers(games);
        curUl = document.querySelector(".home_content > main > #home-offers > div > nav > ul");
        curUl.classList.add(direction ? "slide-out-right" : "slide-out-left");
        setTimeout(() => {
          curUl.classList.add(direction ? "slide-out-left" : "slide-out-right");
          curUl.classList.remove(direction ? "slide-out-right" : "slide-out-left");
          curUl.classList.remove(direction ? "slide-out-left" : "slide-out-right");
        }, 100);
    }, 100);
} 

async function initializeLaunchOffers(url) {
  bufferLaunchOffers = await generateGameBuffer(url);
  if (bufferLaunchOffers && bufferLaunchOffers.length > 0) {
    createLaunchOffers(bufferLaunchOffers.slice(0,3));
  } else {
    console.error("Buffer vuoto");
  }
}


document.querySelector(".home_content > main > #home-offers > div > img:nth-of-type(1)").addEventListener("click", function(e){
    e.preventDefault();
    let currentLaunchOffers = [];
    indexLaunchOffers = (indexLaunchOffers - sliceLaunchOffers + bufferLaunchOffers.length) % bufferLaunchOffers.length;
    let k=indexLaunchOffers;

    for(let i=0; i < sliceLaunchOffers; i++){
        currentLaunchOffers.push(bufferLaunchOffers[k]);
        k = (k - 1 + bufferLaunchOffers.length) % bufferLaunchOffers.length;
    }
    animateUl(currentLaunchOffers,0);
});

document.querySelector(".home_content > main > #home-offers > div > img:nth-of-type(2)").addEventListener("click", function(e){
    e.preventDefault();
    let currentLaunchOffers = [];
    indexLaunchOffers = (indexLaunchOffers + sliceLaunchOffers) % bufferLaunchOffers.length;
    let k=indexLaunchOffers;

    for(let i=0; i < sliceLaunchOffers; i++){
        currentLaunchOffers.push(bufferLaunchOffers[k]);
        k=(k + 1) % bufferLaunchOffers.length;
    }
    animateUl(currentLaunchOffers,1);
});

let sliceLaunchOffers = 3;
let indexLaunchOffers = 0;
let bufferLaunchOffers = [];

initializeLaunchOffers('api/launch-offers.php');
