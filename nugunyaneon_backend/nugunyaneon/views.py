from django.shortcuts import render

# Create your views here.
# 실제로 뒤에서 움직일 파이썬 코드
# 여기에 모델 불러오고, 분석하고 분석 결과를 뿌려주는 것까지

"""
# 음성 텍스트 변환
import speech_recognition as sr
import pyaudio
import pickle

# 형태소 분석
from konlpy.tag import Okt
import pandas as pd
okt = Okt()

from datetime import datetime
date = datetime.today().strftime('%Y_%m_%d_%H_%M')
"""


# 음성 텍스트 변환
"""
class voice:
    def __init__(self, date):
        self.r = sr.Recognizer()
        
        # 통화 음성 텍스트 변환 파일
        self.txt = date + '.txt'
        f = open(self.txt, 'w', encoding='UTF-8')
        
        # 가중치 파일 불러오기
        self.df = pd.read_csv("500_가중치.csv", encoding='utf-8')
        
    def call(self):
        self.cnt = 0 # 확률
        print('\n※ 통화 녹음 시작 ※\n')
        
        while True:
            with sr.Microphone() as source:

                try:
                    voice = self.r.listen(source, phrase_time_limit=10, timeout=5)

                    self.text = self.r.recognize_google(voice, language='ko-KR')
                    
                    self.f = open(self.txt, 'a', encoding='UTF-8')
                    self.f.write(str(self.text) + '\n')
                    
                    #print('▶ 통화내역 : {}'.format(self.text))
                    #print('\n※ 피싱 탐지 시작 ※\n')
                    
                    self.detection() # 피싱 탐지 함수 호출

                except:
                    print('\n※ 통화 종료 ※\n')
                    self.f.close()
                    
                    break
                 
    def detection(self):
        token_ko = pd.DataFrame(okt.pos(self.text))
        token_ko.columns = ['단어', '형태소']
        token_ko = token_ko[token_ko['단어'].str.len() > 1]
        token_ko = token_ko.loc[token_ko.형태소.isin(['Noun', 'Adverb']), :]

        for i in token_ko.단어.values:
            if i in self.df.단어.values:
                self.cnt += float(self.df.loc[self.df.단어 == i, '확률'])

        print('▶ 보이스피싱 확률 : {}%'.format(round(self.cnt, 2)))
"""

# 음성 녹음, 보이스피싱 확률 출력
"""
# 클래스 호출
v = voice(date)
v.call()
"""


# 분류 모델
"""
# 로컬에서 모델 처리
from keras.models import load_model
import numpy as np
import librosa

# 분류 모델 로드
model = load_model('')

# 정규화

# 분류 결과 저장
results = model.predict('파일', batch_size=1)

# 확률 벡터 결과 리스트 중 가장 큰 값을 반환한다.
y = np.argmax(resuls)
print('y = '+ y)

"""

# DB에 올리는 코드