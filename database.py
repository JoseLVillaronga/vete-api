import os
import pymysql
from dotenv import load_dotenv
from typing import Dict, List, Any

# Cargar variables de entorno
load_dotenv()

# Configuración de la base de datos
DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'user': os.getenv('DB_USERNAME'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_DATABASE'),
    'port': int(os.getenv('DB_PORT', 3306)),
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor
}

def get_connection():
    """Establece una conexión a la base de datos MySQL."""
    try:
        connection = pymysql.connect(**DB_CONFIG)
        return connection
    except Exception as e:
        print(f"Error al conectar a la base de datos: {e}")
        raise

def execute_query(query: str, params: tuple = None) -> List[Dict[str, Any]]:
    """
    Ejecuta una consulta SQL y devuelve los resultados.
    
    Args:
        query: Consulta SQL a ejecutar
        params: Parámetros para la consulta (opcional)
        
    Returns:
        Lista de diccionarios con los resultados de la consulta
    """
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute(query, params)
            result = cursor.fetchall()
            return result
    except Exception as e:
        print(f"Error al ejecutar la consulta: {e}")
        raise
    finally:
        connection.close()
