from dataclasses import dataclass
from typing import Optional


@dataclass
class RegisterRequestDTO:
    nombre: str
    email: str
    password: str


@dataclass
class LoginRequestDTO:
    email: str
    password: str


@dataclass
class AuthResponseDTO:
    success: bool
    message: str
    token: Optional[str] = None
    user: Optional[dict] = None
