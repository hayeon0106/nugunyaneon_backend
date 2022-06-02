import 'package:file_picker/file_picker.dart';

class Upload {
  PlatformFile file;

  //Upload({this.file});

  Upload.fromMap(Map<PlatformFile, dynamic> map) : file = map['file'];
}

void print_fileInfo(PlatformFile file) {
  print("파일 업로드");
  print(file.name); // 파일 이름
  print(file.bytes); // 바이트
  print(file.size); // 크기
  print(file.extension); // 확장자
  print(file.path); // 경로
}
