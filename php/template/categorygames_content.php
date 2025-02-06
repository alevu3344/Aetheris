<h1><?= $templateParams["category"] ?></h1>

<nav class="navbar">
    <ul>
        <li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=tendenza">Hot</a></li><li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=nuoveuscite">New releases</a></li><li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=migliori">Best</a></li><li><a href="categorygames.php?category=<?= $templateParams["category"]?>&action=offerte">On sale</a></li>
    </ul>
</nav>
<ul>

</ul>

<div>
    <button>Load more games</button>
    <img src="upload/icons/double-arrow.png" alt="arrow"/>
</div>
