<a href="orders.php">Controlla ordini</a>

<?php if (empty($templateParams["elementi-carrello"])): ?>
    <div id="empty-cart">
        <div>
            <img src="upload/icons/empty.png" alt="Empty shopping cart"/><p>Wow, such empty</p>
        </div>
    </div>
<?php else: ?>

<ul>

    <?php foreach ($templateParams["elementi-carrello"] as $gioco): ?>
        <li>
            <div>
                <a href="game.php?id=<?= $gioco["Id"] ?>">
                    <img src="../media/covers/<?= $gioco["Id"] ?>.jpg" alt="<?= $gioco["Name"] ?>" onerror="this.onerror=null; this.src='../media/noimage.jpg';"/>
                </a>

                <section>
                    <header>
                        <h2><?= $gioco["Name"] ?></h2>
                        <button>
                            <img src="../media/icons/trash-bin.png" alt="Remove"/>
                        </button>
                    </header>
                    <p>
                        <?php
                        $platforms = array_column($gioco["Platforms"], null, "Platform");
                        ?>
                        <img src="upload/icons/<?= $gioco["Platform"] ?>.svg" alt="<?= $gioco["Platform"] ?>"/><span>Stock: <?= $platforms[$gioco["Platform"]]["Stock"]?></span>
                    </p>
                    <footer>
                        <div>
                            <button>
                                <img src="upload/icons/left_arrow.svg" alt="Increase"/>
                            </button>
                            <span class="quantity"><?= $gioco["Quantity"] ?></span>
                            <button>
                                <img src="upload/icons/left_arrow.svg" alt="Increase"/>
                            </button>
                        </div>
                        <p>
                            <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
                            <?php if (!empty($gioco['Discount'])): ?>
                                <span>-<?= $gioco['Discount'] ?>%</span>
                            <?php endif; ?>
                            <span><?= $gioco['Price'] ?>€</span>
                            <?php if (!empty($gioco['Discount'])): ?>
                                <span><?= number_format($gioco['Price'] * (1 - $gioco['Discount'] / 100), 2) ?>€</span>
                            <?php endif; ?>
                        </p>
                    </footer>
                </section>
            </div>
        </li>
    <?php endforeach; ?>
</ul>
<?php 

$totalCartPrice = 0;
foreach ($templateParams["elementi-carrello"] as $gioco) {
    $itemPrice = $gioco["Price"] * $gioco["Quantity"];
    if (!empty($gioco["Discount"])) {
        $itemPrice *= 1 - $gioco["Discount"] / 100;
    }
    $totalCartPrice += $itemPrice;
}

?>

<p id="total-price">Total: <?= number_format($totalCartPrice, 2) ?>€</p>
<?php endif; ?>

<?php if(!empty($templateParams["elementi-carrello"])): ?>
<button id="checkout">Checkout</button>
<?php endif; ?>