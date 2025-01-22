<!DOCTYPE html>
<html lang="it">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><?php echo $templateParams["titolo"]; ?></title>
    <link rel="icon" type="image/ico" href="/e-shop/php/upload/icons/aetheris_logo.ico">



    <!--if templateParams["stylesheet"] is set, link to that one, otherwise to the standard tyle.cc-->
    <link rel="stylesheet" type="text/css" href="./css/style.css">
    <?php if (isset($templateParams["stylesheet"])): ?>
        <link rel="stylesheet" type="text/css" href="./css/<?= $templateParams["stylesheet"] ?>">
    <?php endif; ?>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sedgwick+Ave+Display&display=swap" rel="stylesheet">
    <link href='https://fonts.googleapis.com/css?family=Rampart One' rel='stylesheet'>
    <script src="../js/base.js" defer="true"></script>
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
                <?php if (isset($_SESSION["UserID"])): ?>
                    <figure>
                        <img src="../media/avatars/<?= $_SESSION["Avatar"] ?>" alt="Avatar">
                        <figcaption><?= $_SESSION["Username"] ?></figcaption>
                    </figure>
                    <div>
                        <img src="upload/icons/logout.png" alt="Logout"/>  
                    </div>
                <?php else: ?>
                    <a id="signin" href="login.php">Accedi</a>
                <?php endif; ?>
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