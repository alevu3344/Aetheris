<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><?php echo $templateParams["titolo"]; ?></title>
    <link rel="stylesheet" type="text/css" href="./css/style.css" />
</head>
<body>
    <header>
        <div class="header-left">
            <img src="path-to-your-logo.png" alt="Logo" class="logo" />
            <h1>Aetheris</h1>
        </div>

        <div class="header-right">
            <div class="nav-links">
                <a href="#">Negozio</a>
                <a href="#">Novità</a>
                <a href="#">Categorie</a>
            </div>
            <button>Sign In</button>
            <select class="language-select">
                <option value="it">Italiano</option>
                <option value="en">English</option>
                <option value="de">Deutsch</option>
                <!-- Add more languages here -->
            </select>
        </div>
    </header>

    <!-- Fake Main content section to separate header and footer -->
    <main class="fake-main">
        <!-- You can add content here or leave it empty for now -->
    </main>

    <footer>
        <p>Aetheris</p>
    </footer>
</body>
</html>
