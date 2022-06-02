import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nugunyaneon/model/model_upload.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
                      final filePath = result.files.single.path;

                      //print_fileInfo(upload_file.file);
                      var dio = Dio();
                      var formData = FormData.fromMap(
                          {'file': await MultipartFile.fromFile(filePath!)});
                      final response =
                          await dio.post('/upload', data: formData);
                    } else {
                      // 아무런 파일도 선택되지 않음.
                    }
                  },
                  child: Text("Choose a file"),
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
              child: Scrollbar(
                child: ListView.builder(
                  itemBuilder: (BuildContext contest, int index) {
                    //return upload_file.file.name == 'default'
                    return file.name == 'default'
                        ? const ListTile(title: Text("파일을 업로드 해주세요."))
                        : ListTile(
                            title: Text(file.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {});
                              },
                            ),
                          );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.048),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  // 장고에 업로드 하는 버튼
                },
                child: Text("Upload to Django"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
