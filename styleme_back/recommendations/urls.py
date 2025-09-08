from django.urls import path
from recommendations.controllers.outfit_controller import recommend_outfit, recommend_outfit_ai
from recommendations.controllers.imagen_controller import detect_clothing_view

urlpatterns = [
     path('recommend/', recommend_outfit),
    path('recommend-outfit-ai/', recommend_outfit_ai),
    path('detect-clothing/', detect_clothing_view),
]