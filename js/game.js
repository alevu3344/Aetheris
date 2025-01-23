


document.addEventListener("DOMContentLoaded", function () {
    //ratring is in the span under the .stars
    const rating =document.querySelector("div:nth-of-type(1) > span").innerText;
    const stars = document.querySelectorAll("div:nth-of-type(1) > .stars .star");

    stars.forEach((star, index) => {
        // Calculate how much of the star should be filled
        const fillAmount = Math.min(Math.max(rating - index, 0), 1);
        // Set the custom property for each star, fill it with white, from left to right
        star.style.setProperty("--fill-width", `${fillAmount * 100}%`);
    });
});


document.addEventListener("DOMContentLoaded", function () {

    /*for each list item in the .game_content > main > ul*/
    document.querySelectorAll(".game_content > main > ul:last-of-type li").forEach((li) => { 
        //ratring is in the span under the .stars
        const rating = li.querySelector("article > header > section > div > .stars").innerText;
      

        const stars = li.querySelectorAll("article > header > section > div > .stars .star");
        console.log(stars);

        stars.forEach((star, index) => {
            const fillAmount = Math.min(Math.max(rating - index, 0), 1); // Calculate how much of the star should be filled
            star.style.setProperty("--fill-width", `${fillAmount * 100}%`); // Set the custom property for each star
        });
    });
});

/*Listener per aggiungi al carrello*/
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".game_content > main > div:nth-of-type(2) > ").forEach((li) => {
        const button = li.querySelector("article > footer > button");
        button.addEventListener("click", function () {
            const cart = document.querySelector(".cart_content > main > ul");
            const clone = li.cloneNode(true);
            cart.appendChild(clone);
        });
    });
});