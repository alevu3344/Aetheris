const piuAcquistati = document.querySelector(".home_content > main > nav > ul > li:first-child > h2");
const piuAmati = document.querySelector(".home_content > main > nav > ul > li:last-child > h2");

piuAcquistati.addEventListener('click', function() {
    setTimeout(() => {
        lovedGames.classList.remove("crumbleInverse");
        lovedGames.classList.add("crumble");
        piuAmati.classList.remove("sbrilluccichio");

        piuAcquistati.classList.add("sbrilluccichio");
        soldGames.classList.remove("crumble");
        soldGames.classList.add("crumbleInverse");
    }, 500);
});

piuAmati.addEventListener('click', function() {
    setTimeout(() => {
        piuAcquistati.classList.remove("sbrilluccichio");
        lovedGames.classList.remove("notVisible");
        soldGames.classList.remove("crumbleInverse");
        soldGames.classList.add("crumble");

        piuAmati.classList.add("sbrilluccichio");
        lovedGames.classList.remove("crumble");
        lovedGames.classList.add("crumbleInverse");
    }, 500);
});

const soldGames = document.querySelector(".home_content >main>div:nth-child(5)> div:first-child");
const lovedGames = document.querySelector(".home_content >main>div:nth-child(5)> div:last-child");

lovedGames.classList.add("notVisible");
piuAcquistati.classList.add("sbrilluccichio");