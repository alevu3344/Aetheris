<h1>Azione</h1>

<nav class="navbar">
    <ul>
        <li><a>Tendenza</a></li><li><a>Nuove uscite</a></li><li><a>Migliori</a></li><li><a>Offerte</a></li>
    </ul>
</nav>

<?php foreach ($templateParams["giochi"] as $game): ?>
    <article>
        <figure>

            <img src= <?= "../media/covers/".$game['Id'].".jpg" ?>
                 alt="<?= $game["Name"] ?>"/>
            <figcaption><?= $game["Name"] ?></figcaption>
        </figure>
        <footer>
            <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
            <?php if (!empty($game['Discount'])): ?>
                <span>-<? echo $game['Discount']?>%</span>
                <span><?= $game['Price'] ?>€</span>
                <span><?= $game['Price'] * (1 - $game['Discount']/100) ?>€</span>
            <?php endif; ?>
        </footer>
    </article>
<?php endforeach; ?>
