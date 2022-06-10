import 'dart:convert';
import 'model_file.dart';

FileInfo parseFile(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FileInfo>((json) => FileInfo.fromJson(json));
}
