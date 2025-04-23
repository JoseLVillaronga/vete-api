from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import datetime

class UrgenciaResponse(BaseModel):
    """Modelo para la respuesta de urgencias."""
    data: List[Dict[str, Any]]
    count: int
    timestamp: datetime

class ErrorResponse(BaseModel):
    """Modelo para respuestas de error."""
    detail: str
