from django.urls import path
from recommendations.controllers.outfit_controller import recommend_outfit, recommend_outfit_ai
from recommendations.controllers.imagen_controller import detect_clothing_view
from recommendations.controllers.image_serve_controller import serve_image, get_image_metadata_view

urlpatterns = [
    path('recommend/', recommend_outfit),
    path('recommend-outfit-ai/', recommend_outfit_ai),
    path('detect-clothing/', detect_clothing_view),
    path('images/<str:file_id>', serve_image, name='serve_image'),
    path('images/<str:file_id>/metadata', get_image_metadata_view, name='image_metadata'),
]