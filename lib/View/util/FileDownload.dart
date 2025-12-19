import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'dart:typed_data';

import 'package:mm_textiles_admin/Theme/Colors.dart';



// Create a singleton settings instance
final settings = SessionSettings();

/// Public method to trigger a download
void downloadFile(String url) async {
  try {
    if (Platform.isIOS) {
      await _downloadForIOS(url);
      _showSnackbar(
          "Download Successful", 'Check Files in the download folder');
    } else {
      FileDownloader.downloadFile(
        url: url,
        downloadDestination: settings.downloadDestination,
        notificationType: settings.notificationType,
        onDownloadRequestIdReceived: (downloadId) {
          _showSnackbar("Download Started", 'Please check your notification');
          // Future.delayed(const Duration(seconds: 15), () {
          //   FileDownloader.cancelDownload(downloadId);
          // });
        },
        onDownloadCompleted: (fileNamePath) {
          debugPrint("Downloaded file path: $fileNamePath");
          _showSnackbar(
              "Download Successful", 'File downloaded to: $fileNamePath');
        },
        onDownloadError: (error) {
          _showSnackbar("Download Unsuccessful", '');
        },
      );
    }
  } catch (e) {
    _showSnackbar("Download Failed", e.toString());
  }
}



Future<void> _downloadForIOS(String url) async {
  try {
    final fileName = Uri.parse(url).pathSegments.last;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Uint8List fileBytes = response.bodyBytes;

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: fileBytes,
      fileExtension: fileName.split('.').last,
        mimeType: MimeType.other,
      );

      _showSnackbar("Download Successful", "File saved to Files app");
    } else {
      _showSnackbar("Download Failed", "Please Try Again");
   print("Server error ${response.statusCode}");
    }
  } catch (e) {
    _showSnackbar("Download Error", e.toString());
  }
}

void _showSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    icon: const Icon(FontAwesomeIcons.download),
    colorText: blackColor,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.grey,
    backgroundGradient: const LinearGradient(
      colors: [whiteColor, Color.fromARGB(255, 236, 236, 236)],
    ),
  );
}

/// Settings for file downloader session
class SessionSettings {
  static SessionSettings? _instance;
  var _notificationType = NotificationType.all;
  var _downloadDestination = DownloadDestinations.publicDownloads;
  var _maximumParallelDownloads = FileDownloader().maximumParallelDownloads;

  SessionSettings._();

  factory SessionSettings() => _instance ??= SessionSettings._();

  void setNotificationType(NotificationType notificationType) =>
      _notificationType = NotificationType.all;

  void setDownloadDestination(DownloadDestinations downloadDestination) =>
      _downloadDestination = downloadDestination;

  void setMaximumParallelDownloads(int maximumParallelDownloads) {
    if (maximumParallelDownloads <= 0) return;
    _maximumParallelDownloads = maximumParallelDownloads;
    FileDownloader.setMaximumParallelDownloads(maximumParallelDownloads);
  }

  NotificationType get notificationType => _notificationType;
  DownloadDestinations get downloadDestination => _downloadDestination;
  int get maximumParallelDownloads => _maximumParallelDownloads;
}
