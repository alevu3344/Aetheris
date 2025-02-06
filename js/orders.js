document.querySelectorAll("main > ul > li").forEach((li) => {

    const advanceButton = li.querySelector("#advance");
    const orderId = li.querySelector("article > header > h2").id;
    advanceButton.addEventListener("click", async function (event) {
        const confirmed = await showConfirmationPopup("Are you sure you want to advance this order?");
        if (confirmed) {
            advanceOrder(orderId);

        }
    });

});





async function advanceOrder(orderId) {
    let formData = new FormData();
    formData.append("OrderId", orderId);

    let response = await fetch("api/advance-order-api.php", {
        method: "POST",
        body: formData
    });
    let data = await response.json();

    if (data["success"]) {

        let nextStatus = data["message"];

        const statusBox  = document.querySelector(`#li${orderId} >  article > header > .status`);
        statusBox.id = nextStatus;
        statusBox.textContent = nextStatus;

        if(nextStatus == "Delivered"){
            
            document.querySelector(`#li${orderId} > article > header > #advance`).remove();
            
            createNotificaton("Success", `Order advanced successfully to ${data["message"]}`, "positive");
            return;
        }


        createNotificaton("Success", `Order advanced successfully to ${data["message"]}`, "positive");

        

    } else {
        console.error("HTTP-Error: " + response.status);
        createNotificaton("Error", data.message, "negative");
    }
}
