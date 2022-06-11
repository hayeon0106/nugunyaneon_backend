#---------- API 통신을 위한 패키지 ----------
from rest_framework import viewsets, permissions, generics, status
from rest_framework import mixins
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from rest_framework.generics import get_object_or_404

#from .models import FileUpload, Result
#from .serializers import FileUploadSerializer, AnalysisModelSerializer, ResultSerializer

from .models import AnalysisModel
from .serializers import AnalysisModelSerializer

from nugunyaneon import voice as v
from nugunyaneon import serializers

import copy

# Create your views here.

# 분석 결과를 포함한 파일 데이터
class AnalysisAPIMixins(mixins.RetrieveModelMixin, mixins.CreateModelMixin, mixins.UpdateModelMixin, generics.GenericAPIView):
    queryset = AnalysisModel.objects.all()
    serializer_class = AnalysisModelSerializer
    lookup_field = "fileId"

    def get(self, request, *args, **kwargs):
        #if request.data['isAllowed'] == False:
            # delete문 넣기
        #return self.retrieve(request, *args, **kwargs)
        return Response("데이터 삭제")
    
    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        # 파일 불러오기
        fileName = request.POST.get('fileName')
        path = './audiofiles/' + fileName
        result = v.Voice(path).result()

        request.data._mutable = True
        # 데이터 내용 변경
        request.data['error'] = result['error']
        request.data['probability'] = result['probability']
        request.data['phishingType'] = result['phishingType']

        request.data._mutable = False
        
        #return Response(result['words'])
        return self.update(request, *args, **kwargs)


"""
# 전체 파일 목록
class FilesAPIMixins(mixins.ListModelMixin, mixins.CreateModelMixin, generics.GenericAPIView):
    queryset = FileUpload.objects.all()
    serializer_class = FileUploadSerializer

    # 파일 목록 GET
    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    # 새로운 파일 데이터 저장 POST
    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

# 파일 하나
class FileAPIMixins(mixins.RetrieveModelMixin, generics.GenericAPIView):
    queryset = FileUpload.objects.all()
    serializer_class = FileUploadSerializer
    lookup_field = 'fileId'

    # 파일 하나 정보 GET
    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)


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
def analysisAPI(request):
    #testFile_path = "../../../../../492.phishing_man.mp3"
    testFile_path = "./audiofiles/492.phishing_man.wav"
    #testFile_path = "./nugunyaneon/test_media/test.wav"
    result = v.Voice(testFile_path).result()

    return Response(result)
"""