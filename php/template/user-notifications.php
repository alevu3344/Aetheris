<h2>Your notifications</h2>

<?php if (!empty($templateParams["notifications"])): ?>
    <ul>
        <?php foreach ($templateParams["notifications"] as $notification): ?>
            <li class="<?= $notification["Type"] ?>" id="<?= $notification["Status"] ?>">
                <div>
                    <?php if ($notification["Type"] == "order_status_changed"): ?>
                        <?php
                        $message = $notification["Message"];
                        $words = explode(" ", $message);

                        $lastWord = array_pop($words);
                        $firstPart = implode(" ", $words);


                        // Supponiamo che $message sia "Ordine confermato #12345"
                        preg_match('/#(\d+)/', $message, $matches);
                        $orderId = $matches[1] ?? null; // Prende il numero, se esiste


                        ?>
                        <div class="<?= $notification["Type"] ?>">
                            <p><?= $firstPart ?></p><span id="<?= $lastWord ?>"><?= $lastWord ?></span>
                        </div>
                    <?php else: ?>
                        <p class="<?= $notification["Type"] ?>"><?= $notification["Message"] ?></p>
                    <?php endif; ?>

                    <div>
                        <p><time><?= (new DateTime($notification["SentAt"]))->format('j/n/y H:i'); ?></time></p><div><?php if ($notification["Type"] == "order_status_changed"): ?><a href="orders.php?orderId=<?=$orderId ?>">View Order</a><?php endif; ?><?php if ($notification["Status"] != "Read"): ?><button id="<?= $notification["Id"] ?>">Mark as read</button><?php endif; ?></div>
                    </div>
                </div>
            </li>
        <?php endforeach; ?>
    </ul>
<?php else: ?>
    <div id="empty-cart">
        <div>
            <img src="upload/icons/empty.png" alt="Empty notification list" />
            <p>Wow, such empty</p>
        </div>
    </div>
<?php endif; ?>