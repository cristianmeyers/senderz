#!/bin/bash
# croner.sh
# Uso: ./croner.sh <script.py> "<intervalo>" <ruta_venv> "<comentario_opcional>" [<script_args>...]
# Ejemplo:
# ./croner.sh workers/sender.py "every 00:05" ./venv "Every 5 minutes" "/home/user/videos/" 3

SCRIPT="$1"
INTERVAL="$2"
VENV_PATH="$3"
COMMENT="$4"
shift 4
SCRIPT_ARGS="$*"
PYTHON="$VENV_PATH/bin/python"
LOG_FILE="$HOME/croner_jobs.log"

# --- Parse básico ---
DAY=""
TIME="$INTERVAL"

if [[ "$INTERVAL" == *" "* ]]; then
    DAY=$(echo "$INTERVAL" | cut -d' ' -f1)
    TIME=$(echo "$INTERVAL" | cut -d' ' -f2)
fi

HOUR=$(echo "$TIME" | cut -d':' -f1)
MIN=$(echo "$TIME" | cut -d':' -f2)

# --- Construcción del cron ---
if [[ "$DAY" == "every" ]]; then
    # every HH:MM → repetición cada X minutos o cada X horas
    if [[ "$HOUR" == "00" && "$MIN" != "00" ]]; then
        CRON="*/$MIN * * * *"
    elif [[ "$MIN" == "00" && "$HOUR" != "00" ]]; then
        CRON="0 */$HOUR * * *"
    else
        CRON="$MIN $HOUR * * *"
    fi
elif [[ -z "$DAY" || "$DAY" == "daily" ]]; then
    CRON="$MIN $HOUR * * *"
else
    case "$DAY" in
        monday)    CRON="$MIN $HOUR * * 1" ;;
        tuesday)   CRON="$MIN $HOUR * * 2" ;;
        wednesday) CRON="$MIN $HOUR * * 3" ;;
        thursday)  CRON="$MIN $HOUR * * 4" ;;
        friday)    CRON="$MIN $HOUR * * 5" ;;
        saturday)  CRON="$MIN $HOUR * * 6" ;;
        sunday)    CRON="$MIN $HOUR * * 0" ;;
        *)         echo "ERROR: Día inválido: $DAY"; exit 1 ;;
    esac
fi

# --- Línea cron final ---
SCRIPT_PATH=$(realpath "$SCRIPT")
if [[ -n "$COMMENT" ]]; then
    CRON_LINE="$CRON $PYTHON \"$SCRIPT_PATH\" $SCRIPT_ARGS >> \"$LOG_FILE\" 2>&1 # $COMMENT"
else
    CRON_LINE="$CRON $PYTHON \"$SCRIPT_PATH\" $SCRIPT_ARGS >> \"$LOG_FILE\" 2>&1"
fi

# --- Actualizar crontab ---
(crontab -l 2>/dev/null | grep -v -F "$SCRIPT_PATH"; echo "$CRON_LINE") | crontab -

echo "Cron ajouté : $CRON_LINE"
