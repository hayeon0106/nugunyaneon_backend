import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key? key, required this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --------------- 데이터 변수 ---------------
  int file_id = 0; // 파일 id default
  //bool isLoading = false; // 로딩 여부

  List<String> tmpList = []; // 데이터를 map으로 변경하기 위한 임시 리스트
  Map<String, dynamic> dataMap = {}; // 분석한 데이터를 저장할 map

  var analysisData; // 분석 결과를 받아올 String 객체

  PlatformFile default_file = PlatformFile(name: 'defualt', size: 0);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double width = screenSize.width;
    double height = screenSize.height;

    var center = TextAlign.center;

    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Padding(
            //padding: EdgeInsets.all(width * 0.024),
            //),
            Container(
              padding: EdgeInsets.only(bottom: width * 0.036),
              child: Center(
//----------------- 파일 픽커 버튼 -----------------//
                child: ElevatedButton(
                  onPressed: () async {
                    print("파일 추가");
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      // 업로드 가능한 파일 확장자
                      allowedExtensions: ['mp3', 'wav', 'm4a'],
                    );

//----------------- 음성 파일 입력 받는 부분 -----------------//
// file 변수에 있는 데이터를 백에서 처리
                    if (result != null) {
                      PlatformFile file = result.files.single;
                      // 파일 정보 로그
                      print('PlatformFile: ');
                      print(file);

                      // 받아온 파일을 defualt_file에 저장
                      default_file = file;
                      // 파일 정보 로그
                      postFile(default_file);
                      print(default_file);
                    } else {
                      // 아무런 파일도 선택되지 않음.
                    }
                  },
                  child: Text("파일 선택"),
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                ),
                width: 350,
                height: 200,
                child: Text(default_file.name)),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.048),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  // 분석 결과 받기
                  updateData(default_file);
                },
                child: Text("분석"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.048),
            ),

//----------------- 보이스피싱 확률 -----------------//
            Container(
                child: Text(
                    "보이스피싱 확률: " + dataMap['probability'].toString() == null
                        ? "null"
                        : dataMap['probability'].toString())),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.048),
            ),

//----------------- 보이스피싱 유형 -----------------//
            Container(
                child: Text(
                    "보이스피싱 유형: " + dataMap['phishingType'].toString() == null
                        ? "null"
                        : dataMap['phishingType'].toString())),
            //Container(child: Text("분석 결과(push): " + analysisData.toString())),
          ],
        ),
      ),
    );
  }

// ============================ 전송 함수 ============================ //
// ------------------- post 함수(데이터 업로드) -------------------
  postFile(PlatformFile file) async {
    // 데이터를 업로드할 url
    String url =
        'http://127.0.0.1:8000/nugunyaneon/analysis=' + file_id.toString();

    print("데이터 업로드 실행");

    // 업로드 할 데이터
    FormData formData = FormData.fromMap({
      "fileId": file_id,
      "fileName": file.name,
      "filePath": file.path,
      "file": await MultipartFile.fromFile(file.path.toString(),
          filename: file.name.toString()),
      "error": 'None',
      "probability": 1,
      "phishingType": 'None',
      "isAllowed": true,
    });

    // 로그
    //String file_path = file.path.toString();
    //print(file_path);

    // dio 옵션
    BaseOptions options = BaseOptions(
      contentType: 'multipart/form-data',
    );

    Dio dio = new Dio(options);

    // 업로드
    try {
      var response = await dio.post(
        url,
        data: formData,
      );

      print("응답: " + response.data.toString());

      // file_id 하나 증가
      file_id += 1;
    } catch (eee) {
      print(eee);
    }
  }

// ------------------- put 함수(데이터 업데이트) -------------------
  updateData(PlatformFile file) async {
    Dio dio = Dio();

    // 로그
    // print("업데이트 할 데이터: " + file.toString());
    print("분석 실행");

    // 업데이트 할 데이터
    FormData formData = FormData.fromMap({
      "fileId": file_id - 1,
      "fileName": file.name,
      "filePath": file.path,
      "error": 'None',
      "probability": 1,
      "phishingType": 'None',
      "isAllowed": true,
    });

    // 업데이트 후 결과 반환
    final response = await dio.put(
        'http://127.0.0.1:8000/nugunyaneon/analysis=' +
            (file_id - 1).toString(),
        data: formData);

    // 오류가 없을 경우
    if (response.statusCode == 200) {
      // 로그
      //print('업데이트 결과: ' + response.toString());

      // 데이터 가져온다.
      setState(() {
        analysisData = response.data.toString(); // 분석 결과
        usedData(); // 데이터 사용을 위한 전처리
        print(analysisData);
        //print(dataMap['isAllowed'].toString() == null
        //    ? "null"
        //    : dataMap['isAllowed'].toString());
        //print(dataMap['words'].toString() == null
        //    ? "null"
        //    : dataMap['words'].toString());
        print("분석 완료");
      });
    }
    // 오류 났을 경우
    else {
      throw Exception('failed to load data');
    }
  }

// ============================ 그 외 함수 ============================ //
  // 데이터를 사용하기 위한 전처리 함수
  usedData() {
    tmpList = spliteData(analysisData);
    makeMap(tmpList, dataMap);
  }

  // String으로 가져온 데이터를 ,(콤마)를 기준으로 분리
  List<String> spliteData(String data) {
    // 앞 뒤 {} 제거
    data = data.replaceAll('{', "");
    data = data.replaceAll('}', "");

    // 콤마로 구분해서 리턴
    return data.split(',');
  }

  // List<String>으로 만들어진 데이터를 Map으로 만드는 함수
  makeMap(List<String> data, Map<String, dynamic> map) {
    // for 루프를 돌면서 리스트에 담긴 데이터에 접근
    for (int i = 0; i < data.length; i++) {
      // 리스트에 담긴 데이터를 :를 기준으로 분리
      List<String> tmp_data = data[i].split(':');

      // 로그
      //print(tmp_data);

      // 분리한 데이터에서 양쪽 공백을 제거한 후에 Map에 담는다.
      map[tmp_data[0].trim()] = tmp_data[1];
    }
  }

// ============================ 테스트 함수 ============================ //

// ------------------- load 함수 -------------------
  // loadData() async {
  //   Dio dio = Dio();
  //   final response = await dio.get(
  //       'http://127.0.0.1:8000/nugunyaneon/test=' + (file_id - 1).toString());
  //   if (response.statusCode == 200) {
  //     print("loadData: " + response.toString());
  //     setState(() {
  //       // json으로 변환해주는 코드가 필요한 듯 하다...
  //       _getData2 = response;
  //     });
  //   } else {
  //     throw Exception('failed to load data');
  //   }
  // }
  // test() async {
  //   Dio dio = Dio();
  //   final response =
  //       await dio.get('http://127.0.0.1:8000/nugunyaneon/analysisAPI/');
  //   if (response.statusCode == 200) {
  //     print("test: " + response.toString());
  //     setState(() {
  //       // json으로 변환해주는 코드가 필요한 듯 하다...
  //       _getData3 = response;
  //     });
  //   } else {
  //     throw Exception('failed to load data');
  //   }
  // }
}
