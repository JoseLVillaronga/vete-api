import os
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Obtener la API_KEY del archivo .env
API_KEY = os.getenv("API_KEY")

# Configurar el esquema de seguridad para autenticación Bearer
security = HTTPBearer(
    scheme_name="API Key Authentication",
    description="Ingrese su API Key como un token Bearer",
    auto_error=True
)

async def verify_api_key(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """
    Verifica que la API Key proporcionada sea válida.
    
    Args:
        credentials: Credenciales de autorización HTTP
        
    Returns:
        True si la API Key es válida
        
    Raises:
        HTTPException: Si la API Key no es válida
    """
    if credentials.scheme != "Bearer":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Se requiere autenticación con esquema Bearer",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if credentials.credentials != API_KEY:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="API Key inválida",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    return True
