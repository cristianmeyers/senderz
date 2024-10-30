// Importa la biblioteca de Telegram
const TelegramBot = require("node-telegram-bot-api");
const fs = require("fs");
const request = require("request");
const path = require("path");

const token = "7655392623:AAGY_BdYLyugjhtR9q7KxgA83KB8EITaDmw";

// Crea un nuevo bot
const bot = new TelegramBot(token, { polling: true });

// Define la carpeta donde se guardarán las fotos
const photoFolder = path.join(__dirname, "fotos");
const videoFolder = path.join(__dirname, "videos"); // creamos la ruta absoluda de la carpeta video
// Asegúrate de que la carpeta exista
if (!fs.existsSync(photoFolder)) {
  fs.mkdirSync(photoFolder);
}
// =============================== aseguramos que la carpeta videoFolder exista, y si no, pues la cree interrumpiendo el programa "Sync"
if (!fs.existsSync(videoFolder)) {
  fs.mkdirSync(videoFolder);
}
// Manejar fotos
bot.on("photo", (msg) => {
  const chatId = msg.chat.id; // Obtiene el ID del chat
  const photoId = msg.photo[msg.photo.length - 1].file_id; // Obtiene el ID de la foto más alta

  // Usa el método getFile para obtener la información del archivo
  bot
    .getFile(photoId)
    .then((file) => {
      const filePath = file.file_path; // Obtiene la ruta del archivo
      const fileUrl = `https://api.telegram.org/file/bot${token}/${filePath}`; // Construye la URL del archivo

      // Define la ruta donde guardar la foto
      const localFilePath = path.join(photoFolder, `${photoId}.jpg`); // Cambia la extensión según el tipo de archivo

      // Descarga la foto
      request(fileUrl)
        .pipe(fs.createWriteStream(localFilePath))
        .on("close", () => {
          bot.sendMessage(chatId, "¡Foto guardada exitosamente!"); // Confirma que se guardó la foto
        });
    })
    .catch((error) => {
      console.error("Error al obtener el archivo:", error);
      bot.sendMessage(chatId, "Lo siento, no pude guardar la foto.");
    });
});

// Manejar videos
bot.on("video", (msg) => {
  // ============================================================= Obtengo la informacion basica :
  // Id del chat y del archivo
  const chatId = msg.chat.id; // ================================== Id del chat para enviar el mensaje de confirmacion
  const videoId = msg.video[msg.video.length - 1].file_id; // ================== Id del video de mayor resolucion

  // Ahora hago la peticion al servidor para obtener el archivo
  bot
    .getFile(videoId) // esto me devuelve una promesa la cual llamaré << video >>
    .then((video) => {
      // ahora hay que definir la ruta del archivo en el << servidor >>, uso la propiedad file_path
      const serverVideoPath = video.file_path;
      // la ruta en la que se guardara el video
      const localVideoPath = path.join(videoFolder, `${videoId}.mp4`);

      // con esa informacion puedo hacer la URL hacer una peticion al servidor
      const videoUrl = `https://api.telegram.org/file/bot${token}/${serverVideoPath}`;

      // peticion al servidor
      request(videoUrl)
        //hacemos que el flujo de entrada se conecte con el flujo de escritura del archivo ${videoId}.mp4
        .pipe(fs.createWriteStream(localVideoPath))
        // una vez que termine enviamos un mensaje de confirmacion al chat
        .on("close", () => {
          bot.sendMessage(chatId, "Vidéo guardado exitosamente");
        })
        // en caso de que haya un error
        .catch((error) => {
          console.error("Error al obtener el archivo:", error);
          bot.sendMessage(chatId, "Lo siento, no pude guardar lel video.");
        });
    });
});

// Manejar errores de polling
bot.on("polling_error", (error) => {
  console.error("Polling error:", error.code, error.message);
});
