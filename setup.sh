#!/bin/bash

# Crear entorno virtual
echo "Creando entorno virtual..."
python -m venv venv

# Activar entorno virtual
echo "Activando entorno virtual..."
source venv/bin/activate

# Instalar dependencias
echo "Instalando dependencias..."
pip install -r requirements.txt

echo "Configuración completada. Para activar el entorno virtual, ejecuta:"
echo "source venv/bin/activate"
echo ""
echo "Para iniciar la API, ejecuta:"
echo "python main.py"
