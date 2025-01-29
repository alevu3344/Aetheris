<section>
    <form action="addGame.php" method="POST" enctype="multipart/form-data">
        <fieldset>
            <legend>Game details</legend>
            <!-- Game Name -->

            <label for="gameName">Game Name:
                <input type="text" id="gameName" name="GameName" required>
            </label>

            <!-- Game Description -->

            <label for="gameDescription">Game Description:
                <textarea id="gameDescription" name="GameDescription" rows="4" required></textarea>
            </label>

            <!-- Game Publisher -->

            <label for="gamePublisher">Game Publisher:
                <input type="text" id="gamePublisher" name="GamePublisher" required>
            </label>




            <fieldset>
                <legend>Select the categories</legend>
                <div class="categories">
                    <?php foreach ($templateParams["categorie"] as $category) : ?>
                        <input type="checkbox" id="category<?= $category["CategoryName"]; ?>" name="categories[]" value="<?= $category["CategoryName"]; ?>" />
                        <label for="category<?= $category["CategoryName"]; ?>" class="category-button">
                            <?= $category["CategoryName"]; ?>
                        </label>
                    <?php endforeach; ?>
                </div>
            </fieldset>


            <!-- Game Price -->
            <div>
                <label for="gamePrice">Game Price (€):
                    <input type="number" id="gamePrice" name="GamePrice" step="0.01" required>
                </label>

                <label for="gameReleaseDate">Game Release Date:
                    <input type="date" id="gameReleaseDate" name="GameReleaseDate" required>
                </label>
            </div>






            <label for="gameTrailer">Game Trailer (URL):
                <input type="url" id="gameTrailer" name="GameTrailer" required>
            </label>



            <label for="gameCover">Game Cover Image:
                <input type="file" id="gameCover" name="image" accept=".jpg,.jpeg,.png,.gif" required>
            </label>

            <!-- Screenshots -->
            <div class="screenshots">
                <label for="screenshot1">Screenshot 1:
                    <input type="file" id="screenshot1" name="screenshots[]" accept=".jpg,.jpeg,.png,.gif" required>
                </label>

                <label for="screenshot2">Screenshot 2:
                    <input type="file" id="screenshot2" name="screenshots[]" accept=".jpg,.jpeg,.png,.gif" required>
                </label>

                <label for="screenshot3">Screenshot 3:
                    <input type="file" id="screenshot3" name="screenshots[]" accept=".jpg,.jpeg,.png,.gif" required>
                </label>

                <label for="screenshot4">Screenshot 4:
                    <input type="file" id="screenshot4" name="screenshots[]" accept=".jpg,.jpeg,.png,.gif" required>
                </label>
            </div>




            <!-- Submit Button -->
            <button type="submit">Add Game</button>
            <button>Cancel</button>
        </fieldset>
    </form>
</section>