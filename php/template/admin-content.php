<ul>
    <?php foreach($templateParams["giochi"] as $gioco): ?>
    <li>
        <section>
            <img src="../media/covers/<?=$gioco["Id"]?>.jpg"/>
            <div>
                <dl>
                    <div>
                        <dt>Titolo: </dt>
                        <dd><?= $gioco["Name"]?></dd>
                    </div>
                    <div id="categories">
                        <dt>Generi: </dt>
                        <dd>
                            <?php foreach($gioco["Categories"] as $categoria): ?>              
                                <span><?=$categoria["CategoryName"]?></span>
                            <?php endforeach; ?>
                    
                        </dd>
                    </div>
                    <div>
                        <dt>Piattaforme: </dt>
                        <dd>
                            <?php foreach($gioco["Platforms"] as $platform): ?>
                                <img src="upload/icons/<?= $platform["Platform"]?>.svg"/>
                            <?php endforeach; ?>
                        </dd>
                    </div>
                    <div>
                        <dt>Sviluppatore: </dt>
                        <dd><?= $gioco["Publisher"]?></dd>
                    </div>
                    <dl>
                        <div>
                            <dt>Sconto: </dt>
                            <dd>-40%</dd>
                        </div>
                        <div>
                            <dt>Inizio: </dt>
                            <dd>01/01/2021</dd>
                        </div>
                        <div>
                            <dt>Fine: </dt>
                            <dd>01/01/2022</dd>
                        </div>
                    </dl>
                </dl>
            </div>
        </section>
    </li>
    <?php endforeach; ?>
</ul>