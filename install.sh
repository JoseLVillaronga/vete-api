#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con formato
print_message() {
    echo -e "${GREEN}[+] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
    echo -e "${RED}[-] $1${NC}"
}

# Obtener el directorio actual
CURRENT_DIR=$(pwd)
USER=$(whoami)
GROUP=$(id -gn)

print_message "Iniciando instalación de la API de Urgencias Veterinarias..."

# Verificar si el usuario puede ejecutar sudo
if ! sudo -n true 2>/dev/null; then
    print_error "Este script requiere privilegios sudo sin contraseña."
    exit 1
fi

# Verificar si el entorno virtual existe, si no, crearlo
if [ ! -d "venv" ]; then
    print_message "Creando entorno virtual..."
    python -m venv venv
    if [ $? -ne 0 ]; then
        print_error "Error al crear el entorno virtual."
        exit 1
    fi
else
    print_warning "El entorno virtual ya existe."
fi

# Activar el entorno virtual e instalar dependencias
print_message "Instalando dependencias..."
source venv/bin/activate
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    print_error "Error al instalar las dependencias."
    exit 1
fi

# Modificar el archivo de servicio con el usuario y grupo actuales
print_message "Configurando el servicio systemd..."
sed -i "s/User=jose/User=$USER/g" vete-api.service
sed -i "s/Group=libvirt-qemu/Group=$GROUP/g" vete-api.service
sed -i "s|WorkingDirectory=/home/jose/vete-api|WorkingDirectory=$CURRENT_DIR|g" vete-api.service
sed -i "s|ExecStart=/home/jose/vete-api/venv/bin/python|ExecStart=$CURRENT_DIR/venv/bin/python|g" vete-api.service
sed -i "s|Environment=\"PATH=/home/jose/vete-api/venv/bin|Environment=\"PATH=$CURRENT_DIR/venv/bin|g" vete-api.service

# Copiar el archivo de servicio a systemd
print_message "Instalando el servicio systemd..."
sudo cp vete-api.service /etc/systemd/system/
if [ $? -ne 0 ]; then
    print_error "Error al copiar el archivo de servicio."
    exit 1
fi

# Recargar systemd
print_message "Recargando systemd..."
sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
    print_error "Error al recargar systemd."
    exit 1
fi

# Habilitar el servicio para que se inicie con el sistema
print_message "Habilitando el servicio..."
sudo systemctl enable vete-api.service
if [ $? -ne 0 ]; then
    print_error "Error al habilitar el servicio."
    exit 1
fi

# Iniciar el servicio
print_message "Iniciando el servicio..."
sudo systemctl start vete-api.service
if [ $? -ne 0 ]; then
    print_error "Error al iniciar el servicio."
    exit 1
fi

# Verificar el estado del servicio
print_message "Verificando el estado del servicio..."
sudo systemctl status vete-api.service

print_message "Instalación completada con éxito."
print_message "La API está disponible en: http://localhost:22000"
print_message "Documentación: http://localhost:22000/docs"
print_message ""
print_message "Comandos útiles:"
print_message "  - Ver logs: sudo journalctl -u vete-api.service -f"
print_message "  - Reiniciar servicio: sudo systemctl restart vete-api.service"
print_message "  - Detener servicio: sudo systemctl stop vete-api.service"
print_message "  - Ver estado: sudo systemctl status vete-api.service"
