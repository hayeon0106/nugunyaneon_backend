import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nugunyaneon/model/model_upload.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
                        await FilePicker.platform.pickFiles();

//----------------- 음성 파일 입력 받는 부분 -----------------//
// file 변수에 있는 데이터를 백에서 처리
                    if (result != null) {
                      //upload_file.file = result.files.first;
                      file = result.files.single;
                      print(result.files.single);

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
                  // 장고에 업로드 하는 버튼
                },
                child: Text("분석"),
              ),
            )
          ],
        ),
      ),
    );
  }

  postFile(PlatformFile file) async {
    final url = 'http://127.0.0.1:8000/nugunyaneon/upload/';

    FormData formData = FormData.fromMap({
      "file": file,
    });

    var dio = new Dio();

    try {
      var response = await dio.post(
        url,
        data: formData,
      );

      print("응답" + response.data.toString());
    } catch (eee) {
      print(eee);
      //print(eee);
      //print("error occur");
    }
  }
}
