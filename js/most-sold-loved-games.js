document.querySelector(".home_content > main > nav > ul > li:first-child > h2").addEventListener('click', function() {
    setTimeout(() => {
        lovedGames.classList.remove("crumbleInverse");
        lovedGames.classList.add("crumble");

        soldGames.classList.remove("crumble");
        soldGames.classList.add("crumbleInverse");
    }, 500);
});

document.querySelector(".home_content > main > nav > ul > li:last-child > h2").addEventListener('click', function() {
    setTimeout(() => {
        lovedGames.classList.remove("notVisible");
        soldGames.classList.remove("crumbleInverse");
        soldGames.classList.add("crumble");

        lovedGames.classList.remove("crumble");
        lovedGames.classList.add("crumbleInverse");
    }, 500);
});

const soldGames = document.querySelector(".home_content >main>div:nth-child(5)> div:first-child");
const lovedGames = document.querySelector(".home_content >main>div:nth-child(5)> div:last-child");

lovedGames.classList.add("notVisible");