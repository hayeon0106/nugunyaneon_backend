#---------- API 통신을 위한 패키지 ----------
from rest_framework import viewsets, permissions, generics, status
from rest_framework import mixins
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from rest_framework.generics import get_object_or_404

from .models import FileUpload, AnalysisResult
from .serializers import FileUploadSerializer, AnalysisResultSerializer

from nugunyaneon import voice as v
from nugunyaneon import serializers

# Create your views here.

class FilesAPIMixins(mixins.ListModelMixin, mixins.CreateModelMixin, generics.GenericAPIView):
    queryset = FileUpload.objects.all()
    serializer_class = FileUploadSerializer

    # 파일 목록 GET
    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    # 새로운 파일 데이터 저장 POST
    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

class FileAPIMixins(mixins.RetrieveModelMixin, generics.GenericAPIView):
    queryset = FileUpload.objects.all()
    serializer_class = FileUploadSerializer
    lookup_field = 'file_id'

    # 파일 하나 정보 GET
    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)



# 분석 결과 전달
@api_view(['GET'])
def analysisAPI(request):#, file_id):
    #file = get_object_or_404(FileUpload, file_id =  file_id)
    #serializer = FileUploadSerializer(file)
    testFile_path = "./nugunyaneon/test_media/test.mp3"
    result = v.Voice(testFile_path).result()
    #result = v.Voice(testFile_path).test()
    
    # DB에 저장하는 코드

    # 직렬화해서 보내야 함.
    return Response(result)

# 사용자로부터 데이터 받기
@api_view(['GET', 'POST'])
def uploadsAPI(request):
    # 들어온 신호가 POST일 때,
    if request.method == 'GET':
        file = FileUpload.objects.all()
        serializer = FileUploadSerializer(file, many = True)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    elif request.method == "POST":
        serializer = FileUploadSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            # FileUploadSerializer에 맞게 직렬화
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# 분석 결과 전달
@api_view(['GET'])
def analysisAPI(request):#, file_id):
    #file = get_object_or_404(FileUpload, file_id =  file_id)
    #serializer = FileUploadSerializer(file)
    testFile_path = "./nugunyaneon/test_media/test.mp3"
    result = v.Voice(testFile_path).result()
    #result = v.Voice(testFile_path).test()
    
    # DB에 저장하는 코드

    # 직렬화해서 보내야 함.
    return Response(result)