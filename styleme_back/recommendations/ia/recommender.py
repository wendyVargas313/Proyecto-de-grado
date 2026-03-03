from recommendations.entity.outfit import Outfit
import random
import joblib
import pandas as pd

def generate_outfits(wardrobe, preferences):
    # Filtrar prendas por tipo
    tops = [p for p in wardrobe if p.tipo == 'camiseta']
    bottoms = [p for p in wardrobe if p.tipo == 'pantalón']
    shoes = [p for p in wardrobe if p.tipo == 'zapatos']

    outfits = []

    # Generar 3 combinaciones aleatorias de outfit
    for _ in range(3):
        outfit = Outfit(
            nombre="Outfit sugerido",
            prendas=[
                random.choice(tops) if tops else None,
                random.choice(bottoms) if bottoms else None,
                random.choice(shoes) if shoes else None
            ]
        )
        # Eliminar prendas None
        outfit.prendas = [p for p in outfit.prendas if p]
        outfits.append(outfit)

    return outfits

# Ruta del modelo entrenado
model_path = 'recommendations/ia/models/modelo_recomendador_outfits.pkl'
kmeans_model = joblib.load(model_path)

# Columnas esperadas por el modelo
model_columns = ['tipo_blusa', 'tipo_botas', 'tipo_camiseta', 'tipo_falda',
                 'tipo_jeans', 'tipo_pantalón', 'tipo_sandalias', 'tipo_suéter',
                 'tipo_zapatos', 'color_azul', 'color_beige', 'color_blanca',
                 'color_blanco', 'color_gris', 'color_negro', 'color_rojo',
                 'color_rosa', 'temporada_invierno', 'temporada_verano']

def predict_outfit_group(features):
    # Crear una fila con valores cero y columnas esperadas
    row = pd.DataFrame([[0] * len(model_columns)], columns=model_columns)

    # Activar las características proporcionadas
    for key in features:
        if key in row.columns:
            row.at[0, key] = 1

    # Predecir el grupo al que pertenece el outfit
    group = kmeans_model.predict(row)
    return group[0]