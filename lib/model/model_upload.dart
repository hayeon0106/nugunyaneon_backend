import 'package:file_picker/file_picker.dart';

class Upload {
  var file;

  Upload({this.file});

  Upload.fromMap(Map<PlatformFile, dynamic> map) : file = map['file'];
}

class Result {
  var error;
  var probability;
  var phisingType;

  Result({this.error, this.probability, this.phisingType});

  Result.fromMap(Map<String, dynamic> map)
      : error = map['error'],
        probability = map['probability'],
        phisingType = map['phisingType'];

  Result.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        probability = json['probability'],
        phisingType = json['phisingType'];
}
