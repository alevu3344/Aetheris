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
            <img src="upload/icons/aetheris_logo.png" alt="Logo" class="logo" />
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

    <main>
        <?php
        if(isset($templateParams["nome"])){
            require($templateParams["nome"]);
        }
        ?>

    </main>

    <footer>
        <p>Aetheris</p>
    </footer>
</body>
</html>
