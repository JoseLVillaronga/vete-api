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

print_message "Desinstalando la API de Urgencias Veterinarias..."

# Verificar si el usuario puede ejecutar sudo
if ! sudo -n true 2>/dev/null; then
    print_error "Este script requiere privilegios sudo sin contraseña."
    exit 1
fi

# Detener el servicio
print_message "Deteniendo el servicio..."
sudo systemctl stop vete-api.service
if [ $? -ne 0 ]; then
    print_warning "Error al detener el servicio. Es posible que no esté en ejecución."
fi

# Deshabilitar el servicio
print_message "Deshabilitando el servicio..."
sudo systemctl disable vete-api.service
if [ $? -ne 0 ]; then
    print_warning "Error al deshabilitar el servicio. Es posible que no esté habilitado."
fi

# Eliminar el archivo de servicio
print_message "Eliminando el archivo de servicio..."
sudo rm -f /etc/systemd/system/vete-api.service
if [ $? -ne 0 ]; then
    print_error "Error al eliminar el archivo de servicio."
    exit 1
fi

# Recargar systemd
print_message "Recargando systemd..."
sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
    print_error "Error al recargar systemd."
    exit 1
fi

print_message "Desinstalación completada con éxito."
print_message "El entorno virtual y los archivos del proyecto no han sido eliminados."
print_message "Si desea eliminarlos completamente, ejecute:"
print_message "  rm -rf venv"
