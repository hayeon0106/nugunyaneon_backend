from django.urls import path, include
#from .views import analysisAPI, FilesAPIMixins, FileAPIMixins
from .views import AnalysisAPIMixins

urlpatterns = [
    path('analysis/', AnalysisAPIMixins.as_view()),
    path('analysis=<int:fileId>', AnalysisAPIMixins.as_view()),

    #path('analysisAPI/', analysisAPI),

    #path('files/', FilesAPIMixins.as_view()),
    #path('files=<int:fileId>', FileAPIMixins.as_view()),
]