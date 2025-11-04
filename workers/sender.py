import os
import json
import random
import asyncio
from telegram import Bot
from dotenv import load_dotenv

# --- Load Environment Variables ---
load_dotenv()
TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")

# --- Paths ---
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CHATS_JSON = os.path.join(BASE_DIR, "data", "chats.json")
VIDEO_FOLDER = os.path.join(BASE_DIR, "assets", "videos")

# --- Functions ---
def load_private_chats():
    """Read the JSON file and return a list of active chat IDs from 'private'."""
    try:
        with open(CHATS_JSON, "r", encoding="utf-8") as f:
            data = json.load(f)
        private_chats = data.get("private", {}).get("chats", [])
        active_chats = [chat["id"] for chat in private_chats if chat.get("active") is True]
        return active_chats
    except FileNotFoundError:
        print(f"File not found: {CHATS_JSON}")
        return []
    except json.JSONDecodeError as e:
        print(f"Error reading JSON: {e}")
        return []

async def send_random_video(chat_id, bot):
    """Send a random video to the specified chat."""
    if not os.path.exists(VIDEO_FOLDER):
        print("Folder not found:", VIDEO_FOLDER)
        return

    videos = [f for f in os.listdir(VIDEO_FOLDER)
              if f.lower().endswith(('.mp4', '.mov', '.avi'))]
    if not videos:
        print("No videos found to send.")
        return

    video_name = random.choice(videos)
    video_path = os.path.join(VIDEO_FOLDER, video_name)

    print(f"Sending {video_name} → chat {chat_id}")
    try:
        with open(video_path, "rb") as video_file:
            await bot.send_video(chat_id=chat_id, video=video_file)
        print(f"Successfully sent to {chat_id}")
    except Exception as e:
        print(f"Error sending to {chat_id}: {e}")


#--- Main Execution ---
async def main():
    if not TOKEN:
        print("Missing TELEGRAM_BOT_TOKEN in .env")
        return

    bot = Bot(token=TOKEN)
    active_chat_ids = load_private_chats()

    if not active_chat_ids:
        print("No active chats found to send.")
        return

    print(f"Active chats loaded: {active_chat_ids}")
    
    # send videos in a loop
    for i in range(5):
        print(f"--- Sending Video {i+1}/5 ---")
        tasks = [send_random_video(chat_id, bot) for chat_id in active_chat_ids]
        await asyncio.gather(*tasks)
        await asyncio.sleep(2)
        
if __name__ == "__main__":
    asyncio.run(main())
