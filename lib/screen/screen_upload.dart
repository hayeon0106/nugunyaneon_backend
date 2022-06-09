import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';

// 업로드
int file_id = 0;

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key? key, required this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 파일을 저장할 공간
  // 아래 변수를 모델에 생성한 클래스 객체로 생성하기
  //Upload upload_file = Upload();
  var _getData;
  PlatformFile file = PlatformFile(name: 'defualt', size: 0);

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
            Padding(
              padding: EdgeInsets.all(width * 0.024),
            ),
            Container(
              padding: EdgeInsets.only(bottom: width * 0.036),
              child: Center(
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
                      //upload_file.file = result.files.first;
                      PlatformFile file = result.files.single;
                      File file2 = File(result.files.first.path.toString());
                      print('File: ');
                      print(file2);
                      print('PlatformFile: ');
                      print(file);

                      postFile(file);
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
                height: 500,
                child: Text(file.name)),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.048),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  // 분석 결과 받기
                  loadData();
                },
                child: Text("분석"),
              ),
            ),
            Container(child: Text(_getData.toString()))
          ],
        ),
      ),
    );
  }

// post 함수
  postFile(PlatformFile file) async {
    String url = 'http://127.0.0.1:8000/nugunyaneon/upload/';

    FormData formData = FormData.fromMap({
      "file_id": file_id + 1,
      "file_name": file.name,
      "file_path": file.path
    });

    String file_path = file.path.toString();
    print(file_path);

    BaseOptions options = BaseOptions(
      contentType: 'application/x-www-form-urlencoded',
    );
    Dio dio = new Dio(options);

    try {
      var response = await dio.post(
        url,
        data: formData,
      );

      print("응답" + response.data.toString());
    } catch (eee) {
      print(eee);
    }
  }

  loadData() async {
    Dio dio = Dio();

    final response =
        await dio.get('http://127.0.0.1:8000/nugunyaneon/analysis/');
    if (response.statusCode == 200) {
      print(response);
      setState(() {
        // json으로 변환해주는 코드가 필요한 듯 하다...
        _getData = response.toString();
      });
    } else {
      throw Exception('failed to load data');
    }
  }
}
