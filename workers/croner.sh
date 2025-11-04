#!/bin/bash

# === Validar argumentos ===
[[ $# -ne 2 ]] && {
    echo "Uso: $0 <script.py> \"<intervalo>\""
    echo ""
    echo "Ejemplos:"
    echo "  $0 sender.py \"00:05\"          # Cada 5 min"
    echo "  $0 sender.py \"01:00\"          # Cada hora"
    echo "  $0 sender.py \"02:00\"          # Cada 2 horas"
    echo "  $0 sender.py \"daily 09:30\"    # Diaria 9:30"
    echo "  $0 sender.py \"monday 23:00\"   # Lunes 23:00"
    echo "  $0 sender.py \"sunday 03:15\"   # Domingo 3:15"
    echo ""
    exit 1
}

SCRIPT="$1"
INTERVAL="$2"
VENV_PYTHON="venv/bin/python"
LOG_FILE="$HOME/croner_jobs.log"

# === Validar script ===
[[ ! -f "$SCRIPT" ]] && { echo "ERROR: Script no encontrado: $SCRIPT"; exit 1; }
[[ ! -x "$SCRIPT" ]] && { echo "Dando permisos..."; chmod +x "$SCRIPT"; }

# === Parsear intervalo: [day] HH:MM ===
DAY=""
TIME_PART=""

# Separar día (si existe)
if [[ "$INTERVAL" == *" "* ]]; then
    DAY=$(echo "$INTERVAL" | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
    TIME_PART=$(echo "$INTERVAL" | cut -d' ' -f2)
else
    TIME_PART="$INTERVAL"
fi

# Validar formato HH:MM
if ! [[ "$TIME_PART" =~ ^([0-9]{2}):([0-9]{2})$ ]]; then
    echo "ERROR: Formato de hora inválido: $TIME_PART (usa HH:MM)"
    exit 1
fi

HOUR=${BASH_REMATCH[1]}
MIN=${BASH_REMATCH[2]}

[[ "$HOUR" -lt 0 || "$HOUR" -gt 23 || "$MIN" -lt 0 || "$MIN" -gt 59 ]] && {
    echo "ERROR: Hora fuera de rango: $TIME_PART"
    exit 1
}

# === Generar cron ===
if [[ -z "$DAY" ]]; then
    # Sin día → intervalo repetitivo
    if [[ "$MIN" == "00" && "$HOUR" == "00" ]]; then
        echo "ERROR: 00:00 no es válido para repetición"
        exit 1
    elif [[ "$MIN" != "00" ]]; then
        # Cada X minutos
        CRON="*/$MIN * * * *"
    else
        # Cada X horas
        CRON="0 */$HOUR * * *"
    fi
else
    # Con día
    case "$DAY" in
        daily)     CRON="$MIN $HOUR * * *" ;;
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

# === Añadir a crontab ===
CRON_LINE="$CRON $VENV_PYTHON \"$SCRIPT\" >> $LOG_FILE 2>&1"
(crontab -l 2>/dev/null | grep -v -F "$SCRIPT"; echo "$CRON_LINE") | crontab -

# === Confirmación ===
echo "Cron creado:"
echo "   $INTERVAL → $CRON"
echo "   $CRON_LINE"