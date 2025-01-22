import 'dart:io';

import '../../../../core/constants/app_assets.dart';

class DocModel {
  String? extension;
  String? fileName;

  double? totalSize;
  // int totalPages;
  //Uint8List? firstPageBytes;

  File? doc;
  String? link;

  // Constructor.. used When uploading file
  DocModel({
    this.doc,
    this.link,
    this.totalSize,
    this.fileName,
    this.extension,
  }) {
    if (doc != null) {
      fileName = Platform.isIOS || Platform.isAndroid
          ? doc!.path.split('/').last
          : doc!.path.split('\\').last;
      extension = fileName!.split('.').last;
      totalSize = doc!.lengthSync() / (1024 * 1024);
    }
  }

  // Static constants for keys
  static const String fieldTotalSize = 'Total_Size';
  static const String fieldExtension = 'Extension';
  static const String fieldLink = 'Link';
  static const String fieldFileName = 'File_Name';

  // To Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldTotalSize: totalSize,
      fieldExtension: extension,
      fieldFileName: fileName,
    };
  }

  factory DocModel.fromMap(Map<String, dynamic> map) => DocModel(
        link: map[fieldLink],
        totalSize: map[fieldTotalSize],
        extension: map[fieldExtension],
        fileName: map[fieldFileName],
      );

  String getExstensionImage() {
    if (fileName!.split('.').last == 'pdf') {
      return AppAssets.pdf;
    }
    return AppAssets.text;
  }
}
