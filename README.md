# 🎥 SenderZ Telegram

Un bot simple de Telegram que envía videos al usuario mediante comandos. Ideal para compartir contenido multimedia de forma automática.

---

## ✨ Características

- Comando `/start`: Saluda al usuario.
- Comando `/video`: Envía un video (desde URL o archivo local).
- Fácil de personalizar: agrega más videos, aleatoriedad, o integración con APIs.
- Hecho con `python-telegram-bot` (v20+).

---

## 🚀 Inicio Rápido

### 1. Requisitos

- Python 3.8 o superior
- Un bot creado en [@BotFather](https://t.me/BotFather)

### 2. Instala las dependencias

```bash
pip install python-telegram-bot
```

### 3. Configura el bot

1. Crea el bot con `@BotFather` y obtén tu **token**.
2. Abre `bot_video.py` y reemplaza:
   ```python
   TOKEN = 'TU_TOKEN_AQUI'
   ```
3. (Opcional) Cambia el video:
   - **URL**: Usa una pública (ej. `https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4`)
   - **Archivo local**: Coloca `mi_video.mp4` en la carpeta y usa:
     ```python
     video=open('mi_video.mp4', 'rb')
     ```

### 4. Ejecuta el bot

```bash
python bot_video.py
```

### 5. Prueba en Telegram

- Busca tu bot por su `@username`.
- Envía:
  ```
  /start
  /video
  ```

---

## 📂 Estructura del Proyecto

```
video-telegram-bot/
│
├── bot_video.py          # Código principal del bot
├── mi_video.mp4          # (Opcional) Video local de ejemplo
├── README.md             # Esta guía
└── requirements.txt      # Dependencias
```

---

## 🔧 Personalización

### Agregar más videos

Edita la función `send_video`:

```python
import random

VIDEOS = [
    'https://sample-videos.com/.../video1.mp4',
    'https://sample-videos.com/.../video2.mp4',
    open('local1.mp4', 'rb'),
]

video = random.choice(VIDEOS)
```

### Comandos adicionales

Agrega más handlers en `main()`:

```python
application.add_handler(CommandHandler("random", send_random_video))
```

---

## 🚀 Despliegue (24/7)

| Plataforma      | Enlace                             |
| --------------- | ---------------------------------- |
| Render          | [render.com](https://render.com)   |
| Railway         | [railway.app](https://railway.app) |
| Heroku (legacy) | [heroku.com](https://heroku.com)   |

> Usa `requirements.txt`:
>
> ```txt
> python-telegram-bot>=20.0
> ```

---

## 🐛 Errores Comunes

| Error               | Solución                                            |
| ------------------- | --------------------------------------------------- |
| `Invalid token`     | Verifica el token en `@BotFather`                   |
| `Video no se envía` | Asegúrate que sea MP4 < 50 MB y accesible           |
| `ConnectionError`   | Revisa tu conexión o usa `polling` con `timeout=10` |

---

## 🤝 Contribuir

1. Haz fork
2. Crea una rama: `git checkout -b feature/nueva-funcion`
3. Commit: `git commit -m "Añadí X"`
4. Push y abre un Pull Request

---

## 📄 Licencia

[MIT License](LICENSE) – Úsalo libremente.

---

## 💡 Ideas Futuras

- [ ] Enviar videos desde YouTube (con `pytube`)
- [ ] Panel web para subir videos
- [ ] Base de datos de videos
- [ ] Soporte para GIFs y stickers

---

**¡Listo para compartir videos con el mundo!** 🚀

> Creado con ❤️ por [tu nombre]

````

---

### Archivo adicional: `requirements.txt`
Crea este archivo en la raíz del proyecto:
```txt
python-telegram-bot>=20.0
````

---

### Próximos pasos

1. Guarda este `README.md` en tu carpeta del proyecto.
2. Crea el repositorio en GitHub y súbelo:
   ```bash
   git init
   git add .
   git commit -m "Primer commit: bot de videos + README"
   git remote add origin https://github.com/tu-usuario/video-telegram-bot.git
   git push -u origin main
   ```

¿Quieres que ahora creemos el `bot_video.py` definitivo (con video local + aleatorio)? ¿O pasamos al deploy en Render/Railway? ¡Tú decides! 🔥
