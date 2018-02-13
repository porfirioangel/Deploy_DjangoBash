#!/bin/bash

PORT=8000

echo "Buscando proceso corriendo en el puerto $PORT..."
echo ""
PID=$(lsof -t -i:$PORT)

if [ -z "$PID" ]; then
    echo "No está corriendo ningún proceso en el puerto $PORT"
    echo ""
    echo "Corriendo nuevamente el proceso..."
    echo ""
    python manage.py runserver 0.0.0.0:8000 >> log 2>&1 &
    echo ""
    echo "Proceso iniciado"
    echo ""
else
    echo "El id del proceso en el puerto $PORT es: $PID"
fi
