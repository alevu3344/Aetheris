<h1><?= $templateParams["category"] ?></h1>

<nav class="navbar">
    <ul>
        <li><a>Tendenza</a></li><li><a>Nuove uscite</a></li><li><a>Migliori</a></li><li><a>Offerte</a></li>
    </ul>
</nav>
<ul>
    <?php foreach ($templateParams["giochi"] as $game): ?>
        <li>
            <a href="game.php?id=<?= $game['Id'] ?>">
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
                            <?php endif; ?>
                            <span><?= $game['Price'] ?>€</span>
                            <?php if (!empty($game['Discount'])): ?>
                            <span><?= number_format($game['Price'] * (1 - $game['Discount'] / 100), 2)?>€</span>
                        <?php endif; ?>
                    </footer>
                </article>
            </a>
        </li>
    <?php endforeach; ?>
</ul>


<!-- TO BE CHANGED DO A NAV -->

<div>
    <img src="upload/icons/left_arrow.svg" alt="Left arrow"/>
    <span class="page-number">1</span> <!-- Current page number -->
    <img src="upload/icons/left_arrow.svg" alt="Right arrow"/>
</div>
