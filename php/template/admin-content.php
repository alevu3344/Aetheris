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
                    <?php if(!empty($gioco["Discount"])): ?>
                    <dl>
                        <div>
                            <dt>Sconto: </dt>
                            <dd>-<?= $gioco["Discount"]?>%</dd>
                        </div>
                        <div>
                            <dt>Inizio: </dt>
                            <dd><?= date("j/n/y", strtotime($gioco["StartDate"]))?></dd>
                        </div>
                        <div>
                            <dt>Fine: </dt>
                            <dd><?= date("j/n/y", strtotime($gioco["EndDate"]))?></dd>
                        </div>
                    </dl>
                    <?php endif; ?>
                </dl>
            </div>
        </section>
    </li>
    <?php endforeach; ?>
</ul>