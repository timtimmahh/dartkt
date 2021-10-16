import 'dart:io';

import 'package:dartkt/src/string_extension.dart';

enum DownloadState { Start, Progress, Complete, Error }

class DownloadInfo {
  DownloadState state;
  int position = 0;
  int filesize = 0;
  String? error;

  DownloadInfo.error(this.state, this.error);

  DownloadInfo(this.state, this.position, this.filesize);
}

Future<bool> download(String url, String localFile,
    [void Function(DownloadInfo info)? callback]) async {
  var fTmp = File(localFile);
  if (fTmp.existsSync()) {
    fTmp.deleteSync();
  }
  var strFolder = localFile.substringBeforeLast('/');
  var fFolder = Directory(strFolder);
  if (!fFolder.existsSync()) {
    fFolder.createSync(recursive: true);
  }

  var isDownloadSuccess = true;
  try {
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 15);

    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();
    var filesize = response.contentLength;
    if (callback != null) callback(DownloadInfo(DownloadState.Start, 0, filesize));
    var fileOut = File('$localFile.tmp');
    if (fileOut.existsSync()) {
      fileOut.deleteSync();
    }

    var position = 0;

    response.listen((data) {
      var count = data.length;
      try {
        fileOut.writeAsBytesSync(data, mode: FileMode.append);
        position += count;
        if (callback != null) {
          callback(DownloadInfo(DownloadState.Progress, position, filesize));
        }
      } on Exception catch (exception) {
        if (callback != null) {
          callback(DownloadInfo.error(DownloadState.Error, exception.toString()));
        }
      }
    }, onDone: () {
      fileOut.renameSync(localFile);
      if (callback != null) {
        callback(DownloadInfo(DownloadState.Complete, 0, filesize));
      }
    }, onError: (error) {
      isDownloadSuccess = false;
      if (callback != null) {
        callback(DownloadInfo.error(DownloadState.Error, error.toString()));
      }
    }, cancelOnError: true);
  } on Error catch (error) {
    print(error);
    isDownloadSuccess = false;
    if (callback != null) {
      callback(DownloadInfo.error(DownloadState.Error, error.toString()));
    }
  } on Exception catch (exception) {
    print(exception);
    isDownloadSuccess = false;
    if (callback != null) {
      callback(DownloadInfo.error(DownloadState.Error, exception.toString()));
    }
  }
  return isDownloadSuccess;
}
