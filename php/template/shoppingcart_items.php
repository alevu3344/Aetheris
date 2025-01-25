<ul>
    <?php foreach ($templateParams["elementi-carrello"] as $gioco): ?>
        <li>
            <div>

                <img src="../media/covers/<?= $gioco["Id"] ?>.jpg" alt="<?= $gioco["Name"] ?>">


                <section>
                    <header>
                        <h2><?= $gioco["Name"] ?></h2>
                        <button>
                            <img src="../media/icons/trash-bin.png" alt="Remove">
                        </button>
                    </header>
                    <p>
                        <?php foreach ($gioco["Platforms"] as $platform): ?>
                            <img src="../media/platforms/<?= $platform["Platform"] ?>.svg" alt="<?= $platform["Platform"] ?>">
                        <?php endforeach; ?>
                    </p>
                    <footer>
                        <div>
                            <button>
                                <img src="upload/icons/left_arrow.svg" alt="Increase">
                            </button>
                            <span class="quantity"><?= $gioco["Quantity"] ?></span>
                            <button>
                                <img src="upload/icons/left_arrow.svg" alt="Increase">
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




<button id="checkout">Checkout</button>