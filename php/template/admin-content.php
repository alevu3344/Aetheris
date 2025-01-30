<ul>
    <?php foreach ($templateParams["giochi"] as $gioco): ?>
        <li class="game" id="<?= $gioco["Id"] ?>">
            <section>
                <img src="../media/covers/<?= $gioco["Id"] ?>.jpg" />
                <div>
                    <dl>
                        <div>
                            <dt>Titolo: </dt>
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
                            <dt>Sviluppatore: </dt>
                            <dd><?= $gioco["Publisher"] ?></dd>
                        </div>

                        <?php if (!empty($gioco["Discount"])): ?>
                            <dl>
                                <div>
                                    <dt>Prezzo: </dt>
                                    <dd><?= $gioco["Price"] ?>€</dd>
                                </div>
                                <div>
                                    <dt>Sconto: </dt>
                                    <dd>-<?= $gioco["Discount"] ?>%</dd>
                                </div>
                                <div>
                                    <dt>Inizio: </dt>
                                    <dd><?= date("j/n/y", strtotime($gioco["StartDate"])) ?></dd>
                                </div>
                                <div>
                                    <dt>Fine: </dt>
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
                    <?php if($hasPCPlatform): ?>
                      
                    <p>Requisiti minimi</p>
                    <dl>
                        <div>
                            <dt>OS: </dt>
                            <dd><?= $gioco["Requirements"]["OS"] ?></dd>
                        </div>
                        <div>
                            <dt>RAM: </dt>
                            <dd><?= $gioco["Requirements"]["RAM"] ?> GB</dd>
                        </div>
                        <div>
                            <dt>GPU: </dt>
                            <dd><?= $gioco["Requirements"]["GPU"] ?></dd>
                        </div>
                        <div>
                            <dt>CPU: </dt>
                            <dd><?= $gioco["Requirements"]["CPU"] ?></dd>
                        </div>
                        <div>
                            <dt>Storage: </dt>
                            <dd><?= $gioco["Requirements"]["SSD"] ?> GB</dd>
                        </div>
                    </dl>
                    <?php endif; ?>
                </div>
            <div class = "actions">
                <a href = "game_mod.php?game=<?= $gioco["Id"] ?>">Modifica</a>
                <button class="delete" data-id="<?= $gioco["Id"] ?>">Elimina</button>
            </div>
            </section>
        </li>
    <?php endforeach; ?>
</ul>

<script src="../js/admin-panel.js"></script>