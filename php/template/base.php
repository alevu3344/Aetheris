<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><?php echo $templateParams["titolo"]; ?></title>
<!--if templateParams["stylesheet"] is set, link to that one, otherwise to the standard tyle.cc-->
    <link rel="stylesheet" type="text/css" href="./css/style.css">
    <?php if(isset($templateParams["stylesheet"])): ?>
        <link rel="stylesheet" type="text/css" href="./css/<?= $templateParams["stylesheet"] ?>">
    <?php endif; ?>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sedgwick+Ave+Display&display=swap" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Rampart One' rel='stylesheet'>
</head>
    <!-- the body will have the class extracted from templateParams["nome"] without the .php-->
<body class="<?= explode(".", $templateParams["nome"])[0] ?>">
    <header>
        <div>
            <img src="upload/icons/aetheris_logo.png" alt="Logo"/>
            <h1>Aetheris</h1>
        </div>

        <div>
            <div>
                <a href="#">Categorie</a>
            </div>
            <div>
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
        <div>
            <p>Aetheris</p>
        </div>
        <div> 
            <nav>
                <ul>
                     <li><img src="upload/icons/instagram.png" alt="Instagram"/><a href="#">Instagram</a></li><li><img src="upload/icons/pinterest.png" alt="Pinterest"/><a href="#">Pinterest</a></li><li><img src="upload/icons/youtube.png" alt="Youtube"/><a href="#">Youtube</a></li><li><img src="upload/icons/twitter.png" alt="Twitter"/><a href="#">Twitter</a></li>
                </ul>
            </nav>        
        </div>
            <div>
                <a href="#">Track an order</a>
            </div>
    </footer>
</body>
</html>
