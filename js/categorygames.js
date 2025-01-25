let currentStart = 0; 
let gamesPerPage = 10; 



const scriptUrl = new URL(document.currentScript.src); 
const category = scriptUrl.searchParams.get("category"); 
const action = scriptUrl.searchParams.get("action");
getMoreGames(currentStart, currentStart + gamesPerPage-1);

document.querySelector(".categorygames_content > main > div:last-of-type button").addEventListener("click", async function () {
    getMoreGames(currentStart, currentStart + gamesPerPage-1);
});



async function getMoreGames(start, end) {
    const url = `load-more-games-api.php?start=${start}&end=${end}&category=${category}&action=${action}`;
    try {
        const response = await fetch(url, {
            method: "GET"
        });
        const games = await response.json();
        addMoreGames(games);

        currentStart = end+1;
        if (games.length < gamesPerPage) {
            document.querySelector(".categorygames_content > main > div:last-of-type").remove();

        } 
        
    } catch (error) {
        console.log(error.message);
    }
}


function addMoreGames(games) {
    const gamesContainer = document.querySelector("main > ul");
    for (let game of games) {
        const gameListItem = document.createElement("li");
        
        gameListItem.innerHTML = `
            <a href="game.php?id=${game.Id}">
                <article>
                    <figure>
                        <img src="../media/covers/${game.Id}.jpg" alt="${game.Name}" />
                        <figcaption>${game.Name}</figcaption>
                    </figure>
                    <footer>
                        ${game.Discount ? `<span>-${game.Discount}%</span>` : ""}
                        <span>${game.Price}€</span>
                        ${game.Discount ? `<span>${(game.Price * (1 - game.Discount / 100)).toFixed(2)}€</span>` : ""}
                    </footer>
                </article>
            </a>
        `;
        
        gamesContainer.appendChild(gameListItem);
    }
}


