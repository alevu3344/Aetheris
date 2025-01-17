<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><?php echo $templateParams["titolo"]; ?></title>
    <link rel="stylesheet" type="text/css" href="./css/style.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sedgwick+Ave+Display&display=swap" rel="stylesheet">
</head>
<body>
    <header>
        <div class="header-left">
            <img src="upload/icons/aetheris_logo.png" alt="Logo" class="logo" />
            <h1>Aetheris</h1>
        </div>

        <div class="header-right">
            <div class="nav-categorie">
                <a href="#">Categorie</a>
            </div>
            <div class="nav-accedi">
                <a href="#">Accedi</a>
            </div>
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
        <div class="footer-top">
            <p>Aetheris</p>
        </div>
        <div class="footer-middle">
            
            <nav>
                <ul>
                     <li><img src="upload/icons/instagram.png" alt="Instagram" class="instagram"/><a href="#">Instagram</a></li><li><img src="upload/icons/pinterest.png" alt="Pinterest" class="pinterest"/><a href="#">Pinterest</a></li><li><img src="upload/icons/youtube.png" alt="Youtube" class="youtube"/><a href="#">Youtube</a></li><li><img src="upload/icons/twitter.png" alt="Twitter" class="twitter"/><a href="#">Twitter</a></li>
                </ul>
            </nav>        
        </div>
            <div class="footer-bottom">
                <a href="#">Track an order</a>
            </div>
    </footer>
</body>
</html>
