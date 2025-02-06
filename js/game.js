let currentStart = 0;
let reviewsPerPage = 3;


const scriptUrlGames = new URL(document.currentScript.src); // Get the script's URL
const gameDataGames = scriptUrlGames.searchParams.get("gameData"); // Get the game parameter

//gameData is an associative array
const game = JSON.parse(gameDataGames).game;
const platforms = JSON.parse(gameDataGames).platforms;
addRatingToGame();
getMoreReviews(currentStart, currentStart + reviewsPerPage - 1);


const addReviewButton = document.getElementById('addReview');
if (addReviewButton) {
    addReviewButton.addEventListener('click', function () {
        showAddReviewForm();
    });
}

document.querySelector("main > div:last-of-type button").addEventListener("click", async function () {
    getMoreReviews(currentStart, currentStart + reviewsPerPage - 1);
});

function addRatingToGame() {
    //ratring is in the span under the .stars
    const rating = document.querySelector("div:nth-of-type(1) > span").innerText;
    const stars = document.querySelectorAll("div:nth-of-type(1) > .stars .star");

    stars.forEach((star, index) => {
        // Calculate how much of the star should be filled
        const fillAmount = Math.min(Math.max(rating - index, 0), 1);
        // Set the custom property for each star, fill it with white, from left to right
        star.style.setProperty("--fill-width", `${fillAmount * 100}%`);
    });
}



/*Listener per acquista ora*/
document.querySelector("#buy").addEventListener("click", async (event) => {
    event.preventDefault();
    let popup = createPopUpWindow(game, platforms, option = "acquista");

    //listener per il bottone acquista
    popup.querySelector("button[type='submit']").addEventListener("click", async (event) => {
        event.preventDefault();
        let form = popup.querySelector("#purchaseForm");
        let formData = new FormData(form);
        let platform = formData.get("platform");
        let quantity = formData.get("quantity");
        // Show the custom confirmation popup
        const confirmed = await showConfirmationPopup("Sei sicuro di voler acquistare questo gioco?");
        if (confirmed) {
            buyGame(game.Id, platform, quantity);
        }
    });
    //metti l'elemento in testa al body
    document.body.insertBefore(popup, document.body.firstChild);

});


/*Listener per aggiungi al carrello*/
document.querySelector("#cart").addEventListener("click", function (event) {
    event.preventDefault();
    let popup = createPopUpWindow(game, platforms, option = "carrello");

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



async function getMoreReviews(start, end) {
    const url = `api/load-more-reviews-api.php?start=${start}&end=${end}&id=${game.Id}`;
    try {
        const response = await fetch(url, {
            method: "GET"
        });


        const reviews = await response.json();
        appendNewReviews(reviews);

        currentStart = end + 1;

        if (reviews.length < reviewsPerPage) {
            document.querySelector("main > div:last-of-type").remove();
        }

    }
    catch (error) {
        console.log(error.message);
    }
}



function appendNewReviews(reviews) {

    const reviewsList = document.querySelector("#reviewsList"); // Modifica il selettore secondo il tuo HTML

    reviews.forEach(review => {

        const reviewHTML = `
            <li>
                <article>
                    <header>
                        <img src="../media/avatars/${review.Avatar}" alt="avatar"/>
                        <section>
                            <div>
                                <span>${review.Username}</span>
                                <div class="stars">
                                    <span>${review.Rating}</span>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                    <div class="star"></div>
                                </div>
                            </div>
                        </section>
                    </header>
                    <h2>${review.Title}</h2>
                    <p>${review.Comment}</p>
                    <footer>
                        <span>${review.CreatedAt}</span>
                    </footer>
                </article>
            </li>
        `;


        reviewsList.insertAdjacentHTML("beforeend", reviewHTML);
    });
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
}







async function addReview(title, comment, rating) {
    const formData = new FormData();
    formData.append("GameId", game.Id);
    formData.append("Title", title);
    formData.append("Comment", comment);
    formData.append("Rating", rating);

    const url = "api/add-review-api.php";
    try {
        const response = await fetch(url, {
            method: "POST",
            body: formData
        });

        let data = await response.json();



        if (response.ok) {

            createNotificaton("Success", data.message, "positive");
        } else {
            console.error("HTTP-Error: " + response.status);
            createNotificaton("Error", data.message, "negative");
        }

    }
    catch (error) {
        console.log(error.message);
    }
}

function showAddReviewForm() {

    let div = document.createElement("div");
    div.id = "addReviewForm";
    let form = `
        <form>
        <legend>Write a review</legend>
        <fieldset>
            <div>
                <label for="rating">
                    Rating
                    <input type="number" id="rating" name="rating" min="1" max="5" required>
                </label>
                <label for="title">
                    Title
                    <input type="text" id="title" name="title" required>
                </label>
            </div>

            <label for="comment">Comment</label>
            <textarea id="comment" name="comment" required></textarea>
        </fieldset>
        
        <button type="submit">Submit</button>
        <button>Annulla</button>
        
    </form>
    `;

    div.innerHTML = form;
    div.querySelector("form").addEventListener("submit", function (event) {
        event.preventDefault();
        let title = div.querySelector("#title").value;
        let comment = div.querySelector("#comment").value;
        let rating = div.querySelector("#rating").value;
        addReview(title, comment, rating);
    });

    div.querySelector("button:last-of-type").addEventListener("click", function (event) {
        event.preventDefault();
        div.remove();
    });

    document.body.insertBefore(div, document.body.firstChild);
}

