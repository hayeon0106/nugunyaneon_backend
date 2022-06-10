from django.urls import path, include
from .views import analysisAPI, FilesAPIMixins, FileAPIMixins, TestAPIMixins

urlpatterns = [
    path('analysisAPI/', analysisAPI),

    path('files/', FilesAPIMixins.as_view()),
    path('files=<int:fileId>', FileAPIMixins.as_view()),

    path('test/', TestAPIMixins.as_view()),
    path('test=<int:fileId>', TestAPIMixins.as_view()),
]