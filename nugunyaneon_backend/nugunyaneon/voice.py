#---------- 보이스피싱 분석을 위한 패키지 ----------
# 음성 텍스트 변환
import speech_recognition as sr
import pyaudio
import pickle

# 형태소 분석
from konlpy.tag import Okt
import pandas as pd
okt = Okt()

# 인식할 수 없는 형태의 음원 파일을 변환하기 위한 모듈
from pydub import AudioSegment

# 데이터프레임 출력을 위한 모듈
from IPython.display import display

# 분석 진행상황 출력
from tqdm import tqdm

# wav 파일 길이를 가져오기
import wave
import contextlib

class Voice:    
    def __init__(self, input_file):
        self.file = input_file   # 분석을 원하는 음성 파일
        self.r = sr.Recognizer() 

        # 통화 음성 텍스트 변환 파일
        self.txt = self.file[:self.file.find('.')] + '.txt'
        self.f = open(self.txt, 'a', encoding='UTF-8')
        
        self.df = pd.read_csv("500_가중치.csv", encoding='utf-8')      # 전체 형태소 분석 (가중치) 파일 
        self.type_df = pd.read_csv("type_token.csv", encoding='utf-8') # 범죄 유형 분류 기준 단어 파일
        
        self.cnt = 1   # 보이스피싱 확률 변수
        self.text = '' # 음성에서 변환된 텍스트
        
    # 음성 파일을 wav 파일로 통일하는 함수
    def to_wav(self):
        try:
            if self.file[self.file.find('.')+1:] != 'wav':
                sound = AudioSegment.from_file(self.file) 
                self.file = self.file[:self.file.find('.')]+'.wav'
                sound.export(self.file , format="wav")  # 파일을 인식할 수 있도록 파일 형식 변환
            
            with contextlib.closing(wave.open(self.file,'r')) as f:
                frames = f.getnframes()
                rate = f.getframerate()
                duration = frames / float(rate)
                
            self.duration_list = [30]*int(duration/30) + [round(duration%30)]
                
        except:
            print('Error')
            
    # 음성을 텍스트로 변환하는 함수        
    def recognize(self):
        try:
            with sr.AudioFile(self.file) as source:
                for duration in tqdm(self.duration_list):
                    self.r.adjust_for_ambient_noise(source, duration=0.5)
                    self.r.dynamic_energy_threshold = True
                    audio = self.r.record(source, duration=duration)
                    self.text += self.r.recognize_google(audio_data=audio, language='ko-KR')
                
            print(self.text)
            
            if len(open(self.txt, 'r', encoding='UTF-8').read())==0: # 파일이 이미 있으면 담기지 않도록 함
                self.f.write(self.text)
                self.f.close()
            
        except: 
            print('Error')
            
    # 텍스트 파일을 형태소 분석하는 코드
    def detection(self):
        token_ko = pd.DataFrame(okt.pos(self.text), columns=['단어', '형태소'])
        token_ko = token_ko[(token_ko['단어'].str.len() > 1)&(token_ko.형태소.isin(['Noun', 'Adverb']))]
        
        token_dict = {} # 단어:횟수 딕셔너리 생성
            
        for i in tqdm(token_ko.단어.values):
            if i in self.df.단어.values:
                self.cnt *= float(self.df.loc[self.df.단어==i, '확률'])
                if i not in token_dict:
                    token_dict[i] = 1
                else:
                    token_dict[i] = token_dict.get(i) + 1 

        self.token_df = pd.DataFrame(zip(token_dict.keys(),token_dict.values()), columns=['의심 단어', '횟수'])
        self.token_df = self.token_df.sort_values(by='횟수', ascending=False)
    
        if self.cnt > 100:
            self.cnt = 100  # 확률이 100%를 넘겼을 경우 100으로 초기화
            
    # 유형을 분류하는 함수 
    def categorizing(self):
        self.type1_cnt = 1  # 대출사기형 확률
        self.type2_cnt = 1  # 수사기관사칭형 확률
        
        for i in self.token_df['의심 단어'].values:
            if i in self.type_df.대출사기형.values:
                self.type1_cnt *= 1
            elif i in self.type_df.수사기관사칭형.values:
                self.type2_cnt *= 1
                        
    # 결과를 출력하는 함수
    def result(self):
        self.to_wav()
        self.recognize() # 음성 텍스트 변환 함수 호출
        self.detection() # 분석 함수 호출
        print(f'▶ 보이스피싱 확률 : {self.cnt:.2f}%')
        
        # 보이스피싱 확률이 50% 이상일 때만 작동하도록 함
        if self.cnt >= 50:
            self.categorizing() # 유형 분류 함수 호출
            print(f'▶ 해당 음성이 대출사기형 보이스피싱일 확률 {self.type1_cnt}%')
            print(f'▶ 해당 음성이 수사기관사칭형 보이스피싱일 확률 {self.type2_cnt}%')
            print('▶ 보이스피싱 탐색 결과')
            display(self.token_df.head(10))

    def test(self):
        print('voice 객체 생성')