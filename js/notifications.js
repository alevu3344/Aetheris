document.querySelectorAll("ul > li button").forEach((button) => {
  button.addEventListener("click", () => {
    markNotificationAsRead(button.id);
    //remove the button
    button.remove();
    const li = button.closest("li");
    li.id = "Read";
    li.style.backgroundColor = "black";
  });
});


async function markNotificationAsRead(notificationid){
    const url = "api/read-notifications-api.php";
    const data = new FormData();
    data.append("Id", notificationid);
    const response = await fetch(url, {
        method: "POST",
        body: data
    });

    if(response["success"]){
        createNotification("Notification marked as read", "success");
    }
    else {
        switch(response["message"]){
            case "post_not_set":
                createNotification("Post not set", "error");
                break;
            case "not_logged":
                createNotification("You are not logged in", "error");
                break;
        }
    }

}