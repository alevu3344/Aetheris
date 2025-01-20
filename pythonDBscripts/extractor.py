import os
import random
import yt_dlp as ytdlp
import subprocess
import mysql.connector

config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',  
    'database': 'AetherisDB'
}

trailers = []

# Function to connect to the database and fetch trailers
def fetch_trailers():
    global trailers
    try:
        conn = mysql.connector.connect(**config)
        print("Connessione al database riuscita!")

        cursor = conn.cursor()
        cursor.execute("SELECT Id, Trailer FROM GAMES")  # Fetch trailer URLs
        trailers = cursor.fetchall()

    except mysql.connector.Error as e:
        print(f"Error: {e}")
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()
            print("Connessione chiusa.")

# Function to download video using yt-dlp with cookies
def download_video(url, download_path='downloads'):
    if not os.path.exists(download_path):
        os.makedirs(download_path)
    
    try:
        # Download the video using yt-dlp with cookies
        ydl_opts = {
            'outtmpl': os.path.join(download_path, '%(id)s.%(ext)s'),
            'format': 'best',  # You can adjust the format if needed
            'cookiefile': './cookies.txt'  # Path to the cookies file
        }

        with ytdlp.YoutubeDL(ydl_opts) as ydl:
            result = ydl.download([url])
            if result == 0:
                downloaded_file = os.path.join(download_path, f"{url.split('=')[-1]}.mp4")
                return downloaded_file
            else:
                print(f"Error downloading video from {url}")
                return None

    except Exception as e:
        print(f"Error downloading video from {url}: {e}")
        return None


def extract_random_frames(video_path, game_id, num_frames=4, output_folder="screenshots"):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    # Get video duration
    result = subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 
                             'default=noprint_wrappers=1:nokey=1', video_path], 
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
    # Ensure that duration is correctly extracted
    try:
        duration = float(result.stdout)
    except ValueError:
        print(f"Error: Unable to extract video duration for {video_path}")
        return []
    
    if duration <= 0:
        print(f"Error: Invalid video duration for {video_path}")
        return []

    # Generate random times to capture screenshots
    random_times = sorted([random.uniform(0, duration) for _ in range(num_frames)])
    
    screenshots = []
    for i, time in enumerate(random_times):
        # Ensure time is valid before using it
        if time < 0 or time > duration:
            print(f"Error: Invalid time value {time} for video {video_path}. Skipping frame extraction.")
            continue

        # Use GameId in the screenshot filename
        output_path = os.path.join(output_folder, f"{game_id}_frame_{i+1}.jpg")
        
        # Capture keyframes by forcing I-frames with the select filter
        subprocess.run(['ffmpeg', '-ss', str(time), '-i', video_path, '-vf', 'select=eq(pict_type\,I)', 
                        '-vsync', 'vfr', '-vframes', '1', '-q:v', '1', output_path])
        screenshots.append(output_path)
    
    return screenshots


# Function to delete the video file after processing
def delete_video(video_path):
    if os.path.exists(video_path):
        os.remove(video_path)
        print(f"Deleted video: {video_path}")

# Main function to process trailers
def main():
    fetch_trailers()  # Fetch trailers from the database

    if not trailers:
        print("No trailers found in the database.")
        return

    missing_screenshots =  [200]
    for missing in missing_screenshots:

        try:
            game_id = missing
            print(f"Downloading trailer: {game_id}")
            video_path = download_video(trailers[game_id-1][1])  # Download video for the trailer URL

            if not video_path:
                print(f"Skipping trailer {game_id}")
                continue

            print(f"Video downloaded to: {video_path}")
            screenshots = extract_random_frames(video_path, game_id)  # Extract random screenshots with GameId
            print(f"Random screenshots saved: {', '.join(screenshots)}")

        except Exception as e:
            print(f"Error processing trailer {game_id}: {e}")

        finally:
            if video_path:
                # Delete the downloaded video after screenshots are saved
                delete_video(video_path)

if __name__ == "__main__":
    main()