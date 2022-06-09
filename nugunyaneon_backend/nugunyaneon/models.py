from django.db import models

# Create your models here.
# 모델은 DB에 저장할 내용들을 다루는 영역


# 사용자의 데이터를 업로드
class FileUpload(models.Model):
    file_id = models.IntegerField(primary_key=True, null = False, unique=True, default=0)
    file_name = models.TextField(null = True)
    file_path = models.TextField(null = True)


# 분석 결과를 전달하는 모델
class AnalysisResult(models.Model):
    error = models.CharField(null=True,max_length=100)
    probability = models.FloatField()
    phisingType = models.CharField(null=True,max_length=50)
    token_ko = models.TextField(null=True)