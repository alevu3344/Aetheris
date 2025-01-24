<ul>
    <?php foreach($templateParams["giochi"] as $gioco): ?>
    <li>
        <section>
            <img src="../media/covers/<?=$gioco["Id"]?>.jpg"/>
            <div>
                <dl>
                    <dt>Titolo: </dt>
                    <dd><?= $gioco["Name"]?></dd>
                    <dt>Generi</dt>
                    <dd>
                        <?php foreach($gioco["Categories"] as $categoria): ?>              
                            <span><?=$categoria["CategoryName"]?></span>
                        <?php endforeach; ?>
                 
                    </dd>
                    <dt>Piattaforme</dt>
                    <dd>
                        <?php foreach($gioco["Platforms"] as $platform): ?>
                            <img src="upload/icons/<?= $platform["Platform"]?>.svg"/>
                        <?php endforeach; ?>
                    </dd>
                    <dt>Sviluppatore</dt>
                    <dd><?= $gioco["Publisher"]?></dd>
                    <dl>
                        <dt>Sconto</dt>
                        <dd>-40%</dd>
                        <dt>Inizio</dt>
                        <dd>01/01/2021</dd>
                        <dt>Fine</dt>
                        <dd>01/01/2022</dd>
                    </dl>
                </dl>
            </div>
        </section>
    </li>
    <?php endforeach; ?>
</ul>