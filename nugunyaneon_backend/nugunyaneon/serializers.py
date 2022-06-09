from rest_framework import serializers
from .models import FileUpload
from .models import AnalysisResult

class FileUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = FileUpload
        fields = ['file_id', 'file_name', 'file_path']

class AnalysisResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnalysisResult
        fields = ['error', 'probability', 'phisingType', 'token_ko']