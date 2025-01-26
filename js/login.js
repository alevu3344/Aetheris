


function putAvatar(avatar, username) {  

    let header_accedi = document.querySelector("body > header > div > div:nth-of-type(2) > a");
    let figure = `
        <img src="../media/avatars/${avatar}" alt="Avatar">
        <figcaption>${username}</figcaption>
    `;
    let newFigure = document.createElement("figure");
    newFigure.innerHTML = figure;
    header_accedi.replaceWith(newFigure);

    let logoutButton = document.createElement("a"); // Renamed variable
    logoutButton.innerHTML = `
        <img src="upload/icons/logout.png" alt="Logout"/>
    `;
    logoutButton.style.cursor = "pointer"; // Add pointer cursor to indicate interactivity

    // Add event listener to logout element
    logoutButton.addEventListener("click", function () {
        console.log("logout pressed");
        logoutButton.remove(); // Remove the logout element
        logout(); // Call the actual logout function
    });

    let header_right_div = document.querySelector("body > header > div > div:nth-of-type(2)");
    header_right_div.appendChild(logoutButton);
}


document.addEventListener("DOMContentLoaded", function () {
    if(document.body.classList.contains("registration-form")){
        // add a listener to the submit button in the registration form
        document.querySelector(".registration-form > main > section > form").addEventListener("submit", function (event) {
            event.preventDefault();

            const name = document.querySelector("#name").value;
            const surname = document.querySelector("#surname").value;
            const birthday = document.querySelector("#birthday").value;
            const city = document.querySelector("#city").value;
            const address = document.querySelector("#address").value;
            const phonenumber = document.querySelector("#phonenumber").value;
            const email = document.querySelector("#email").value;
            const username = document.querySelector("#username").value;
            const password = document.querySelector("#password").value;
            const repeatPassword = document.querySelector("#repeat-password").value;
            const selectedAvatar = document.querySelector('input[name="avatar"]:checked');
            const avatarId = selectedAvatar.value;
            console.log("avatarId: " + avatarId);
         
            

            if(password != repeatPassword){
                document.querySelector(".login-form > main > section > p").innerText = "Passwords don't match";
            }
            else{
                register(name, surname, birthday, city, address, phonenumber, email, username, password, avatarId);
            }
        });
    }
});
document.addEventListener("DOMContentLoaded", function () {
    if(document.body.classList.contains("login-form")){
        // Gestisco tentativo di login
        document.querySelector(".login-form > main > section > form").addEventListener("submit", function (event) {
            event.preventDefault();
            console.log(document.body.classList.contains("login-form"));
            const username = document.querySelector("#username").value;
            const password = document.querySelector("#password").value;
            console.log("submit pressed")
            const formData = new FormData();
            formData.append('Username', username);
            formData.append('Password', password);
            login(formData);
        });
    }
});


async function logout(){
    const url = 'api/logout-api.php';
    try {

        const response = await fetch(url, {
            method: "POST"
        });

        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const json = await response.json();

        if(json["Success"]){
            console.log("Logged out successfully");
            let header = document.querySelector("body > header > div > div:nth-of-type(2) > figure");
            let newA = document.createElement("a");
            newA.href = "login.php";
            newA.innerText = "Accedi";
            header.replaceWith(newA);
            //if im the login page, reload the page
            if(document.body.classList.contains("login-form")){
                location.reload();
            }
               
                
            
        }
        else{
            console.log("Error logging out");
        }

    } catch (error) {
        console.log(error.message);
    }
}





async function register(name, surname, birthday, city, address, phonenumber, email, username, password, avatarId) {
    
    
    const url = 'api/register-api.php';
    const formData = new FormData();
    formData.append('FirstName', name);
    formData.append('LastName', surname);
    formData.append('Email', email);
    formData.append('Username', username);
    formData.append('Password', password);
    formData.append('DateOfBirth', birthday);
    formData.append('City', city);
    formData.append('Address', address);
    formData.append('PhoneNumber', phonenumber);
    formData.append('AvatarId', avatarId);

    console.log("registering");


    
    try {

        const response = await fetch(url, {
            method: "POST",                   
            body: formData
        });

        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const json = await response.json();


        if(json["Success"]){
            document.querySelector(".registration-form > main > section > p").innerText = "Registration successful";
            putAvatar(json["Avatar"], json["Username"]);
            //modify the register button in order for it to become green to display Back to page
            let button = document.querySelector(".registration-form > main > section > form > fieldset > button");
            let newButton = document.createElement("a");

            newButton.href = document.referrer || "index.php";
            newButton.innerText = "Back to page";
            if(json["isAdmin"]){
                newButton.href = "admin-panel.php";
                newButton.innerText = "Go to admin page";
            }
            button.replaceWith(newButton);
            
        }
        else{
            document.querySelector(".registration-form > main > section > p").innerText = json["Errore"];
    
        }


    } catch (error) {
        console.log(error.message);
    }
}


//when the dom is loaded, check if the user is logged in, and if so call putAvatar
document.addEventListener("DOMContentLoaded", function () {
    //call login function with no parameters to check if the user is logged in
    login(new FormData());
    console.log("dom loaded and called login again");
});


async function login(formData) {
    const url = 'api/login-api.php';
    try {

        const response = await fetch(url, {
            method: "POST",                   
            body: formData
        });

        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const json = await response.json();

    
        if(json["LoggedIn"]){
            putAvatar(json["Avatar"], json["Username"]);
            if(document.body.classList.contains("login-form") || document.body.classList.contains("registration-form")){
                let button = document.querySelector(".login-form > main > section > form > fieldset > button");
                //substitute the button with an "a"
                let newButton = document.createElement("a");
    
                newButton.href = document.referrer || "index.php";
                newButton.innerText = "Back to page";
                if(json["isAdmin"]){
                    newButton.href = "admin-panel.php";
                    newButton.innerText = "Go to admin page";
                }
                button.replaceWith(newButton);
            }
            

        }
        else if(json["ErroreLogin"]){

            document.querySelector(".login-form > main > section > p").innerText = json["ErroreLogin"];
        
        }


    } catch (error) {
        console.log(error.message);
    }
}
