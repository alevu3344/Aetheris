<ul>
    <?php foreach ($templateParams["giochi"] as $gioco): ?>
        <li class="game" id="<?= $gioco["Id"] ?>">
            <section>
                <div class="images">
                    <button class="modify-images">Modify images</button>
                    <img id="cover" src="../media/covers/<?= $gioco["Id"] ?>.jpg" onerror="this.onerror=null; this.src='../media/noimage.jpg';" />
                    <div class="screenshots">
                        <img src="../media/screenshots/<?= $gioco["Id"] ?>_frame_1.jpg"
                            alt="game"
                            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />

                        <img src="../media/screenshots/<?= $gioco["Id"] ?>_frame_2.jpg"
                            alt="game"
                            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />

                        <img src="../media/screenshots/<?= $gioco["Id"] ?>_frame_3.jpg"
                            alt="game"
                            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />

                        <img src="../media/screenshots/<?= $gioco["Id"] ?>_frame_4.jpg"
                            alt="game"
                            onerror="this.onerror=null; this.src='../media/noimage.jpg';" />
                    </div>
                </div>
                <div>
                    <dl>
                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Title: </dt>
                            </div>
                            <dd id="Name"><?= $gioco["Name"] ?></dd>
                        </div>
                        <hr>
                        </hr>
                        <div class="possible-form" id="categories">
                            <div>
                                <button class="edit-categories">Edit</button>
                                <dt>Genres: </dt>
                            </div>
                            <dd>
                                <?php foreach ($gioco["Categories"] as $categoria): ?>
                                    <span><?= $categoria["CategoryName"] ?></span>
                                <?php endforeach; ?>

                            </dd>
                        </div>
                        <hr>
                        </hr>
                        <div class="possible-form" id="platforms">
                            <div>
                                <button class="edit-platforms">Edit</button>
                                <dt>Platforms: </dt>
                            </div>
                            <dd>
                                <?php foreach ($gioco["Platforms"] as $platform): ?>
                                    <img class="platform-icon" src="upload/icons/<?= $platform["Platform"] ?>.svg" />
                                <?php endforeach; ?>
                            </dd>
                        </div>
                        <hr>
                        </hr>
                        <?php foreach ($gioco["Platforms"] as $platform): ?>
                            <div class="possible-form" id="<?= $platform["Platform"] ?>">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt><?= $platform["Platform"] ?>(stock):</dt>
                                </div>
                                <dd id="<?= $platform["Platform"] ?>" class=<?= $platform["Stock"] > 0 ? "available" : "expired" ?>><?= $platform["Stock"] ?></dd>
                            </div>
                        <?php endforeach; ?>
                        <hr>
                        </hr>
                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Publisher: </dt>
                            </div>
                            <dd id="Publisher"><?= $gioco["Publisher"] ?></dd>
                        </div>
                        <hr>
                        </hr>
                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>TrailerURL: </dt>
                            </div>
                            <dd id="Trailer"><?= $gioco["Trailer"] ?></dd>
                        </div>
                        <hr>
                        </hr>
                        <div class="possible-form">
                            <div>
                                <button class="edit">Edit</button>
                                <dt>Price: </dt>
                            </div>
                            <div>
                                <dd id="Price"><?= $gioco["Price"] ?></dd>
                                <span>€</span>
                            </div>
                        </div>

                        <?php if (!empty($gioco["Discount"])): ?>
                            <hr>
                            </hr>
                            <button class="remove-discount">Rimuovi sconto</button>

                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>Discount: </dt>
                                </div>
                                <div>
                                    <span>-</span>
                                    <dd id="Discount"><?= $gioco["Discount"] ?></dd>
                                    <span>%</span>
                                </div>
                            </div>
                            <hr>
                            </hr>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>Start: </dt>
                                </div>
                                <dd id="StartDate"><?= date("j/n/y", strtotime($gioco["StartDate"])) ?></dd>
                            </div>
                            <hr>
                            </hr>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>End: </dt>
                                </div>
                                <dd id="EndDate"><?= date("j/n/y", strtotime($gioco["EndDate"])) ?></dd>
                            </div>
                        <?php else: ?>
                            <hr>
                            </hr>

                            <button class="add">Add a discount</button>

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

                        <p>Minimum requirements</p>
                        <dl>
                            <hr>
                            </hr>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>OS: </dt>
                                </div>
                                <dd id="OS"><?= $gioco["Requirements"]["OS"] ?></dd>
                            </div>
                            <hr>
                            </hr>
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
                            <hr>
                            </hr>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>GPU: </dt>
                                </div>
                                <dd id="GPU"><?= $gioco["Requirements"]["GPU"] ?></dd>
                            </div>
                            <hr>
                            </hr>
                            <div class="possible-form">
                                <div>
                                    <button class="edit">Edit</button>
                                    <dt>CPU: </dt>
                                </div>
                                <dd id="CPU"><?= $gioco["Requirements"]["CPU"] ?></dd>
                            </div>
                            <hr>
                            </hr>
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

                    <button class="delete" data-id="<?= $gioco["Id"] ?>">Delete</button>

                </div>
            </section>
        </li>
    <?php endforeach; ?>
</ul>