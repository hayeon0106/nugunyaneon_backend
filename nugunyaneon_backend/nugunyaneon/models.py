from django.db import models

# Create your models here.
# 모델은 DB에 저장할 내용들을 다루는 영역


# test
class FileUpload(models.Model):
    #file_name = models.CharField(max_length=300)
    file = models.FileField()


# 분석 결과를 전달하는 모델
class AnalysisResult(models.Model):
    # 수정 필요. words는 리스트임.
    error = models.CharField(max_length=100)
    probability = models.FloatField()
    phisingType = models.CharField(max_length=50)