<?php if (empty($templateParams["orders"])): ?>
    <div id="empty-cart">
        <div>
            <img src="upload/icons/empty.png" alt="No orders" />
            <p>No orders yet!</p>
        </div>
    </div>
<?php endif; ?>

<ul>

    <?php foreach ($templateParams["orders"] as $order): ?>
        <li>
            <article>
                <header>
                    <h2 id="<?= $order["OrderId"] ?>">Order #<?= $order["OrderId"] ?></h2>
                    <p>
                        <?= (new DateTime($order["OrderDate"]))->format('j/n/y H:i'); ?>
                    </p>
                    <p class="status" data-order-id= "<?= $order["OrderId"]?>"id="<?= $order["Status"] ?>"><?= $order["Status"] ?></p>
                </header>
                <section>
                    <h3>Games</h3>
                    <ul>
                        <?php foreach ($order["OrderItems"] as $item): ?>
                            <li>
                                <a href="game.php?id=<?= $item["GameId"] ?>">
                                    <img src="../media/covers/<?= $item["GameId"] ?>.jpg" alt="game" onerror="this.onerror=null; this.src='../media/noimage.jpg';" />
                                    <div>
                                        <div>
                                            <h4><?= $item["Name"] ?></h4>
                                            <img src="upload/icons/<?= $item["Platform"] ?>.svg" alt="<?= $item["Platform"] ?>"/>
                                            <span>Quantity: <?= $item["Quantity"] ?>x</span>
                                        </div>
                                        <p>
                                            <?php if (!empty($item['Discount']['Percentage'])): ?>
                                                <span>-<?= number_format($item['Discount']['Percentage']) ?>%</span>
                                            <?php endif; ?>
                                            <span><?= $item['InitialPrice'] ?>€</span>
                                            <?php if (!empty($item['Discount']['Percentage'])): ?>
                                                <span><?= number_format($item['InitialPrice'] * (1 - $item['Discount']['Percentage'] / 100), 2) ?>€</span>
                                            <?php endif; ?>
                                        </p>
                                    </div>
                                </a>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                </section>
                <footer>
                    <p>Total: <?= $order["TotalCost"] ?>€</p>
                </footer>
            </article>
        </li>
    <?php endforeach; ?>
</ul>

<script src="../js/orders.js"></script>