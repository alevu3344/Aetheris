document.getElementById("categories-toggle").addEventListener("click", function() {
    this.classList.toggle("active");
    const categoriesList = document.getElementById("categories-list");
    categoriesList.style.display = categoriesList.style.display === "none" ? "block" : "none";
});
