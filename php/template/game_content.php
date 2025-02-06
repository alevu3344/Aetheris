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



<iframe
    src="<?= $templateParams['gioco']['Trailer'] . "?modestbranding=1" ?>"
    title="Launch trailer of <?= $templateParams['gioco']['Name'] ?>"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
</iframe>


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

<div id="<?= $templateParams["gioco"]["Id"] ?>">
    <button id="buy">Buy now</button>
    <button id="cart">Add to cart</button>
</div>



<section>
    <dl>
        <div>
            <dt>Publisher</dt>
            <dd><?= $templateParams["gioco"]["Publisher"] ?></dd>
        </div>
        <hr>
        </hr>
        <div>
            <dt>Release date</dt>
            <dd><?= date("j/n/y", strtotime($templateParams["gioco"]["ReleaseDate"])) ?></dd>
        </div>
        <hr>
        </hr>
        <div>
            <dt>Platforms</dt>
            <dd>
                <?php foreach ($templateParams["platforms"] as $platform): ?>
                    <img src="upload/icons/<?= $platform["Platform"] ?>.svg" alt="game"/>
                <?php endforeach; ?>
            </dd>
        </div>
        <hr>
        </hr>
        <div class="platform-quantity">
            <dt>Stock per platform</dt>
            <dd>
                <dl>
                    <?php foreach ($templateParams["platforms"] as $platform): ?>
                        <div>
                            <dt>
                                <img src="upload/icons/<?= $platform["Platform"] ?>.svg" alt="game"/>
                            </dt>
                            <dd class=<?= $platform["Stock"] > 0 ? "available" : "expired" ?>><?= $platform["Stock"] ?></dd>
                        </div>
                    <?php endforeach; ?>
                </dl>
            </dd>
        </div>
        <hr>
        </hr>
        <div class="generi">
            <dt>Genres</dt>
            <dd>
                <?php foreach ($templateParams["game-categories"] as $category): ?>
                    <span><?= $category["CategoryName"] ?></span>
                <?php endforeach; ?>
            </dd>
        </div>
        <hr>
        </hr>
    </dl>
</section>


<article>
    <section>
        <h2>Description</h2>
        <p><?= $templateParams["gioco"]["Description"] ?></p>
    </section>
    <?php if (!empty($templateParams["requirements"])): ?>
        <section>
            <h2>Minimum requirements</h2>
            <dl>
                <div>
                    <dt>OS: </dt>
                    <dd><?= $templateParams["requirements"]["OS"] ?></dd>
                </div>
                <div>
                    <dt>CPU: </dt>
                    <dd><?= $templateParams["requirements"]["CPU"] ?></dd>
                </div>
                <div>
                    <dt>Storage: </dt>
                    <dd><?= $templateParams["requirements"]["SSD"] ?> GB</dd>
                </div>
                <div>
                    <dt>GPU: </dt>
                    <dd><?= $templateParams["requirements"]["GPU"] ?></dd>
                </div>
                <div>
                    <dt>RAM: </dt>
                    <dd><?= $templateParams["requirements"]["RAM"] ?> GB</dd>
                </div>
            </dl>
        </section>
    <?php endif; ?>
</article>

<div>
    <h2>Images</h2>
    <div>
        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_1.jpg"
            alt="game"
            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />

        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_2.jpg"
            alt="game"
            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />

        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_3.jpg"
            alt="game"
            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />

        <img src="../media/screenshots/<?= $templateParams["gioco"]["Id"] ?>_frame_4.jpg"
            alt="game"
            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />
    </div>
</div>

<h2>SIMILAR GAMES</h2>
<div>

    <img src="upload/icons/left_arrow.svg" alt="Left arrow"/>
    <div>
        <ul></ul>
    </div>
    <img src="upload/icons/left_arrow.svg" alt="Left arrow"/>
</div>

<h2>REVIEWS</h2>

<? if (isset($_SESSION["Username"])): ?>
    <button id="addReview">Add a review</button>
<? endif; ?>

<ul id="reviewsList">

</ul>

<div>
    <button>Load more reviews</button>
    <img src="upload/icons/double-arrow.png" alt="arrow"/>
</div>

