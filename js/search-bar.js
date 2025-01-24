document.getElementById("search-bar").addEventListener("input", function () {
    const query = this.value.trim();

    const resultsDiv = document.querySelector("body>header>nav>div:first-child>div>ul");
    if (query.length > 0) {
        getSearchedGames(`search_bar.php?q=${encodeURIComponent(query)}`);
        resultsDiv.classList.add("ulShow");
        resultsDiv.classList.remove("ulHide");
    } else {
        resultsDiv.innerHTML = "";
        resultsDiv.classList.remove("ulShow");
        resultsDiv.classList.add("ulHide");
    }
});


function generateSearchedGames(games){
    let result = "";
    games.forEach(game => {
        const discountedPrice = game['Discount'] ? `<span>${(game['Price'] * (1 - game["Discount"] / 100)).toFixed(2)}€</span>` : `<span>${game['Price']}€</span>`;
        let placeholder = `
            <li>
                <a href = "game.php?id=${game["Id"]}">
                <img src="../media/covers/${game["Id"]}.jpg" alt="${game["Name"]}"/>
                <section>
                    <header>
                    <span>${game["Name"]}</span>
                    </header>
                    <footer>
                        ${discountedPrice}
                    </footer>
                </section>
                </a>
            </li>
        `;
        result += placeholder;
    });

    return result;
}

async function getSearchedGames(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const data = await response.json();

        const resultsDiv = document.querySelector("body>header>nav>div:first-child>div>ul");

        if (data.length > 0) {
            resultsDiv.innerHTML = generateSearchedGames(data);
            
        } else {
            resultsDiv.innerHTML = "<div>Nessun risultato trovato</div>";
        }
    } catch (error) {
        console.log(error.message);
    }
}


const ul = document.querySelector("body>header>nav>div:first-child>div>ul");
ul.classList.add("ulHide");