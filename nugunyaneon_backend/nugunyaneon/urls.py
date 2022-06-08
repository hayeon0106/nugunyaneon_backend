from django.urls import path, include
from .views import uploadAPI
from .views import analysisAPI

urlpatterns = [
    path("upload/", uploadAPI),
    path("analysis/", analysisAPI)
]