from rest_framework import serializers
from .models import Nugunyaneon
from .models import AnalysisResult

class NugunyaneonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Nugunyaneon
        fields = ['file']
        #files = ('file')

class AnalysisResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnalysisResult
        fields = ['words', 'probability', 'phisingType']