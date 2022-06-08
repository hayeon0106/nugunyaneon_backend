#---------- API 통신을 위한 패키지 ----------
from rest_framework import viewsets, permissions, generics, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.views import APIView

from .models import FileUpload
from .models import AnalysisResult
from .serializers import FileUploadSerializer
from .serializers import AnalysisResultSerializer

from nugunyaneon import voice as v

# 사용자로부터 데이터 받기
@api_view(['GET', 'POST'])
def uploadAPI(request):
    # 들어온 신호가 POST일 때,
    if request.method == "POST":
        serializer = FileUploadSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            # FileUploadSerializer에 맞게 직렬화
            return Response(serializer.data, status=status.HTTP_201_CREATED)
    # 들어온 신호가 POST가 아닐 때,
    else:
        return Response('GET')

# 분석 결과 전달
@api_view(['GET'])
def analysisAPI(request):
    testFile_path = "./nugunyaneon/test_media/test.mp3"
    result = v.Voice(testFile_path).result()
    #result = v.Voice(testFile_path).test()
    # 직렬화해서 보내야 함.
    return Response(result)


# Create your views here.
# 실제로 뒤에서 움직일 파이썬 코드
# 여기에 모델 불러오고, 분석하고 분석 결과를 뿌려주는 것까지(get)