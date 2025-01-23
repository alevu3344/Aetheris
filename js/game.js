document.addEventListener("DOMContentLoaded", function () {
    //ratring is in the span under the .stars
    const rating =document.querySelector(".stars > span").innerText;
    const stars = document.querySelectorAll(".stars .star");

    stars.forEach((star, index) => {
        const fillAmount = Math.min(Math.max(rating - index, 0), 1); // Calculate how much of the star should be filled
        star.style.setProperty("--fill-width", `${fillAmount * 100}%`); // Set the custom property for each star
    });
});
