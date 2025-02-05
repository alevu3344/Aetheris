<h2>Le tue notifiche</h2>

<?php if (!empty($templateParams["notifications"])): ?>
    <ul>
        <?php foreach ($templateParams["notifications"] as $notification): ?>
            <li>
                <div>
                    <p><?= $notification["Message"] ?></p>
                    <div><p><time><?= $notification["SentAt"] ?></time></p><p>Stato: <?= $notification["Status"] ?></p></div>      
                </div>
            </li>
        <?php endforeach; ?>
    </ul>
<?php else: ?>
    <div id="empty-cart">
        <div>
            <img src="upload/icons/empty.png" alt="Empty notification list"/><p>Wow, such empty</p>
        </div>
    </div>
<?php endif; ?>