from django.urls import path
from recommendations.controllers.outfit_controller import recommend_outfit, recommend_outfit_ai
from recommendations.controllers.imagen_controller import detect_clothing_view
from recommendations.controllers.image_serve_controller import serve_image, get_image_metadata_view
from recommendations.controllers.auth_controller import (
    register_view, login_view, profile_view, change_password_view, logout_view
)

urlpatterns = [
    # Endpoints de autenticación
    path('auth/register/', register_view, name='register'),
    path('auth/login/', login_view, name='login'),
    path('auth/profile/<str:user_id>/', profile_view, name='profile'),
    path('auth/change-password/<str:user_id>/', change_password_view, name='change_password'),
    path('auth/logout/<str:user_id>/', logout_view, name='logout'),
    
    # Endpoints existentes
    path('recommend/', recommend_outfit),
    path('recommend-outfit-ai/', recommend_outfit_ai),
    path('detect-clothing/', detect_clothing_view),
    path('images/<str:file_id>', serve_image, name='serve_image'),
    path('images/<str:file_id>/metadata', get_image_metadata_view, name='image_metadata'),
]