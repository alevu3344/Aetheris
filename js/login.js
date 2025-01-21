function generateLoginForm(loginerror = null) {
    //modify the class of the body element in the DOM
    document.querySelector("body").className = "login-form";
    let form = `
    <section>
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

function putAvatar(avatar){
    let header = document.querySelector("body > header > div > div:nth-child(2)");
    header.innerHTML = `<img src="img/${avatar}" alt="Avatar">`;
    let logout = document.createElement("a");
    logout.href = "logout-api.php";
    logout.innerText = "Logout";
    header.appendChild(logout);
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
            putAvatar(json["Avatar"]);
        }
        else{
            //add an event listener to the Accedi button in the header
            document.querySelector("body > header > div:nth-child(2) > div:nth-child(2) > a").addEventListener("click", function (event) {
                event.preventDefault();
                createLoginForm();
            });
        }


    } catch (error) {
        console.log(error.message);
    }
}

const main = document.querySelector("main");
console.log("login.js");
getLoginData();  




function createLoginForm() {
    // Utente NON loggato
    let form = generateLoginForm();
    main.innerHTML = form;
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
    formData.append('username', username);
    formData.append('password', password);
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
            // Go back to the main page
            getLoginData();
        }
        else{
            document.querySelector("form > p").innerText = json["ErroreLogin"];
        }


    } catch (error) {
        console.log(error.message);
    }
}
