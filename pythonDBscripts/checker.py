import os

def check_screenshots(directory="screenshots", num_screenshots=4, max_game_id=292):
    # Dictionario per tenere traccia degli ID dei giochi e del numero di screenshot per ciascuno
    games_screenshot_count = {game_id: 0 for game_id in range(1, max_game_id + 1)}

    # Percorsi per tutti i file nella cartella screenshots
    for filename in os.listdir(directory):
        # Controlla se il file è uno screenshot e se è un file JPG (o altro formato che hai utilizzato)
        if filename.endswith(".jpg"):
            try:
                # Estrai l'ID del gioco dalla parte iniziale del nome del file, es. "1_frame_1.jpg"
                game_id = int(filename.split("_")[0])

                if 1 <= game_id <= max_game_id:
                    # Incrementa il contatore per il gioco corrispondente
                    games_screenshot_count[game_id] += 1
            except ValueError:
                # Se non riesce a ottenere un ID valido, ignora il file
                continue

    # Controlla se ogni gioco ha esattamente 4 screenshot
    missing_screenshots = []
    extra_screenshots = []

    for game_id, count in games_screenshot_count.items():
        if count < num_screenshots:
            missing_screenshots.append(game_id)
        elif count > num_screenshots:
            extra_screenshots.append(game_id)

    # Report dei giochi che non rispettano la condizione
    if missing_screenshots:
        print(f"Giochi con meno di {num_screenshots} screenshot: {missing_screenshots}")
    else:
        print(f"Tutti i giochi hanno almeno {num_screenshots} screenshot.")

    if extra_screenshots:
        print(f"Giochi con più di {num_screenshots} screenshot: {extra_screenshots}")
    else:
        print(f"Tutti i giochi hanno al massimo {num_screenshots} screenshot.")

# Esegui la funzione di controllo
check_screenshots()
