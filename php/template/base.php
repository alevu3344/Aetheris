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
    <link href='https://fonts.googleapis.com/css?family=Rampart%20One' rel="stylesheet">
</head>
<!-- the body will have the class extracted from templateParams["nome"] without the .php-->

<body class="<?= explode(".", $templateParams["nome"])[0] ?>">

    <header>
        <div>
            <div>
            <a href=<?= (isset($_SESSION["isAdmin"]) && $_SESSION["isAdmin"]) ? "admin-panel.php" : "index.php" ?>>

                    <img src="upload/icons/aetheris_logo.png" alt="Logo" />
                </a>
                <h1>Aetheris</h1>
            </div>

            <div>
                <a id="signin" href="login.php">Accedi</a>
            </div>
        </div>
        <?php if(isset($templateParams["categorie"])): ?>
            <nav>
        <!-- SEARCH BAR -->
                <div>
                    <div>
                        <div></div> <!-- GLOW -->

                        <div></div> <!-- BORDER -->

                        <div> <!-- INPUT CONTAINER -->
                            <label for="search-bar">Search:</label>
                            <input id="search-bar" placeholder="Cerca gioco..." type="text" name="text"/> <!-- INPUT -->
                        </div>
                        <ul></ul>
                    </div>
                    <?php if(isset($_SESSION["Username"])): ?>
                        <?php if(isset($_SESSION["isAdmin"]) && $_SESSION["isAdmin"]): ?>
                            <a href="orders.php">
                                <img src="upload/icons/orders.png" alt="Pending Orders"/>
                            </a>
                        <?php else: ?>
                        <a href="cart.php">
                            <img src="upload/icons/shopping-cart.svg" alt="Shopping Cart"/>
                        </a>
                        <?php endif; ?>
                    <?php endif; ?>
                </div>
        <!-- SEARCH BAR -->
                <div>
                    <button id="categories-toggle">Categories</button>
                    <ul id="categories-list">
                        <?php foreach ($templateParams["categorie"] as $categoria): ?>
                            <?php if(isset($_SESSION["isAdmin"]) && $_SESSION["isAdmin"]): ?>
                                <li><a href="admin-panel.php?category=<?= $categoria["CategoryName"] ?>"><?= $categoria["CategoryName"] ?></a></li>
                            <?php else: ?>
                            <li><a href="categorygames.php?category=<?= $categoria["CategoryName"] ?>"><?= $categoria["CategoryName"] ?></a></li>
                            <?php endif; ?>
                        <?php endforeach; ?>
                    </ul>
                </div>
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
            <ul><li><img src="upload/icons/instagram.png" alt="Instagram" /><a href="#">Instagram</a></li><li><img src="upload/icons/pinterest.png" alt="Pinterest" /><a href="#">Pinterest</a></li><li><img src="upload/icons/youtube.png" alt="Youtube" /><a href="#">Youtube</a></li><li><img src="upload/icons/twitter.png" alt="Twitter" /><a href="#">Twitter</a></li></ul>
        </nav>
    </footer>
</body>

<script src="../js/login.js" defer="true"></script>
<script src="../js/base.js?admin=<?= isset($_SESSION["isAdmin"]) && $_SESSION["isAdmin"] ? 'true' : 'false' ?>" defer="true"></script>
<script src="../js/search-bar.js?admin=<?= isset($_SESSION["isAdmin"]) && $_SESSION["isAdmin"] ? 'true' : 'false' ?>" defer></script>

</html>