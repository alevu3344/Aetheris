<section>
    <form id="add-game-form" method="POST" enctype="multipart/form-data">
        <fieldset>
            <legend>Game details</legend>

            <?php $game = isset($templateParams["gioco"]) ? $templateParams["gioco"] : null; ?>

            <!-- Game Name -->
            <label for="gameName">Game Name:
                <input type="text" id="gameName" name="GameName" value="<?= $game ? htmlspecialchars($game['Name']) : '' ?>" required>
            </label>

            <!-- Game Description -->
            <label for="gameDescription">Game Description:
                <textarea id="gameDescription" name="GameDescription" rows="4" required><?= $game ? htmlspecialchars($game['Description']) : '' ?></textarea>
            </label>

            <!-- Game Publisher -->
            <label for="gamePublisher">Game Publisher:
                <select id="gamePublisher" name="GamePublisher" required>
                    <option value="" disabled <?= !$game ? 'selected' : '' ?>>Select a publisher</option>
                    <?php foreach ($templateParams["publishers"] as $publisher) : ?>
                        <option value="<?= $publisher["PublisherName"]; ?>"
                            <?= ($game && $game['Publisher'] == $publisher["PublisherName"]) ? 'selected' : '' ?>>
                            <?= $publisher["PublisherName"]; ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </label>

            <?php
            $gameCategories = isset($game) ? array_column($game['Categories'], 'CategoryName') : [];
            ?>
            <fieldset>
                <legend>Select the categories</legend>
                <div class="categories">
                    <?php foreach ($templateParams["categorie"] as $category) :
                        $isChecked = in_array($category["CategoryName"], $gameCategories);
                    ?>
                        <input type="checkbox" id="category<?= htmlspecialchars($category["CategoryName"]); ?>"
                            name="categories[]"
                            value="<?= htmlspecialchars($category["CategoryName"]); ?>"
                            <?= $isChecked ? 'checked' : '' ?> />
                        <label for="category<?= htmlspecialchars($category["CategoryName"]); ?>" class="category-button">
                            <?= htmlspecialchars($category["CategoryName"]); ?>
                        </label>
                    <?php endforeach; ?>
                </div>
            </fieldset>


            <?php
            // Convert the list of associative arrays into a usable associative array
            $gamePlatforms = [];
            if (isset($game['Platforms'])) {
                foreach ($game['Platforms'] as $entry) {
                    $gamePlatforms[$entry['Platform']] = $entry['Stock'];
                }
            }
            ?>
            <fieldset id="platforms-fieldset">
                <legend>Select the quantities for each platform</legend>
                <div class="platforms">
                    <?php foreach ($templateParams["piattaforme"] as $platform) :
                        $isChecked = array_key_exists($platform, $gamePlatforms); // Check if the platform exists
                        $quantity = $isChecked ? intval($gamePlatforms[$platform]) : 0;
                    ?>
                        <label for="checkbox-<?= htmlspecialchars($platform) ?>" class="platform-button">
                            <input type="checkbox" id="checkbox-<?= htmlspecialchars($platform) ?>" class="platform-checkbox"
                                name="platforms[]" value="<?= htmlspecialchars($platform) ?>" <?= $isChecked ? 'checked' : '' ?> />
                            <img src="upload/icons/<?= htmlspecialchars($platform) ?>.svg" alt="<?= htmlspecialchars($platform) ?>" class="platform-svg" />
                            <input type="number" id="quantity-<?= htmlspecialchars($platform) ?>"
                                name="quantity[<?= htmlspecialchars($platform) ?>]" min="0"
                                value="<?= !$isChecked ? '' : $quantity ?>" <?= !$isChecked ? 'disabled' : '' ?> />
                        </label>
                    <?php endforeach; ?>
                </div>
            </fieldset>


            <?php if (isset($gamePlatforms["PC"])): 
                $pcRequirements =$game["Requirements"];
                ?>
                <fieldset id="pc-requirements">
                    <legend>Minimum System Requirements</legend>

                    <label for="min-os"> Operating System:
                        <input type="text" id="min-os" name="pc_requirements[OS]"
                            value="<?= htmlspecialchars($pcRequirements["OS"]) ?>" />
                    </label>

                    <label for="min-ram">RAM (GB):
                        <input type="number" id="min-ram" name="pc_requirements[RAM]" min="1"
                            value="<?= htmlspecialchars($pcRequirements["RAM"]) ?>" />
                    </label>

                    <label for="min-gpu">GPU:
                        <input type="text" id="min-gpu" name="pc_requirements[GPU]"
                            value="<?= htmlspecialchars($pcRequirements["GPU"]) ?>" />
                    </label>

                    <label for="min-cpu">CPU:
                        <input type="text" id="min-cpu" name="pc_requirements[CPU]"
                            value="<?= htmlspecialchars($pcRequirements["CPU"]) ?>" />
                    </label>

                    <label for="min-ssd">SSD (GB):
                        <input type="number" id="min-ssd" name="pc_requirements[SSD]" min="1"
                            value="<?= htmlspecialchars($pcRequirements["SSD"]) ?>" />
                    </label>
                </fieldset>
            <?php endif; ?>
            <!-- Game Price & Release Date -->
            <div>
                <label for="gamePrice">Game Price (€):
                    <input type="number" id="gamePrice" name="GamePrice" step="0.01"
                        value="<?= $game ? $game['Price'] : '' ?>" required>
                </label>

                <label for="gameReleaseDate">Game Release Date:
                    <input type="date" id="gameReleaseDate" name="GameReleaseDate"
                        value="<?= $game ? $game['ReleaseDate'] : '' ?>" required>
                </label>
            </div>

            <!-- Game Trailer -->
            <label for="gameTrailer">Game Trailer (URL):
                <input type="url" id="gameTrailer" name="GameTrailer"
                    value="<?= $game ? $game['Trailer'] : '' ?>" required>
            </label>

            <?php if ($game): ?>

                <img src="../media/covers/<?= $game['Id'] ?>.jpg" alt="Game Cover Image" />

                <div class="screenshots">
                    <img src="../media/screenshots/<?= $game['Id'] ?>_frame_1.jpg" alt="Screenshot 1" />
                    <img src="../media/screenshots/<?= $game['Id'] ?>_frame_2.jpg" alt="Screenshot 2" />
                    <img src="../media/screenshots/<?= $game['Id'] ?>_frame_3.jpg" alt="Screenshot 3" />
                    <img src="../media/screenshots/<?= $game['Id'] ?>_frame_4.jpg" alt="Screenshot 4" />
                </div>


            <?php else: ?>

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

            <?php endif; ?>




            <!-- Submit Button -->
            <button id="submit" type="submit">Add Game</button>
            <button type="button">Cancel</button>
        </fieldset>
    </form>
</section>

<script src="../js/newgame.js"></script>