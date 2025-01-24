document.getElementById("search-bar").addEventListener("input", function () {
    const query = this.value.trim();

    if (query.length > 0) {
        getSearchedGames(`search_bar.php?q=${encodeURIComponent(query)}`);
    } else {
        /*document.getElementById("search-results").innerHTML = "";*/
    }
});

async function getSearchedGames(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const data = await response.json();

        /*const resultsDiv = document.getElementById("search-results");
        resultsDiv.innerHTML = "";*/

        if (data.length > 0) {
            data.forEach((game) => {
                console.log("Gioco trovato: ", game);
                /*const result = document.createElement("div");
                result.textContent = game.name;
                result.onclick = () => {
                    document.getElementById("search-bar").value = game.name;
                    resultsDiv.innerHTML = "";
                };
                resultsDiv.appendChild(result);*/
            });
        } else {
            console.log("Gioco trovato: ", game);
            /*resultsDiv.innerHTML = "<div>Nessun risultato trovato</div>";*/
        }
    } catch (error) {
        console.log(error.message);
    }
}