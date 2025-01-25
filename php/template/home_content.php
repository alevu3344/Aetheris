<div>
  <button>
    <img src="upload/icons/left_arrow.svg" alt="Left arrow">
  </button>

  <div></div>

  <button>
    <img src="upload/icons/right_arrow.svg" alt="Right arrow">
  </button>
</div>

<h2>GIOCHI IN OFFERTA</h2>
<div>
  <a href = "game.php?id=<?= $templateParams["giochi-in-offerta"][0]["Id"]?>">
  <article> <!-- Gioco grande (sinistra)-->
        <figure>
          <img src="../media/covers/<?= $templateParams["giochi-in-offerta"][0]["Id"]?>.jpg" alt="Big Game">
          <figcaption><?= $templateParams["giochi-in-offerta"][0]["Name"]?></figcaption>
        </figure>

        <section>
          <p>OFFERTA A TEMPO LIMITATO</p>
          <p>Fino al <?= date("d/m", strtotime($templateParams["giochi-in-offerta"][0]["EndDate"])) ?>!</p>

          <footer>
          <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
          <?php if (!empty($templateParams["giochi-in-offerta"][0]['Discount'])): ?>
                            <span>-<?= $templateParams["giochi-in-offerta"][0]['Discount']?>%</span>
                            <?php endif; ?>
                            <span><?= $templateParams["giochi-in-offerta"][0]['Price'] ?>€</span>
                            <?php if (!empty($templateParams["giochi-in-offerta"][0]['Discount'])): ?>
                            <span><?= number_format($templateParams["giochi-in-offerta"][0]['Price'] * (1 - $templateParams["giochi-in-offerta"][0]['Discount'] / 100), 2)?>€</span>
                        <?php endif; ?>
          </footer>
        </section>
      </article>
    </a>

  <div> <!-- Giochi piccoli (destra)-->
  <a href = "game.php?id=<?= $templateParams["giochi-in-offerta"][1]["Id"]?>">
    <article>
        <figure>
          <img src="../media/covers/<?= $templateParams["giochi-in-offerta"][1]["Id"]?>.jpg" alt="Top game"/>
          <figcaption><?= $templateParams["giochi-in-offerta"][1]["Name"]?></figcaption>
        </figure>
          <footer>
            <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
            <?php if (!empty($templateParams["giochi-in-offerta"][1]['Discount'])): ?>
                            <span>-<?= $templateParams["giochi-in-offerta"][1]['Discount']?>%</span>
                            <?php endif; ?>
                            <span><?= $templateParams["giochi-in-offerta"][1]['Price'] ?>€</span>
                            <?php if (!empty($templateParams["giochi-in-offerta"][1]['Discount'])): ?>
                            <span><?= number_format($templateParams["giochi-in-offerta"][1]['Price'] * (1 - $templateParams["giochi-in-offerta"][1]['Discount'] / 100), 2)?>€</span>
                        <?php endif; ?>
          </footer>
      </article>
    </a>
    <a href = "game.php?id=<?= $templateParams["giochi-in-offerta"][2]["Id"]?>">
      <article>
        <figure>
          <img src="../media/covers/<?= $templateParams["giochi-in-offerta"][2]["Id"]?>.jpg" alt="Bottom game"/>
          <figcaption><?= $templateParams["giochi-in-offerta"][2]["Name"]?></figcaption>
        </figure>
          <footer>
            <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
            <?php if (!empty($templateParams["giochi-in-offerta"][2]['Discount'])): ?>
                            <span>-<?= $templateParams["giochi-in-offerta"][2]['Discount']?>%</span>
                            <?php endif; ?>
                            <span><?= $templateParams["giochi-in-offerta"][2]['Price'] ?>€</span>
                            <?php if (!empty($templateParams["giochi-in-offerta"][2]['Discount'])): ?>
                            <span><?= number_format($templateParams["giochi-in-offerta"][2]['Price'] * (1 - $templateParams["giochi-in-offerta"][2]['Discount'] / 100), 2)?>€</span>
                        <?php endif; ?>
          </footer>
      </article>
    </a>
  </div>
</div>

  <nav>
      <ul>
          <li><h2>PIÙ ACQUISTATI</h2></li><li><h2>PIÙ AMATI</h2></li>
      </ul>
  </nav>

<div>
  <div>
    <ul>
        <?php foreach($templateParams["giochi-acquistati"] as $mostsoldgames): ?>
        <li>
          <a href = "game.php?id=<?= $mostsoldgames["Id"]?>">
            <img src="<?= "../media/covers/".$mostsoldgames["Id"].".jpg" ?>" alt="<?= $mostsoldgames["Name"]; ?>" />
            <section>
              <header>
                <span><?= $mostsoldgames["Name"]; ?></span>
              </header>
              <footer>
                <div>
                  <?php foreach($mostsoldgames["Platforms"] as $platform): ?>
                    <img src="<?= "upload/icons/".$platform["Platform"].".svg" ?>" alt="<?= $platform["Platform"]; ?>" />
                
                
                  <?php endforeach; ?>
                </div>
                <span><?= number_format($mostsoldgames['Price'] * (1 - $mostsoldgames['Discount'] / 100), 2)?>€</span>
              </footer>
            </section>
          </a>
        </li>
        <?php endforeach; ?>
      </ul>
    </div>

  <div></div>

  <div>
    <ul>
      <?php foreach($templateParams["giochi-amati"] as $mostratedgame): ?>
      <li>
        <a href = "game.php?id=<?= $mostratedgame["Id"]?>">
          <img src="<?= "../media/covers/".$mostratedgame["Id"].".jpg" ?>" alt="<?= $mostratedgame["Name"]; ?>" />
          <section>
            <header>
              <span><?= $mostratedgame["Name"]; ?></span>
            </header>
            <footer>
              <div>
                <?php foreach($mostratedgame["Platforms"] as $platform): ?>
                  <img src="<?= "upload/icons/".$platform["Platform"].".svg" ?>" alt="<?= $platform["Platform"]; ?>" />
              
              
                <?php endforeach; ?>
              </div>
              <span><?= number_format($mostratedgame['Price'] * (1 - $mostratedgame['Discount'] / 100), 2)?>€</span>
            </footer>
          </section>
        </a>
      </li>
      <?php endforeach; ?>
    </ul>
  </div>
</div>


<div id = "home-offers">
  <section>
    <h2>OFFERTE DI LANCIO</h2>
    <p>FESTEGGIA IL LANCIO DI AETHERIS CON OFFERTE IMPERDIBILI</p>
  </section>
  <div>
    <img src="upload/icons/left_arrow.svg" alt="Left arrow">
    <nav>
      <ul>
        
      </ul>
    </nav>
    <img src="upload/icons/left_arrow.svg" alt="Right arrow">
  </div>

</div>

<script src="../js/front-page-game.js" defer="true"></script> 
<script src="../js/most-sold-loved-games.js" defer="true"></script> 
<script src="../js/launch-offers.js" defer="true"></script> 
