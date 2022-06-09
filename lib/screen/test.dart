import 'package:flutter/material.dart';
//import 'dice.dart';

import 'package:dio/dio.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var _getData;
  final _valueList = [
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100'
  ];
  var _selectedValue = '10';

  TextEditingController controller = TextEditingController();
  TextEditingController controller2 =
      TextEditingController(); // 추후 dispose method를 사용해야함

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            // 키보드가 올라오면서 오버플로그 에러가 뜰때
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 50)),
                Center(
                    //child: Image(
                    //  image: AssetImage('lib/image/redlight.png'),
                    //  width: 170.0, // 이미지 크기 조절
                    //  height: 190.0,
                    //),
                    ),
                Form(
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.teal,
                        inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(
                                color: Colors.teal,
                                fontSize:
                                    15.0))), //텍스트 필드를 클릭했을때 밑줄이 굵은 색상으로 강조
                    child: Container(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                // 장고에서 데이터 받는 버튼
                                loadData();
                              },
                              child: Text("파이썬 코드 확인"),
                            ),
                          ),
                          Container(child: Text(_getData.toString()))

                          //여기까지는 전체
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }, //builder
      ),
    );
  } // build

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
} // class
