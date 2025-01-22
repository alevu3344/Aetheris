<div>
  <button>
    <img src="upload/icons/left_arrow.svg" alt="Left arrow">
  </button>

  <article>

  </article>

  <button>
    <img src="upload/icons/right_arrow.svg" alt="Right arrow">
  </button>
</div>



<h2>GIOCHI IN OFFERTA</h2>
<div>
  <article> <!-- Gioco grande (sinistra)-->
        <figure>
          <img src="../media/covers/5.jpg" alt="Big Game">
          <figcaption>Assassin's Creed Valhalla</figcaption>
        </figure>

        <section>
          <p>OFFERTA A TEMPO LIMITATO</p>
          <p>Fino al 30 novembre!</p>

          <footer>
            <span>-50%</span>
            <span>29,99€</span>
            <span>14,99€</span>
          </footer>
        </section>
      </article>

  <div> <!-- Giochi piccoli (destra)-->
    <article>
        <figure>
          <img src="../media/covers/23.jpg" alt="Top game"/>
          <figcaption>Cyberpunk 2077</figcaption>
        </figure>
          <footer>
            <span>-50%</span>
            <span>29,99€</span>
            <span>14,99€</span>
          </footer>
      </article>

      <article>
        <figure>
          <img src="../media/covers/44.jpg" alt="Bottom game"/>
          <figcaption>Dead Cells</figcaption>
        </figure>
          <footer>
            <span>-50%</span>
            <span>29,99€</span>
            <span>14,99€</span>
          </footer>
      </article>

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
        <img src="<?php echo "../media/covers/".$mostsoldgames["Id"].".jpg" ?>" alt="<?php echo $mostsoldgames["Name"]; ?>" />
            <section>
              <header>
                <span><?php echo $mostsoldgames["Name"]; ?></span>
              </header>
              <footer>
                <div>
                  <?php foreach($mostsoldgames["Platforms"] as $platform): ?>
                    <img src="<?php echo "upload/icons/".$platform["Platform"].".svg" ?>" alt="<?php echo $platform["Platform"]; ?>" />
                
                
                  <?php endforeach; ?>
                </div>
                <span><?= number_format($mostsoldgames['Price'] * (1 - $mostsoldgames['Discount'] / 100), 2)?>€</span>
              </footer>
            </section>
        </li>
      <?php endforeach; ?>
    </ul>
  </div>

  <div></div>

  <div>
    <ul>
      <?php foreach($templateParams["giochi-amati"] as $mostratedgame): ?>
      <li>
          <img src="<?php echo "../media/covers/".$mostratedgame["Id"].".jpg" ?>" alt="<?php echo $mostratedgame["Name"]; ?>" />
          <section>
            <header>
              <span><?php echo $mostratedgame["Name"]; ?></span>
            </header>
            <footer>
              <div>
                <?php foreach($mostratedgame["Platforms"] as $platform): ?>
                  <img src="<?php echo "upload/icons/".$platform["Platform"].".svg" ?>" alt="<?php echo $platform["Platform"]; ?>" />
              
              
                <?php endforeach; ?>
              </div>
              <span><?= number_format($mostratedgame['Price'] * (1 - $mostratedgame['Discount'] / 100), 2)?>€</span>
            </footer>
          </section>
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
        <?php foreach ($templateParams["offerte-di-lancio"] as $game): ?>
          <li>
              <article>
                  <figure>

                      <img src= <?= "../media/covers/".$game['Id'].".jpg" ?>
                          alt="<?= $game["Name"] ?>"/>
                      <figcaption><?= $game["Name"] ?></figcaption>
                  </figure>
                  <footer>
                      <!-- Use 'discount', 'price', and 'discounted_price' keys dynamically -->
                      <?php if (!empty($game['Discount'])): ?>
                          <span>-<? echo $game['Discount']?>%</span>
                          <?php endif; ?>
                          <span><?= $game['Price'] ?>€</span>
                          <?php if (!empty($game['Discount'])): ?>
                          <span><?= number_format($game['Price'] * (1 - $game['Discount'] / 100), 2)?>€</span>
                      <?php endif; ?>
                  </footer>
              </article>
          </li>
      <?php endforeach; ?>
      </ul>
    </nav>
    <img src="upload/icons/left_arrow.svg" alt="Right arrow">
  </div>

</div>

<script src="../js/front-page-game.js" type="text/javascript"></script> 
<script src="../js/most-sold-loved-games.js" type="text/javascript"></script> 