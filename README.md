# API de Urgencias Veterinarias

API REST desarrollada con FastAPI para consultar urgencias veterinarias recientes. Esta API permite obtener información sobre las urgencias registradas en los últimos 2 minutos desde una base de datos MySQL.

## Tabla de Contenidos

- [Características](#características)
- [Requisitos](#requisitos)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Configuración](#configuración)
- [Instalación](#instalación)
  - [Instalación Manual](#instalación-manual)
  - [Instalación como Servicio](#instalación-como-servicio)
- [Uso de la API](#uso-de-la-api)
  - [Documentación](#documentación)
  - [Endpoints](#endpoints)
  - [Autenticación](#autenticación)
  - [Ejemplos de Uso](#ejemplos-de-uso)
- [Gestión del Servicio](#gestión-del-servicio)
- [Seguridad](#seguridad)
- [Solución de Problemas](#solución-de-problemas)
- [Desinstalación](#desinstalación)

## Características

- Consulta de urgencias veterinarias registradas en los últimos 2 minutos
- Autenticación mediante API Key (Bearer Token)
- Documentación interactiva con Swagger UI
- Instalación como servicio de Linux (systemd)
- Respuestas en formato JSON
- Manejo de errores y excepciones

## Requisitos

- Python 3.6 o superior
- MySQL Server 5.7 o superior
- Permisos sudo (para la instalación como servicio)
- Base de datos `veterinaria` con tabla `urgencias` que contenga al menos un campo `fecha`

## Estructura del Proyecto

```
vete-api/
├── .env                  # Variables de entorno (conexión DB y API Key)
├── main.py               # Punto de entrada de la aplicación FastAPI
├── database.py           # Funciones para conexión a la base de datos
├── models.py             # Modelos de datos (Pydantic)
├── auth.py               # Autenticación con API Key
├── requirements.txt      # Dependencias del proyecto
├── vete-api.service      # Configuración del servicio systemd
├── install.sh            # Script de instalación como servicio
├── uninstall.sh          # Script de desinstalación del servicio
└── README.md             # Documentación
```

## Configuración

### Archivo .env

El archivo `.env` contiene la configuración de la base de datos y la API Key:

```
# Datos de conexión MySQL
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=veterinaria
DB_USERNAME=josePHP
DB_PASSWORD=teccamsql365WEB

# API Key para autenticación
API_KEY=5f41e78f70a93218372b4e2d51974a391c28feeb485bd210c686a42c10848507
```

### Estructura de la Base de Datos

La API espera una tabla `urgencias` en la base de datos `veterinaria` con al menos los siguientes campos:
- `fecha`: Timestamp de la urgencia (utilizado en la consulta)

Ejemplo de consulta SQL que ejecuta la API:
```sql
SELECT * FROM urgencias WHERE fecha > (NOW() - INTERVAL 2 MINUTE)
```

## Instalación

### Instalación Manual

1. Clonar o descargar este repositorio:
   ```bash
   git clone <url-del-repositorio>
   cd vete-api
   ```

2. Crear un entorno virtual:
   ```bash
   python -m venv venv
   ```

3. Activar el entorno virtual:
   ```bash
   source venv/bin/activate
   ```

4. Instalar dependencias:
   ```bash
   pip install -r requirements.txt
   ```

5. Ejecutar la API:
   ```bash
   venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 22000 --reload
   ```

### Instalación como Servicio

Para instalar la API como un servicio de Linux (systemd) que se inicie automáticamente con el sistema:

```bash
./install.sh
```

Este script realiza las siguientes acciones:
- Verifica que el usuario tenga permisos sudo sin contraseña
- Crea un entorno virtual si no existe
- Instala las dependencias desde requirements.txt
- Configura el archivo de servicio systemd con las rutas y usuario actuales
- Instala el servicio en systemd
- Habilita el servicio para que se inicie automáticamente con el sistema
- Inicia el servicio
- Muestra el estado del servicio

## Uso de la API

### Documentación

La documentación interactiva está disponible en:
- http://localhost:22000/docs

Esta interfaz permite:
- Ver todos los endpoints disponibles
- Probar los endpoints directamente desde el navegador
- Ver los modelos de datos y esquemas de respuesta
- Autenticarse con la API Key

### Endpoints

#### Obtener urgencias recientes

```
GET /api/urgencias/recientes
```

Este endpoint devuelve todas las urgencias registradas en los últimos 2 minutos.

**Parámetros**: Ninguno

**Códigos de respuesta**:
- 200: Respuesta exitosa
- 401: No autorizado (API Key inválida o no proporcionada)
- 500: Error interno del servidor

### Autenticación

La API utiliza autenticación mediante Bearer Token con la API Key definida en el archivo `.env`.

Para autenticarse, incluya el siguiente encabezado en todas las solicitudes:
```
Authorization: Bearer 5f41e78f70a93218372b4e2d51974a391c28feeb485bd210c686a42c10848507
```

### Ejemplos de Uso

#### Consulta con curl

```bash
curl -X GET "http://localhost:22000/api/urgencias/recientes" \
     -H "accept: application/json" \
     -H "Authorization: Bearer 5f41e78f70a93218372b4e2d51974a391c28feeb485bd210c686a42c10848507"
```

#### Consulta con Python (requests)

```python
import requests

url = "http://localhost:22000/api/urgencias/recientes"
headers = {
    "accept": "application/json",
    "Authorization": "Bearer 5f41e78f70a93218372b4e2d51974a391c28feeb485bd210c686a42c10848507"
}

response = requests.get(url, headers=headers)
print(response.json())
```

#### Formato de Respuesta

```json
{
  "data": [
    {
      "id": 1,
      "fecha": "2023-04-23T18:30:00",
      "descripcion": "Ejemplo de urgencia",
      "otros_campos": "valores"
    }
  ],
  "count": 1,
  "timestamp": "2023-04-23T18:45:00.123456"
}
```

## Gestión del Servicio

Una vez instalado como servicio, puede gestionarlo con los siguientes comandos:

- **Ver logs en tiempo real**:
  ```bash
  sudo journalctl -u vete-api.service -f
  ```

- **Ver todos los logs**:
  ```bash
  sudo journalctl -u vete-api.service
  ```

- **Reiniciar el servicio**:
  ```bash
  sudo systemctl restart vete-api.service
  ```

- **Detener el servicio**:
  ```bash
  sudo systemctl stop vete-api.service
  ```

- **Iniciar el servicio**:
  ```bash
  sudo systemctl start vete-api.service
  ```

- **Ver estado del servicio**:
  ```bash
  sudo systemctl status vete-api.service
  ```

- **Habilitar/deshabilitar inicio automático**:
  ```bash
  sudo systemctl enable vete-api.service
  sudo systemctl disable vete-api.service
  ```

## Seguridad

### Consideraciones de Seguridad

1. **API Key**: La API Key está definida en el archivo `.env`. Asegúrese de mantener este archivo seguro y con permisos restrictivos:
   ```bash
   chmod 600 .env
   ```

2. **Puerto**: La API se ejecuta en el puerto 22000. Asegúrese de configurar su firewall adecuadamente si desea exponer la API a Internet.

3. **Base de datos**: Las credenciales de la base de datos están en el archivo `.env`. Utilice un usuario de MySQL con los mínimos privilegios necesarios.

## Solución de Problemas

### El servicio no inicia

Verifique los logs para identificar el problema:
```bash
sudo journalctl -u vete-api.service -e
```

Problemas comunes:
- Permisos insuficientes en los archivos
- Base de datos MySQL no disponible
- Puerto 22000 ya en uso

### Error de conexión a la base de datos

Verifique:
1. Que MySQL esté en ejecución: `systemctl status mysql`
2. Que las credenciales en `.env` sean correctas
3. Que la base de datos `veterinaria` exista
4. Que la tabla `urgencias` exista con el campo `fecha`

### Error de autenticación

Si recibe un error 401 (No autorizado), verifique:
1. Que está incluyendo el encabezado `Authorization` correctamente
2. Que el token coincide exactamente con el definido en `.env`
3. Que está utilizando el esquema `Bearer` seguido del token

## Desinstalación

Para desinstalar el servicio:

```bash
./uninstall.sh
```

Este script:
- Detiene el servicio si está en ejecución
- Deshabilita el inicio automático
- Elimina el archivo de servicio de systemd
- Recarga la configuración de systemd

**Nota**: Este script no elimina los archivos del proyecto ni el entorno virtual. Si desea eliminarlos completamente, deberá hacerlo manualmente.
