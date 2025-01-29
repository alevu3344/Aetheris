document.getElementById("add-game-form").addEventListener("submit", function(event) {
    event.preventDefault(); // Prevent the form from submitting normally
    
    // Create a new FormData object from the form

    var formData = new FormData(this);
    // Loop through the FormData entries and log them
    formData.forEach(function(value, key) {
        console.log(key + ": " + value);
    });
});