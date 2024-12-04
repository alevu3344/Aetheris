<section>
    <h2>Autori del Blog</h2>
        <table>
        
            <tr>
                <th id="">Autore</th><th id="email">Email</th><th id="argomenti">Argomenti</th>
            </tr>
            <?php foreach($templateParams["autori"] as $autore): ?>
                <tr>
                    <th id="<?php getIdFromName($autore["nome"])?>"><?php echo $autore["nome"]?></th><td headers="email <?php echo $autore["nome"] ?>"><?php echo $autore["username"] ?></td><td headers="argomenti <?php echo $autore["nome"] ?>"><?php echo $autore["argomenti"] ?></td>
                </tr>
            <?php endforeach; ?>
        </table>
</section>