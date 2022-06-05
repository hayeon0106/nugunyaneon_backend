from django.shortcuts import redirect, render

#---------- API 통신을 위한 패키지 ----------
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import Nugunyaneon
from .serializers import NugunyaneonSerializer

#from nugunyaneon import Voice

88
# get은 데이터를 얻는 것.
@api_view(['POST'])
def uploadAPI(request):
    if request.method == "POST":
        serializer = NugunyaneonSerializer(request.POST)
        if serializer.is_valid():
            file = serializer.save(commit=False)
            # DB에 데이터 저장
            file.save()
            # redirect에 전달된 페이지로 이동
            return redirect()
    else:
        return

@api_view(['GET'])
def helloAPI(request):
    file = Nugunyaneon.objects.only()
    #print(Nugunyaneon.objects.all())
    serializer = NugunyaneonSerializer(file)
    print("file: ", file, "serializer.data: ", serializer.data)
    return Response(serializer.data)


# Create your views here.
# 실제로 뒤에서 움직일 파이썬 코드
# 여기에 모델 불러오고, 분석하고 분석 결과를 뿌려주는 것까지(get)


# DB에 올리는 코드