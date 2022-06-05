from django.urls import path, include
from .views import uploadAPI

urlpatterns = [
path("upload/", uploadAPI)
]