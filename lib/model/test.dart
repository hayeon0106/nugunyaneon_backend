import 'package:flutter/material.dart';
//import 'dice.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
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
                          //TextField(
                          //  controller: controller,
                          //  decoration: InputDecoration(
                          //    labelText: "귀하의 '연령대'를 입력해주세요. 예. 30"
                          //  ),
                          //  keyboardType: TextInputType.text,
                          //),

                          DropdownButton(
                              value: _selectedValue,
                              items: _valueList
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value.toString()),
                                      )) // map
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue = value.toString();
                                  print(_selectedValue);
                                });
                              }),
/*
                          TextField(
                            controller: controller2,
                            decoration: InputDecoration(
                                labelText: "귀하의 '거주 중인 지역'을 입력해주세요. 예. 서울"),
                            keyboardType: TextInputType.text,
                            //  obscureText: true,   거주 중인 지역이 * 값으로 출력
                          ),

                          // 버튼
                          SizedBox(
                            height: 40.0,
                          ), // 버튼이 너무 텍스트에 붙어 있어서 띄움
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: RaisedButton(
                                color: Colors.blueAccent,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                onPressed: () {
                                  //정보 입력 후 버튼 눌렀을 때,
                                }),
                          ),
*/
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
} // class
