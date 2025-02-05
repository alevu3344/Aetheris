<h1><?= $templateParams["category"] ?></h1>

<nav class="navbar">
    <ul>
        <li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=tendenza">Tendenza</a></li><li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=nuoveuscite">Nuove uscite</a></li><li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=migliori">Migliori</a></li><li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=offerte">Offerte</a></li>
    </ul>
</nav>
<ul>

</ul>

<div>
    <button>Carica più giochi</button>
    <img src="upload/icons/double-arrow.png" alt="arrow"/>
</div>
