<!DOCTYPE html>
<html lang="it">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><?= $templateParams["titolo"]; ?></title>
    <link rel="icon" type="image/ico" href="/e-shop/php/upload/icons/aetheris_logo.ico">



    <!--if templateParams["stylesheet"] is set, link to that one, otherwise to the standard tyle.cc-->
    <link rel="stylesheet" type="text/css" href="./css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sedgwick+Ave+Display&display=swap" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Rampart One' rel='stylesheet'>
    <script src="../js/base.js" defer="true"></script>
    <script src="../js/login.js" defer="true"></script>
</head>
<!-- the body will have the class extracted from templateParams["nome"] without the .php-->

<body class="<?= explode(".", $templateParams["nome"])[0] ?>">

    <header>
        <div>
            <div>
                <img src="upload/icons/aetheris_logo.png" alt="Logo" />
                <h1>Aetheris</h1>
            </div>

            <div>
                <a id="signin" href="login.php">Accedi</a>
            </div>
        </div>
        <?php if(isset($templateParams["categorie"])): ?>
            <nav>
                <button id="categories-toggle">Categories</button>
                <ul id="categories-list" style="display: none; overflow-y: scroll; max-height: 200px;">
                    <?php foreach ($templateParams["categorie"] as $categoria): ?>
                        <li><a href="categorygames.php?category=<?= $categoria["CategoryName"] ?>"><?= $categoria["CategoryName"] ?></a></li>
                    <?php endforeach; ?>
                </ul>
            </nav>
        <?php endif; ?>
    </header>

    <main>
        <?php
        if (isset($templateParams["nome"])) {
            require($templateParams["nome"]);
        }
        ?>

    </main>

    <footer>

        <p>Aetheris</p>


        <nav>
            <ul>
                <li><img src="upload/icons/instagram.png" alt="Instagram" /><a href="#">Instagram</a></li>
                <li><img src="upload/icons/pinterest.png" alt="Pinterest" /><a href="#">Pinterest</a></li>
                <li><img src="upload/icons/youtube.png" alt="Youtube" /><a href="#">Youtube</a></li>
                <li><img src="upload/icons/twitter.png" alt="Twitter" /><a href="#">Twitter</a></li>
            </ul>
        </nav>

        <a href="#">Track an order</a>

    </footer>
</body>

</html>