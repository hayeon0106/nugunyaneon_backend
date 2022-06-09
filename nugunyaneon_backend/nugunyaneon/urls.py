from django.urls import path, include
from .views import uploadsAPI, analysisAPI, FilesAPIMixins, FileAPIMixins

urlpatterns = [
    path("upload/", uploadsAPI),
    path("analysis/", analysisAPI),
    path('test/', FilesAPIMixins.as_view()),
    path('test/<int:file_id>', FileAPIMixins.as_view())
]