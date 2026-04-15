from ultralytics import YOLO
import os

MODEL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "models", "styleme_detector.pt")
yolo_model = YOLO(MODEL_PATH)

def detect_clothing_items(image_path, confidence=0.15):
    results = yolo_model(image_path, conf=confidence, verbose=False)
    detections = []
    for result in results:
        for box in result.boxes:
            class_name = yolo_model.names[int(box.cls[0])]
            confidence_score = float(box.conf[0])
            bbox = box.xyxy[0].tolist()
            detections.append({
                "type": class_name,
                "confidence": confidence_score,
                "bounding_box": bbox
            })
    return detections