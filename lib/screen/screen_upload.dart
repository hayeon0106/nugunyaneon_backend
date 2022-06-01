import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  PlatformFile file = PlatformFile(name: 'default', size: 300);

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
                    print("사진 추가");
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

//----------------- 음성 파일 입력 받는 부분 -----------------//
// file 변수에 있는 데이터를 백에서 처리
                    if (result != null) {
                      file = result.files.first;

                      print(file.name);
                      print(file.bytes);
                      print(file.size);
                      print(file.extension);
                      print(file.path);
                    } else {}
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
              child: Center(
                child: Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (BuildContext contest, int index) {
                      return file == null
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
            ),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.048),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Upload to Django"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
