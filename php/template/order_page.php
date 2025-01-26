<ul>
    <li>
        <article>
            <header>
                <h2>Order #<?= $order["Id"] ?></h2>
                <p><?= $order["Date"] ?></p>
            </header>
            <section>
                <h3>Games</h3>
                <ul>
                    <?php foreach($order["Games"] as $game): ?>
                        <li>
                            <div>
                                <img src="../media/game_covers/<?= $game["Id"] ?>.jpg" alt="game">
                                <div>
                                    <h4><?= $game["Name"] ?></h4>
                                    <p><?= $game["Price"] ?>€</p>
                                </div>
                            </div>
                        </li>
                    <?php endforeach; ?>
                </ul>
            </section>
            <footer>
                <p>Total: <?= $order["Total"] ?>€</p>
            </footer>
        </article>
    </li>
</ul>