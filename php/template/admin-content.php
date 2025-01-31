<ul>
    <?php foreach ($templateParams["giochi"] as $gioco): ?>
        <li class="game" id="<?= $gioco["Id"] ?>">
            <section>
                <img src="../media/covers/<?= $gioco["Id"] ?>.jpg" />
                <div>
                    <dl>
                        <div>
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Titolo: </dt>
                            </div>
                            <dd><?= $gioco["Name"] ?></dd>
                        </div>
                        <div id="categories">
                            <dt>Generi: </dt>
                            <dd>
                                <?php foreach ($gioco["Categories"] as $categoria): ?>
                                    <span><?= $categoria["CategoryName"] ?></span>
                                <?php endforeach; ?>

                            </dd>
                        </div>
                        <div>
                            <dt>Piattaforme: </dt>
                            <dd>
                                <?php foreach ($gioco["Platforms"] as $platform): ?>
                                    <img src="upload/icons/<?= $platform["Platform"] ?>.svg" />
                                <?php endforeach; ?>
                            </dd>
                        </div>
                        <div>
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Sviluppatore: </dt>
                            </div>
                            <dd><?= $gioco["Publisher"] ?></dd>
                        </div>

                        <div>
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Prezzo: </dt>
                            </div>
                            <dd><?= $gioco["Price"] ?>€</dd>
                        </div>

                        <?php if (!empty($gioco["Discount"])): ?>
                            <dl>

                                <div>
                                    <div>
                                        <button class="edit">Edit</button>
                                        <dt>Sconto: </dt>
                                    </div>
                                    <dd>-<?= $gioco["Discount"] ?>%</dd>
                                </div>
                                <div>
                                    <div>
                                        <button class="edit">Edit</button>
                                        <dt>Inizio: </dt>
                                    </div>
                                    <dd><?= date("j/n/y", strtotime($gioco["StartDate"])) ?></dd>
                                </div>
                                <div>
                                    <div>
                                        <button class="edit">Edit</button>
                                        <dt>Fine: </dt>
                                    </div>
                                    <dd><?= date("j/n/y", strtotime($gioco["EndDate"])) ?></dd>
                                </div>
                            </dl>
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
                            <div>
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>OS: </dt>
                                </div>
                                <dd><?= $gioco["Requirements"]["OS"] ?></dd>
                            </div>
                            <div>
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>RAM: </dt>
                                </div>
                                <dd><?= $gioco["Requirements"]["RAM"] ?> GB</dd>
                            </div>
                            <div>
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>GPU: </dt>
                                </div>
                                <dd><?= $gioco["Requirements"]["GPU"] ?></dd>
                            </div>
                            <div>
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>CPU: </dt>
                                </div>
                                <dd><?= $gioco["Requirements"]["CPU"] ?></dd>
                            </div>
                            <div>
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>Storage: </dt>
                                </div>
                                <dd><?= $gioco["Requirements"]["SSD"] ?> GB</dd>
                            </div>
                        </dl>
                    <?php endif; ?>
                </div>
                <div class="actions">
                    <a href="game_mod.php?game=<?= $gioco["Id"] ?>">Modifica</a>
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
