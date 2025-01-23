<h1><?= $templateParams["gioco"]["Name"] ?></h1>


<div>
    <div class="stars">

        <div class="star"></div>
        <div class="star"></div>
        <div class="star"></div>
        <div class="star"></div>
        <div class="star"></div>
    </div>

    <span><?= $templateParams["gioco"]["Rating"] ?></span>
</div>

<!-- Game cover image -->
<img src="../media/covers/<?= $templateParams["gioco"]["Id"] ?>.jpg" alt="game">

<section>
    <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
    <?php if (!empty($templateParams["gioco"]['Discount'])): ?>
        <span>-<?= $templateParams["gioco"]['Discount'] ?>%</span>
    <?php endif; ?>
    <span><?= $templateParams["gioco"]['Price'] ?>€</span>
    <?php if (!empty($templateParams["gioco"]['Discount'])): ?>
        <span><?= number_format($templateParams["gioco"]['Price'] * (1 - $templateParams["gioco"]['Discount'] / 100), 2) ?>€</span>
    <?php endif; ?>
</section>

<div id="<?=$templateParams["gioco"]["Id"]?>">
    <button>Acquista ora</button>
    <button>Aggiungi al carrello</button>
</div>



<section>
    <dl>
        <div>
            <dt>Sviluppatore</dt>
            <dd><?= $templateParams["gioco"]["Publisher"] ?></dd>
        </div>
        <div>
            <dt>Data di uscita</dt>
            <dd><?= date("j/n/y", strtotime($templateParams["gioco"]["ReleaseDate"])) ?></dd>
        </div>
        <div>
            <dt>Piattaforma</dt>
            <dd>
                <?php foreach ($templateParams["platforms"] as $platform): ?>
                    <img src="upload/icons/<?= $platform["Platform"] ?>.svg" alt="game">
                <?php endforeach; ?>
            </dd>
        </div>
        <div>
            <dt>Generi</dt>
            <dd>
                <?php foreach ($templateParams["game-categories"] as $category): ?>
                    <span><?= $category["CategoryName"] ?></span>
                <?php endforeach; ?>
            </dd>
        </div>
    </dl>
</section>


<article>
    <section>
        <h2>Descrizione</h2>
        <p><?= $templateParams["gioco"]["Description"] ?></p>
    </section>
    <?php if (!empty($templateParams["requirements"])): ?>
        <section>
            <h2>Requisiti minimi</h2>
            <dl>
                <div>
                    <dt>Sistema operativo: </dt>
                    <dd><?= $templateParams["requirements"]["OS"]?></dd>
                </div>
                <div>
                    <dt>CPU: </dt>
                    <dd><?= $templateParams["requirements"]["CPU"]?></dd>
                </div>
                <div>
                    <dt>Memoria: </dt>
                    <dd><?= $templateParams["requirements"]["SSD"]?> GB</dd>
                </div>
                <div>
                    <dt>GPU: </dt>
                    <dd><?= $templateParams["requirements"]["GPU"]?></dd>
                </div>
                <div>
                    <dt>RAM: </dt>
                    <dd><?= $templateParams["requirements"]["RAM"]?> GB</dd>
                </div>
            </dl>
        </section>
    <?php endif; ?>
</article>

<div>
    <h2>Immagini</h2>
    <div>
        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_1.jpg" alt="game">
        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_2.jpg" alt="game">
        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_3.jpg" alt="game">
        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_4.jpg" alt="game">
    </div>
</div>


<h2>Giochi simili</h2>
<div>

    <img src="upload/icons/left_arrow.svg" alt="Left arrow">
    <ul>
        <?php foreach ($templateParams["similar-games"] as $game): ?>
            <li>
                <a href = "game.php?id=<?= $game["Id"]?>">
                    <article>
                        <figure>

                            <img src="../media/covers/<?= $game["Id"]?>.jpg"
                                alt="game" />
                            <figcaption><?= $game["Name"]?></figcaption>
                        </figure>
                        <footer>
                            <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
                            <?php if (!empty($game['Discount'])): ?>
                                <span>-<?= $game['Discount'] ?>%</span>
                            <?php endif; ?>
                            <span><?= $game['Price'] ?>€</span>
                            <?php if (!empty($game['Discount'])): ?>
                                <span><?= number_format($game['Price'] * (1 - $game['Discount'] / 100), 2) ?>€</span>
                            <?php endif; ?>

                        </footer>
                    </article>
                </a>
            </li>
        <?php endforeach; ?>
    </ul>
    <img src="upload/icons/left_arrow.svg" alt="Left arrow">
</div>

<h2>Recensioni</h2>

<ul>
    <?php foreach ($templateParams["recensioni"] as $recensione): ?>
        <li>
            <article>
                <header>
                    <img src="../media/avatars/<?= $recensione["Avatar"] ?>" alt="avatar">
                    <section>
                        <div>
                            <span><?= $recensione["Username"] ?></span>
                            <div class="stars">
                                <span><?= $recensione["Rating"] ?></span>
                                <div class="star"></div>
                                <div class="star"></div>
                                <div class="star"></div>
                                <div class="star"></div>
                                <div class="star"></div>
                                
                            </div>
                        </div>
                    </section>
                </header>
                <h2><?= $recensione["Title"] ?></h2>
                <p><?= $recensione["Comment"] ?></p>
                <footer>
                    <span><?= $recensione["CreatedAt"] ?></span>
                </footer>
            </article>
        </li>
        
    <?php endforeach; ?>
</ul>

<div>
    <button>Carica più recensioni</button>
    <img src="upload/icons/double-arrow.png" alt="arrow">
</div>


<script src="../js/game.js"></script>