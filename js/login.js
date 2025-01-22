function generateLoginForm(loginerror = null) {
    //modify the class of the body element in the DOM
    document.querySelector("body").className = "login-form";
    let form = `
    <section>
    <div>
        <img src="upload/icons/cross.png" alt="Logo">
    </div>
    <h2>Login</h2>
    <form>
        <fieldset>
            <label for="username">Username</label>
            <input type="text" name="username" id="username" placeholder="">

            <label for="password">Password</label>
            <input type="password" name="password" id="password" placeholder="">

            <p>
                <a rel="noopener noreferrer" href="#">Forgot Password?</a>
            </p>

            <button type="submit">Sign in</button>
        </fieldset>
    </form>

    <p>Don't have an account?
        <a rel="noopener noreferrer" href="#" class="">Sign up</a>
    </p>
</section>
    `;
    return form;
}

function generateRegistrationForm(loginerror = null) {
    //modify the class of the body element in the DOM
    document.querySelector("body").className = "registration-form";
    let form = `
    <section>
        <div>
            <img src="upload/icons/cross.png" alt="Logo">
        </div>
        <h2>Register</h2>
        <form>
            <fieldset>
                <label for="name">Name</label>
                <input type="text" name="name" id="name" placeholder="Your Name">

                <label for="surname">Surname</label>
                <input type="text" name="surname" id="surname" placeholder="Your Surname">

                <label for="email">Email</label>
                <input type="email" name="email" id="email" placeholder="Your Email">

                <label for="username">Username</label>
                <input type="text" name="username" id="username" placeholder="Choose a Username">

                <label for="password">Password</label>
                <input type="password" name="password" id="password" placeholder="Choose a Password">

                <label for="repeat-password">Repeat Password</label>
                <input type="password" name="repeat-password" id="repeat-password" placeholder="Repeat your Password">

                <p class>
                    <a id="back-to-login" href="#">Already have an account? Login</a>
                </p>

                <button type="submit">Register</button>
            </fieldset>
        </form>

        <p>By registering, you agree to our terms and conditions.</p>
</section>
    `;
    return form;
}

function putAvatar(avatar, username){
    let header_accedi = document.querySelector("body > header > div:nth-child(2) > a:nth-child(2)");
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
    let header_right_div = document.querySelector("body > header > div:nth-child(2)");
    header_right_div.appendChild(logout);
    logout.addEventListener("click", function (event) {
        event.preventDefault();
        getLoginData();
    });
}


async function getLoginData() {
    const url = 'login-api.php';
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const json = await response.json();
        console.log(json);
        if(json["LoggedIn"]){
            putAvatar(json["Avatar"], json["Username"]);
        }
        else{
            //add an event listener to the Accedi button in the header
            document.querySelector("body > header > div:nth-child(2) > #signin").addEventListener("click", function (event) {
                event.preventDefault();
                createLoginForm();
            });
        }


    } catch (error) {
        console.log(error.message);
    }
}

let body = document.querySelector("body");
let main = body.querySelector("main");
let originalMain = main.innerHTML;
let originalClass = body.className;
console.log(originalClass);
console.log("login.js");

getLoginData();  




function createLoginForm() {


  
    let form = generateLoginForm();
    main.innerHTML = form;

    // Handle the close button click
    document.querySelector(".login-form > main > section > div > img").addEventListener("click", function () {
        main.innerHTML = originalMain; // Restore the previous content
        document.querySelector("body").className = originalClass;
        console.log("Close button clicked");
    });

    //handle the sign up link click
    document.querySelector(".login-form > main > section > p > a").addEventListener("click", function (event) {
        event.preventDefault();
        let form = generateRegistrationForm();
        main.innerHTML = form;
        document.querySelector("body").className = "registration-form";
        //add a listener on the sign in link of the registration form
        document.querySelector(".registration-form > main > section > form > fieldset > p > a").addEventListener("click", function (event) {
            event.preventDefault();
            console.log("Sign up link clicked");
            createLoginForm();
        });
        
    });
    // Gestisco tentativo di login
    document.querySelector(".login-form > main > section > form").addEventListener("submit", function (event) {
        event.preventDefault();
        console.log("Login form submitted");
        const username = document.querySelector("#username").value;
        const password = document.querySelector("#password").value;
        login(username, password);
    });
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

        console.log(json);
        if(json["LoggedIn"]){
            // Go back to the main page
            console.log("Login successful");
            getLoginData();
        }
        else{
            document.querySelector(".login-form > main > section > p").innerText = json["ErroreLogin"];
            console.log("Login NOOOOO");
        }


    } catch (error) {
        console.log(error.message);
    }
}
