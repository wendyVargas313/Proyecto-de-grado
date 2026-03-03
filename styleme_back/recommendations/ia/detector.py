from ultralytics import YOLO
import os

# Ruta al modelo preentrenado YOLOv8n
MODEL_PATH = os.path.join("recommendations", "ia", "models", "yolov8n.pt")

# Cargar el modelo YOLO desde la ruta especificada
yolo_model = YOLO(MODEL_PATH)

def detect_clothing_items(image_path):
    """
    Recibe la ruta de una imagen y devuelve los objetos detectados.
    """
     # Ejecutar la detección en la imagen de entrada
    results = yolo_model(image_path)

    detections = []

    # Procesar cada resultado obtenido
    for result in results:
        for box in result.boxes:
            # Obtener el nombre de la clase (ej. 'shirt', 'pants', etc.)
            class_name = yolo_model.names[int(box.cls[0])]
            # Obtener la puntuación de confianza
            confidence = float(box.conf[0])
            # Coordenadas de la caja delimitadora en formato [x1, y1, x2, y2]
            bbox = box.xyxy[0].tolist()

            # Agregar la detección a la lista
            detections.append({
                "type": class_name,
                "confidence": confidence,
                "bounding_box": bbox
            })

    return detections