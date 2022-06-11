from enum import auto
from django.db import models
from django.contrib.postgres.fields import ArrayField

# Create your models here.
# 모델은 DB에 저장할 내용들을 다루는 영역

# 파일 정보와 분석 정보를 함께 저장하는 모델
class AnalysisModel(models.Model):
    fileId = models.IntegerField(primary_key=True, null = False, unique=True, default=0)
    fileName = models.TextField(null = True)
    filePath = models.TextField(null = True)
    file = models.FileField(null=True, upload_to='audiofiles/')
    error = models.CharField(null=True,max_length=100)
    probability = models.FloatField()
    phishingType = models.CharField(null=True,max_length=50)
    #words = models.JSONField(default=dict)
    isAllowed = models.BooleanField(default=False)

"""
# 사용자의 데이터를 업로드
class FileUpload(models.Model):
    file_id = models.IntegerField(primary_key=True, null = False, unique=True, default=0)
    file_name = models.TextField(null = True)
    file_path = models.TextField(null = True)

class Result(models.Model):
    error = models.CharField(null=True,max_length=100)
    phishingType = models.CharField(null=True,max_length=50)
    probability = models.FloatField()
"""