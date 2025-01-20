<div>
  <button>
    <img src="upload/icons/left_arrow.svg" alt="Left arrow">
  </button>

  <article>
    <figure>
      <div></div>
      <img src="../media/covers/legend_of_zelda_todk.jpg" alt="Front page game">
      <figcaption>
        <p>The Legend of Zelda: Breath of the Wild</p>
        <p>Impedisci a Ganondorf di distruggere Hyrule</p>
      </figcaption>

      <div>
        <div>
          <span>59.99€</span>
          <button>Acquista</button>
        </div>
        <button>
          <img src="upload/icons/add-to-cart.svg" alt="Add to cart icon"/>Aggiungi al carrello
        </button>
      </div>
    </figure>
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
          <li>PIÙ ACQUISTATI</li><li>PIÙ AMATI</li>
      </ul>
  </nav>

<div>
  <div>
    <ul>
      <li>
        <div>
          <img src="../media/covers/144.jpg" alt="The Evil Within 2">
          <section>
            <header>
              <span>The Evil Within 2</span>
            </header>
            <footer>
              <div>
                <img src="upload/icons/windows-icon.svg" alt="Windows">
                <img src="upload/icons/xbox-icon.svg" alt="Xbox">
                <img src="upload/icons/mac-icon.svg" alt="Mac">
              </div>
              <span>39,99€</span>
            </footer>
          </section>
        </div>
      </li>
      <li>
      <div>
        <img src="../media/covers/108.jpg" alt="Limbo">
          <section>
            <header>
              <span>Limbo</span>
            </header>
            <footer>
              <div>
                <img src="upload/icons/windows-icon.svg" alt="Windows">
                <img src="upload/icons/xbox-icon.svg" alt="Xbox">
                <img src="upload/icons/mac-icon.svg" alt="Mac">
              </div>
              <span>9,99€</span>
            </footer>
          </section>
        </div>
      </li>
      <li>
      <div>
        <img src="../media/covers/98.jpg" alt="Cuphead">
          <section>
            <header>
              <span>Cuphead</span>
            </header>
            <footer>
              <div>
                <img src="upload/icons/windows-icon.svg" alt="Windows">
                <img src="upload/icons/xbox-icon.svg" alt="Xbox">
                <img src="upload/icons/mac-icon.svg" alt="Mac">
              </div>
              <span>19,99€</span>
            </footer>
          </section>
        </div>
      </li>
      <li>
      <div>
        <img src="../media/covers/66.jpg" alt="Grim Dawn">
          <section>
            <header>
              <span>Grim Dawn</span>
            </header>
            <footer>
              <div>
                <img src="upload/icons/windows-icon.svg" alt="Windows">
                <img src="upload/icons/xbox-icon.svg" alt="Xbox">
                <img src="upload/icons/mac-icon.svg" alt="Mac">
              </div>
              <span>19,99€</span>
            </footer>
          </section>
        </div>
      </li>
      <li>
      <div>
        <img src="../media/covers/74.jpg" alt="Cities Skylines">
          <section>
            <header>
              <span>Cities Skylines</span>
            </header>
            <footer>
              <div>
                <img src="upload/icons/windows-icon.svg" alt="Windows">
                <img src="upload/icons/xbox-icon.svg" alt="Xbox">
                <img src="upload/icons/mac-icon.svg" alt="Mac">
              </div>
              <span>19,99€</span>
            </footer>
          </section>
        </div>
      </li>
    </ul>
  </div>

  <div></div>

  <div>
    <ul>
      <?php foreach($templateParams["giochi-amati"] as $mostratedgame): ?>
      <li>
        <div>
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
        </div>
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

