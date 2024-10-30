// Importa la biblioteca de Telegram
const TelegramBot = require("node-telegram-bot-api");

// Reemplaza 'YOUR_TELEGRAM_BOT_TOKEN' con el token de tu bot
const token = "7655392623:AAGY_BdYLyugjhtR9q7KxgA83KB8EITaDmw";

// Crea un nuevo bot
const bot = new TelegramBot(token, { polling: true });

// Escucha por cualquier mensaje
bot.on("message", (msg) => {
  const chatId = msg.chat.id; // Obtiene el ID del chat

  // Verifica si el mensaje es "hola"
  if (msg.text.toLowerCase() === "hola") {
    bot.sendMessage(chatId, "¡Hola! ¿Cómo estás?"); // Responde con un saludo
  }
});
