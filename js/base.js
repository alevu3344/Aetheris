
const categoriesToggle = document.getElementById("categories-toggle");

// Check if the categories-toggle element is present in the DOM
if (categoriesToggle) {
    categoriesToggle.addEventListener("click", function () {
        this.classList.toggle("active");
        const categoriesList = document.getElementById("categories-list");
        categoriesList.style.display = categoriesList.style.display === "none" ? "block" : "none";
    });
}


const categoriesList = document.getElementById("categories-list");
if (categoriesList != null) {
    categoriesList.style.display = "none";
}

