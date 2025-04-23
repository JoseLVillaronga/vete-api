from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.responses import JSONResponse
from datetime import datetime
import uvicorn

from database import execute_query
from models import UrgenciaResponse, ErrorResponse
from auth import verify_api_key

# Crear la aplicación FastAPI
app = FastAPI(
    title="API de Urgencias Veterinarias",
    description="API para consultar urgencias veterinarias recientes",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

@app.get(
    "/api/urgencias/recientes",
    response_model=UrgenciaResponse,
    responses={
        401: {"model": ErrorResponse, "description": "No autorizado"},
        500: {"model": ErrorResponse, "description": "Error interno del servidor"}
    },
    summary="Obtener urgencias recientes",
    description="Devuelve todas las urgencias registradas en los últimos 2 minutos"
)
async def get_urgencias_recientes(authorized: bool = Depends(verify_api_key)):
    """
    Obtiene las urgencias registradas en los últimos 2 minutos.

    Requiere autenticación mediante API Key en el encabezado Authorization.
    Ejemplo: Authorization: Bearer 5f41e78f70a93218372b4e2d51974a391c28feeb485bd210c686a42c10848507

    Returns:
        JSON con los datos de las urgencias, cantidad y timestamp
    """
    try:
        # Ejecutar la consulta SQL
        query = "SELECT * FROM urgencias WHERE fecha > (NOW() - INTERVAL 2 MINUTE)"
        result = execute_query(query)

        # Preparar la respuesta
        response = {
            "data": result,
            "count": len(result),
            "timestamp": datetime.now()
        }

        return response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al consultar las urgencias: {str(e)}"
        )

@app.get("/", include_in_schema=False)
async def root():
    """Redirecciona a la documentación de la API."""
    return {"message": "API de Urgencias Veterinarias. Visite /docs para ver la documentación."}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=22000, reload=True)
