from recommendations.entity.outfit import Outfit
from recommendations.entity.clothing import Prenda
from typing import List


class OutfitRepository:
    """Repositorio para operaciones relacionadas con outfits"""

    @staticmethod
    def create_outfit(nombre: str, prendas: List[Prenda]) -> Outfit:
        """
        Crea un nuevo outfit
        
        Args:
            nombre: Nombre del outfit
            prendas: Lista de prendas que componen el outfit
            
        Returns:
            Outfit creado
        """
        outfit = Outfit(nombre=nombre, prendas=prendas)
        return outfit

    @staticmethod
    def filter_by_type(prendas: List[Prenda], tipo: str) -> List[Prenda]:
        """
        Filtra prendas por tipo
        
        Args:
            prendas: Lista de prendas
            tipo: Tipo de prenda a filtrar
            
        Returns:
            Lista de prendas filtradas
        """
        return [p for p in prendas if p.tipo == tipo]

    @staticmethod
    def filter_by_color(prendas: List[Prenda], color: str) -> List[Prenda]:
        """
        Filtra prendas por color
        
        Args:
            prendas: Lista de prendas
            color: Color a filtrar
            
        Returns:
            Lista de prendas filtradas
        """
        return [p for p in prendas if p.color == color]

    @staticmethod
    def filter_by_season(prendas: List[Prenda], temporada: str) -> List[Prenda]:
        """
        Filtra prendas por temporada
        
        Args:
            prendas: Lista de prendas
            temporada: Temporada a filtrar
            
        Returns:
            Lista de prendas filtradas
        """
        return [p for p in prendas if p.temporada == temporada]

    @staticmethod
    def group_by_type(prendas: List[Prenda]) -> dict:
        """
        Agrupa prendas por tipo
        
        Args:
            prendas: Lista de prendas
            
        Returns:
            Diccionario con prendas agrupadas por tipo
        """
        grouped = {}
        for prenda in prendas:
            if prenda.tipo not in grouped:
                grouped[prenda.tipo] = []
            grouped[prenda.tipo].append(prenda)
        return grouped
