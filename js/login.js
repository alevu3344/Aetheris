function putAvatar(avatar, username){
    let header_accedi = document.querySelector("body > header > div > div:nth-of-type(2) > a");
    let figure = `
        <img src="../media/avatars/${avatar}" alt="Avatar">
        <figcaption>${username}</figcaption>
    `;
    let newFigure = document.createElement("figure");
    newFigure.innerHTML = figure;
    header_accedi.replaceWith(newFigure);
    let logout = document.createElement("div");
    logout.innerHTML = `
        <img src="upload/icons/logout.png" alt="Logout"/>
        `;
    let header_right_div = document.querySelector("body > header > div > div:nth-of-type(2)");
    header_right_div.appendChild(logout);
}


if(document.querySelector("body").className == "registration-form"){
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

        if(password != repeatPassword){
            document.querySelector(".login-form > main > section > p").innerText = "Passwords don't match";
        }
        else{
            register(name, surname, birthday, city, address, phonenumber, email, username, password);
        }
    });
}

if(document.querySelector("body").className == "login-form"){
    // Gestisco tentativo di login
    document.querySelector(".login-form > main > section > form").addEventListener("submit", function (event) {
        event.preventDefault();
        const username = document.querySelector("#username").value;
        const password = document.querySelector("#password").value;
        console.log("submit pressed")
        login(username, password);
    });
}





async function register(name, surname, birthday, city, address, phonenumber, email, username, password) {
    
    
    const url = 'register-api.php';
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
    formData.append('AvatarId', 1);


    
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
            button.replaceWith(newButton);
            
        }
        else{
            document.querySelector(".registration-form > main > section > p").innerText = json["Errore"];
    
        }


    } catch (error) {
        console.log(error.message);
    }
}


async function login(username, password) {
    const url = 'login-api.php';
    const formData = new FormData();
    formData.append('Username', username);
    formData.append('Password', password);
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
            let button = document.querySelector(".login-form > main > section > form > fieldset > button");
            //substitute the button with an "a"
            let newButton = document.createElement("a");

            newButton.href = document.referrer || "index.php";
            newButton.innerText = "Back to page";
            button.replaceWith(newButton);

        }
        else{
            document.querySelector(".login-form > main > section > p").innerText = json["ErroreLogin"];
        
        }


    } catch (error) {
        console.log(error.message);
    }
}
