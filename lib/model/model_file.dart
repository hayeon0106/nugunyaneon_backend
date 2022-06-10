import 'package:file_picker/file_picker.dart';

class FileInfo {
  int? fileId;
  String? fileName;
  String? filePath;
  var file;
  String? error;
  double? probability;
  String? phishingType;

  FileInfo(
      {this.fileId,
      this.fileName,
      this.filePath,
      this.file,
      this.error,
      this.probability,
      this.phishingType});

  FileInfo.fromMap(Map<String, dynamic> map)
      : fileId = map['fileId'],
        fileName = map['fileName'],
        filePath = map['filePath'],
        file = map['file'],
        error = map['error'],
        probability = map['probability'],
        phishingType = map['phishingType'];

  FileInfo.fromJson(Map<String, dynamic> json)
      : fileId = json['fileId'],
        fileName = json['fileName'],
        filePath = json['filePath'],
        file = json['file'],
        error = json['error'],
        probability = json['probability'],
        phishingType = json['phishingType'];
}
