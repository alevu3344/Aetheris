document.querySelectorAll("main > ul > li").forEach((li) => {

    li.querySelector("article > header > .dropdown > .dropbtn").addEventListener("click", () => {
        li.querySelector("article > header > .dropdown > #myDropdown").classList.toggle("show");
        //add a listener to each button in the dropdown
        li.querySelectorAll("article > header > .dropdown > #myDropdown > button").forEach((button) => {
            button.addEventListener("click", () => {
                let newStatus = button.id;
                let orderId = li.querySelector("article > header > h2").id;
                li.querySelector(".status").textContent = newStatus;
                li.querySelector(".status").id = newStatus;
                
                modifyStatus(orderId, newStatus);
                li.querySelector("article > header > .dropdown > #myDropdown").classList.toggle("show");
            });
        });
    });
});



  
// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
if (!event.target.matches('.dropbtn')) {
    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
    var openDropdown = dropdowns[i];
    if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
    }
    }
}
} 



async function modifyStatus(orderId, newStatus) {

    const formData = new FormData();
    formData.append("OrderId", orderId);
    formData.append("Status", newStatus);

    // Send a POST request to the server with the purchase details
    let response = await fetch("api/modify-order-api.php", {
        method: "POST",
        body: formData

    });

    if (response.ok) {
        let data = await response.json();
        createNotificaton("Success", `Order status modified successfully to ${newStatus}`, "positive");
    } else {
        console.error("HTTP-Error: " + response.status);
        createNotificaton("Error", data.message, "negative");
    }
}


function createNotificaton(title,message, type){
    let notification = document.createElement("div");
    notification.id = "notification";
    notification.classList.add(type);
    notification.innerHTML = `
    <h2>${title}</h2>
    <p>${message}</p>
    <button>OK</button>
    `

    if(type == "positive"){
        //set the background color to green
        notification.style.backgroundColor = "green";
        //set the button color to darker green
        notification.querySelector("button").style.backgroundColor = "darkgreen";
    }
    else{
        //set the background color to red
        notification.style.backgroundColor = "red";
        //set the button color to darker red
        notification.querySelector("button").style.backgroundColor = "darkred";
    }

   

    document.body.insertBefore(notification, document.body.firstChild);

    document.querySelector("#notification > button").addEventListener("click", function (event) {
        event.preventDefault();
        notification.remove();
    });

    
    setTimeout(() => {
        notification.remove();
    }, 5000);

    
}
