import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

extension KTFileExtension on File {
  String fileHash({String alg = 'md5'}) {
    var content = readAsBytesSync();
    Digest digest;
    switch (alg.toLowerCase()) {
      case 'sha1':
        digest = sha1.convert(content);
        break;
      case 'sha256':
        digest = sha256.convert(content);
        break;
      case 'sha512':
        digest = sha512.convert(content);
        break;
      default:
        digest = md5.convert(content);
        break;
    }
    return hex.encode(digest.bytes);
  }

  String get md5sha1 => fileHash(alg: 'MD5') + fileHash(alg: 'SHA1');
}

void fileWalk(String basePath, void Function(File file) block) {
  var f = Directory(basePath);
  f.listSync().forEach((it) {
    if (it is Directory) {
      fileWalk(it.path, block);
    } else if (it is File) {
      block(it);
    }
  });
}
