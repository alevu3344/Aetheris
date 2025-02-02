<ul>
    <?php foreach ($templateParams["giochi"] as $gioco): ?>
        <li class="game" id="<?= $gioco["Id"] ?>">
            <section>
                <img src="../media/covers/<?= $gioco["Id"] ?>.jpg" />
                <div>
                    <dl>
                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Titolo: </dt>
                            </div>
                            <dd id="Name"><?= $gioco["Name"] ?></dd>
                        </div>
                        <div class="possible-form" id="categories">
                            <div>
                                <button class="edit-categories">Edit</button>
                                <dt>Generi: </dt>
                            </div>
                            <dd>
                                <?php foreach ($gioco["Categories"] as $categoria): ?>
                                    <span><?= $categoria["CategoryName"] ?></span>
                                <?php endforeach; ?>

                            </dd>
                        </div>
                        <div class="possible-form" id="platforms">
                            <div>
                                <button class="edit-platforms">Edit</button>
                                <dt>Piattaforme: </dt>
                            </div>
                            <dd>
                                <?php foreach ($gioco["Platforms"] as $platform): ?>
                                    <img class="platform-icon" src="upload/icons/<?= $platform["Platform"] ?>.svg" />
                                <?php endforeach; ?>
                            </dd>
                        </div>

                        <?php foreach ($gioco["Platforms"] as $platform): ?>
                            <div class="possible-form" id="<?= $platform?>">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt><?= $platform["Platform"] ?>(stock):</dt>
                                </div>
                                <dd id="<?= $platform["Platform"] ?>" class=<?= $platform["Stock"] > 0 ? "available" : "expired" ?>><?= $platform["Stock"] ?></dd>
                            </div>
                        <?php endforeach; ?>
                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Sviluppatore: </dt>
                            </div>
                            <dd id="Publisher"><?= $gioco["Publisher"] ?></dd>
                        </div>

                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>TrailerURL: </dt>
                            </div>
                            <dd id="Trailer"><?= $gioco["Trailer"] ?></dd>
                        </div>

                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Prezzo: </dt>
                            </div>
                            <div>
                                <dd id="Price"><?= $gioco["Price"] ?></dd>
                                <span>€</span>
                            </div>
                        </div>

                        <?php if (!empty($gioco["Discount"])): ?>


                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>Sconto: </dt>
                                </div>
                                <div>
                                    <span>-</span>
                                    <dd id="Discount"><?= $gioco["Discount"] ?></dd>
                                    <span>%</span>
                                </div>
                            </div>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>Inizio: </dt>
                                </div>
                                <dd id="StartDate"><?= date("j/n/y", strtotime($gioco["StartDate"])) ?></dd>
                            </div>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>Fine: </dt>
                                </div>
                                <dd id="EndDate"><?= date("j/n/y", strtotime($gioco["EndDate"])) ?></dd>
                            </div>

                        <?php endif; ?>
                    </dl>

                    <?php
                    $hasPCPlatform = false;
                    foreach ($gioco["Platforms"] as $platform) {
                        if (strtolower($platform["Platform"]) === "pc") {
                            $hasPCPlatform = true;
                            break;
                        }
                    }
                    ?>
                    <?php if ($hasPCPlatform): ?>

                        <p>Requisiti minimi</p>
                        <dl>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>OS: </dt>
                                </div>
                                <dd id="OS"><?= $gioco["Requirements"]["OS"] ?></dd>
                            </div>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>RAM: </dt>
                                </div>
                                <div>
                                    <dd id="RAM"><?= $gioco["Requirements"]["RAM"] ?></dd>
                                    <span>GB</span>
                                </div>
                            </div>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>GPU: </dt>
                                </div>
                                <dd id="GPU"><?= $gioco["Requirements"]["GPU"] ?></dd>
                            </div>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>CPU: </dt>
                                </div>
                                <dd id="CPU"><?= $gioco["Requirements"]["CPU"] ?></dd>
                            </div>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>Storage: </dt>
                                </div>
                                <div>
                                    <dd id="SSD"><?= $gioco["Requirements"]["SSD"] ?></dd>
                                    <span>GB</span>
                                </div>
                            </div>
                        </dl>
                    <?php endif; ?>
                </div>
                <div class="actions">
                    <a href="game_mod.php?game=<?= $gioco["Id"] ?>">Modifica</a>
                    <button data-id="<?= $gioco["Id"] ?>">Modifica stock</button>
                    <button class="delete" data-id="<?= $gioco["Id"] ?>">Elimina</button>

                </div>
            </section>
        </li>
    <?php endforeach; ?>
</ul>

<?php

$publisherList = $templateParams["publishers"];
$publisherJson = json_encode($publisherList);

// Make sure to encode the JSON string for use in the URL
$publisherJsonEscaped = urlencode($publisherJson);

$categorieList = $templateParams["categorie"];
$categorieJson = json_encode($categorieList);

// Make sure to encode the JSON string for use in the URL
$categorieJsonEscaped = urlencode($categorieJson);

?>

<script src="../js/admin-panel.js?publishers=<?= $publisherJsonEscaped ?>&categories=<?= $categorieJsonEscaped ?>"></script>