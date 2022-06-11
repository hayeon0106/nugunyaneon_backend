from rest_framework import serializers
from .models import AnalysisModel
#from .models import FileUpload, Result


# 파일과 분석 결과를 함께 저장
class AnalysisModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnalysisModel
        fields = ['fileId', 'fileName', 'filePath', 'file', 'error', 'probability', 'phishingType', 'words', 'isAllowed']


"""
class FileUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = FileUpload
        fields = ['file_id', 'file_name', 'file_path']

class ResultSerializer(serializers.ModelSerializer):
    class Meta:
        model=Result
        fields = ['error', 'phishingType', 'probability']
"""