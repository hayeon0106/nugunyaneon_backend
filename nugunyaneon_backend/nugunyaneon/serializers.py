from rest_framework import serializers
from .models import FileUpload, Test, Result

class FileUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = FileUpload
        fields = ['file_id', 'file_name', 'file_path']

# 파일과 분석 결과를 함께 저장
class TestSerializer(serializers.ModelSerializer):
    class Meta:
        model = Test
        fields = ['fileId', 'fileName', 'filePath', 'file', 'error', 'probability', 'phishingType']

class ResultSerializer(serializers.ModelSerializer):
    class Meta:
        model=Result
        fields = ['error', 'phishingType', 'probability']