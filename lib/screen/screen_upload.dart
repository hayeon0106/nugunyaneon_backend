import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:nugunyaneon/model/model_file.dart';
import 'package:nugunyaneon/model/api_adapater.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key? key, required this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --------------- 데이터 변수 ---------------
  int file_id = 0; // 파일 id default
  FileInfo? data; // 받을 데이터를 저장할 공간. null 허용.
  bool isLoading = false; // 로딩 여부

  var _getData1;
  var _getData2; // 테스트
  var _getData3;

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
                      //File file2 = File(result.files.first.path.toString());
                      //print('File: ');
                      //print(file2);
                      print('PlatformFile: ');
                      print(file);

                      default_file = file;
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
                  loadData();
                  //test();
                },
                child: Text("분석"),
              ),
            ),
            Container(child: Text("getData1: " + _getData1.toString())),
            Container(child: Text("getData2: " + _getData2.toString())),
            //Container(child: Text("getData3: " + _getData3.toString())),
          ],
        ),
      ),
    );
  }

// ------------------- post 함수 -------------------
  postFile(PlatformFile file) async {
    String url = 'http://127.0.0.1:8000/nugunyaneon/test=' + file_id.toString();

    FormData formData = FormData.fromMap({
      "fileId": file_id,
      "fileName": file.name,
      "filePath": file.path,
      "file": await MultipartFile.fromFile(file.path.toString(),
          filename: file.name.toString()),
      "error": 'None',
      "probability": 1,
      "phishingType": 'None',
    });

    String file_path = file.path.toString();
    print(file_path);

    BaseOptions options = BaseOptions(
      contentType: 'multipart/form-data',
    );
    Dio dio = new Dio(options);

    try {
      var response = await dio.post(
        url,
        data: formData,
      );

      print("응답" + response.data.toString());

      // file_id 하나 증가
      file_id += 1;
    } catch (eee) {
      print(eee);
    }
  }

// ------------------- put 함수 -------------------
  updateData(PlatformFile file) async {
    Dio dio = Dio();
    print("updateData: " + file.toString());
    FormData formData = FormData.fromMap({
      "fileId": file_id - 1,
      "fileName": file.name,
      "filePath": file.path,
      "error": 'None',
      "probability": 1,
      "phishingType": 'None',
    });

    final response = await dio.put(
        'http://127.0.0.1:8000/nugunyaneon/test=' + (file_id - 1).toString(),
        data: formData);
    if (response.statusCode == 200) {
      print('updateData result: ' + response.toString());
      setState(() {
        // json으로 변환해주는 코드가 필요한 듯 하다...
        //data = parseFile(utf8.decode(response.data));
        _getData1 = response.data.toString();
      });
    } else {
      throw Exception('failed to load data');
    }
  }

// ------------------- load 함수 -------------------
  loadData() async {
    Dio dio = Dio();

    final response = await dio.get(
        'http://127.0.0.1:8000/nugunyaneon/test=' + (file_id - 1).toString());
    if (response.statusCode == 200) {
      print("loadData: " + response.toString());
      setState(() {
        // json으로 변환해주는 코드가 필요한 듯 하다...
        _getData2 = response;
      });
    } else {
      throw Exception('failed to load data');
    }
  }

  test() async {
    Dio dio = Dio();

    final response =
        await dio.get('http://127.0.0.1:8000/nugunyaneon/analysisAPI/');
    if (response.statusCode == 200) {
      print("test: " + response.toString());
      setState(() {
        // json으로 변환해주는 코드가 필요한 듯 하다...
        _getData3 = response;
      });
    } else {
      throw Exception('failed to load data');
    }
  }
}
