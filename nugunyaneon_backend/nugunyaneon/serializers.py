from rest_framework import serializers
from .models import FileUpload
from .models import AnalysisResult

class FileUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = FileUpload
        fields = ['file']

class AnalysisResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnalysisResult
        fields = ['error', 'probability', 'phisingType']