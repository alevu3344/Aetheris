

if (document.body.classList.contains("registration-form")) {
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



        if (password != repeatPassword) {
            document.querySelector(".login-form > main > section > p").innerText = "Passwords don't match";
        }
        else {
            register(name, surname, birthday, city, address, phonenumber, email, username, password, avatarId);
        }
    });
}


document.addEventListener("click", function (event) {
    if (event.target.closest("#logout")) {
        logout();
    }
});


if (document.body.classList.contains("login-form")) {
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


async function logout() {
    const url = 'api/logout-api.php';
    try {

        const response = await fetch(url, {
            method: "POST"
        });

        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }
        const json = await response.json();

        if (json["Success"]) {
            console.log("Logged out successfully");

            window.location.href = "index.php";
        }
        else {
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


        if (json["Success"]) {

            if (json["isAdmin"]) {
                window.location.href = "admin-panel.php";
            }
            else {
                //redirects to previous page or index
                if (document.referrer == "") {
                    window.location.href = "index.php";
                }
                else {
                    window.location.href = document.referrer;
                }
            }
        }


    } catch (error) {
        console.log(error.message);
    }
}



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


        if (json["LoggedIn"]) {
            if (document.body.classList.contains("login-form") || document.body.classList.contains("registration-form")) {

                if (json["isAdmin"]) {
                    //redirect to admin panel
                    window.location.href = "admin-panel.php";
                } else {
                    //redirects to previous page or index
                    if (document.referrer == "") {
                        window.location.href = "index.php";
                    }
                    else {
                        window.location.href = document.referrer;
                    }
                }

            }


        }
        else if (json["ErroreLogin"]) {

            document.querySelector(".login-form > main > section > p").innerText = json["ErroreLogin"];

        }


    } catch (error) {
        console.log(error.message);
    }
}
