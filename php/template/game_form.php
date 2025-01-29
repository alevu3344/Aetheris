<section>
    <form action="addGame.php" method="POST" enctype="multipart/form-data">
        <fieldset>
            <legend>Game details</legend>
            <!-- Game Name -->
            <div>
                <label for="gameName">Game Name:</label>
                <input type="text" id="gameName" name="GameName" required>
            </div>
            <!-- Game Description -->
            <div>
                <label for="gameDescription">Game Description:</label>
                <textarea id="gameDescription" name="GameDescription" rows="4" required></textarea>
            </div>

            <div>
                <label>Game Categories:</label>
                <?php foreach ($templateParams["categorie"] as $category) : ?>


                    <input type="checkbox" id="category<?= $category["CategoryName"]; ?>" name="categories[]" value="<?= $category["CategoryName"]; ?>">

                <?php endforeach; ?>
            </div>

            <!-- Game Price -->
            <div>
                <label for="gamePrice">Game Price (€):</label>
                <input type="number" id="gamePrice" name="GamePrice" step="0.01" required>
            </div>

            <!-- Game Publisher -->
            <div>
                <label for="gamePublisher">Game Publisher:</label>
                <input type="text" id="gamePublisher" name="GamePublisher" required>
            </div>

            <!-- Game Release Date -->
            <div>
                <label for="gameReleaseDate">Game Release Date:</label>
                <input type="date" id="gameReleaseDate" name="GameReleaseDate" required>
            </div>

            <!-- Game Trailer -->
            <div>
                <label for="gameTrailer">Game Trailer (URL):</label>
                <input type="url" id="gameTrailer" name="GameTrailer" required>
            </div>

            <!-- Game Cover Image -->
            <div>
                <label for="gameCover">Game Cover Image:</label>
                <input type="file" id="gameCover" name="image" accept=".jpg,.jpeg,.png,.gif" required>
            </div>

            <!-- Submit Button -->
            <button type="submit">Add Game</button>
        </fieldset>
    </form>
</section>