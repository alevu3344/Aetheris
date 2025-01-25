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
        notification.style.backgroundColor = "green";
        notification.querySelector("button").style.backgroundColor = "darkgreen";
    }
    else{
        notification.style.backgroundColor = "red";
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