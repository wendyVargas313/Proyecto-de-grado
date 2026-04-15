import os
import __main__
import random
import joblib
import numpy as np
from recommendations.entity.outfit import Outfit

# Funcion requerida por el pickle
def prenda_a_vector(prenda):
    return {}

if not hasattr(__main__, 'prenda_a_vector'):
    __main__.prenda_a_vector = prenda_a_vector

# Cargar el paquete completo del modelo
_model_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'models', 'modelo_recomendador_outfits.pkl')
_bundle = joblib.load(_model_path)

kmeans_model   = _bundle['kmeans']
le_tipo        = _bundle['le_tipo']
le_color       = _bundle['le_color']
le_temporada   = _bundle['le_temporada']
tipos_prenda   = _bundle['tipos_prenda']
colores        = _bundle['colores']
temporadas     = _bundle['temporadas']


def generate_outfits(wardrobe, preferences):
    tops    = [p for p in wardrobe if p.tipo in ('camiseta', 'T-shirt', 'shirt', 'blouse', 'top')]
    bottoms = [p for p in wardrobe if p.tipo in ('pantalon', 'pants', 'jeans', 'shorts', 'skirt')]
    shoes   = [p for p in wardrobe if p.tipo == 'zapatos']

    outfits = []
    for _ in range(3):
        outfit = Outfit(
            nombre="Outfit sugerido",
            prendas=[
                random.choice(tops)    if tops    else None,
                random.choice(bottoms) if bottoms else None,
                random.choice(shoes)   if shoes   else None,
            ]
        )
        outfit.prendas = [p for p in outfit.prendas if p]
        outfits.append(outfit)
    return outfits


def predict_outfit_group(features: dict) -> int:
    """
    Predice el grupo de outfit dado un dict con claves 'tipo', 'color', 'temporada'.
    Si no estan presentes toma valores por defecto.
    """
    tipo       = features.get('tipo', tipos_prenda[0])
    color      = features.get('color', colores[0])
    temporada  = features.get('temporada', temporadas[0])

    # Codificar con LabelEncoders
    try:
        t = le_tipo.transform([tipo])[0]
    except ValueError:
        t = 0

    try:
        c = le_color.transform([color])[0]
    except ValueError:
        c = 0

    try:
        s = le_temporada.transform([temporada])[0]
    except ValueError:
        s = 0

    vector = np.array([[t, c, s]])
    group = kmeans_model.predict(vector)
    return int(group[0])