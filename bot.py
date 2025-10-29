from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
from dotenv import load_dotenv
import os
import json
from pathlib import Path

# Cargar variables del archivo .env
load_dotenv()
TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")

# Ruta del archivo JSON
USERS_FILE = Path("users.json")

# Crear archivo JSON si no existe
def init_users_file():
    if not USERS_FILE.exists():
        with open(USERS_FILE, "w", encoding="utf-8") as f:
            json.dump({}, f, ensure_ascii=False, indent=2)

# Cargar usuarios desde JSON
def load_users():
    init_users_file()
    with open(USERS_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

# Guardar usuarios en JSON
def save_users(users):
    with open(USERS_FILE, "w", encoding="utf-8") as f:
        json.dump(users, f, ensure_ascii=False, indent=2)

# Función: agregar o actualizar usuario
async def newuser(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    users = load_users()

    user_id = str(user.id)
    user_data = {
        "id": user_id,
        "first_name": user.first_name or "",
        "username": user.username or "",
        "is_admin": users.get(user_id, {}).get("is_admin", False)  # Mantiene si ya era admin
    }

    # Solo actualiza si hay cambios (opcional, pero eficiente)
    if user_id not in users or users[user_id] != user_data:
        users[user_id] = user_data
        save_users(users)
        print(f"Usuario guardado/actualizado: {user.first_name} (@{user.username})")

    return user_data  # útil si necesitas usarlo después

# Comando /start
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    await newuser(update, context)  # Registrar usuario
    await update.message.reply_text(f"¡Hola {user.first_name}! Bienvenido al bot.")

# --- Inicialización ---
app = ApplicationBuilder().token(TOKEN).build()

# Registrar handlers
app.add_handler(CommandHandler("start", start))

# Ejecutar
if __name__ == "__main__":
    print("Bot iniciado... Presiona Ctrl+C para detener.")
    app.run_polling()