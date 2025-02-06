document.addEventListener("DOMContentLoaded", function () {
    const h2Array = document.querySelectorAll("ul > li > article > header > h2");
    const orderIdArray = Array.from(h2Array).map(h2 => h2.id); // Convert NodeList to array and extract IDs

    if (orderIdArray.length === 0) {
        console.error("No orders found on the page.");
        return;
    }

    orderIdArray.forEach(orderId => {
        const eventSource = new EventSource(`api/sse.php?orderId=${orderId}`);

        eventSource.onmessage = function (event) {
            const data = JSON.parse(event.data);

            if (data.error) {
                console.error(`Order ${orderId}: ${data.error}`);
                eventSource.close();
                return;
            }

            console.log(`Order ${orderId}: ${data.status}`);

            const statusElement = document.querySelector(`p.status[data-order-id="${orderId}"]`);

            
            if (statusElement) {
                statusElement.innerText = `${data.status}`;
                statusElement.id = `${data.status}`;


            }

            // Close connection if order is delivered
            if (data.status === "Delivered") {
                eventSource.close();
            }
        };

        eventSource.onerror = function () {
            console.error(`SSE connection lost for order ${orderId}`);
            eventSource.close();
        };
    });
});
