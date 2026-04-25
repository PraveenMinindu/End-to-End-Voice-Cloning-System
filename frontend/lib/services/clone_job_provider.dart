import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/clone_job.dart';
import 'dart:html' as html;

class CloneJobProvider extends ChangeNotifier {
  // Your current ngrok URL
  final String apiUrl = 'https://written-crave-chop.ngrok-free.dev/clone/';

  CloneJob _job = const CloneJob();
  CloneJob get job => _job;

  Uint8List? _voiceBytes;
  Uint8List? _songBytes;
  String? voiceFileName;
  String? songFileName;
  int pitch = 0;

  bool get canStart =>
      _voiceBytes != null && _songBytes != null && !_job.isActive;

  void setVoiceFile(Uint8List bytes, String name) {
    _voiceBytes = bytes;
    voiceFileName = name;
    notifyListeners();
  }

  void setSongFile(Uint8List bytes, String name) {
    _songBytes = bytes;
    songFileName = name;
    notifyListeners();
  }

  void setPitch(int value) => {pitch = value, notifyListeners()};

  Future<void> startCloning() async {
    if (!canStart) return;

    _job = const CloneJob(
      status: JobStatus.uploading,
      statusLabel: 'Uploading files...',
      progress: 0.2,
    );
    notifyListeners();

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Bypass ngrok warning for the upload request
      request.headers['ngrok-skip-browser-warning'] = 'true';

      request.files.add(
        http.MultipartFile.fromBytes(
          'voice',
          _voiceBytes!,
          filename: voiceFileName,
        ),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'song',
          _songBytes!,
          filename: songFileName,
        ),
      );
      request.fields['pitch'] = pitch.toString();

      _job = _job.copyWith(
        status: JobStatus.processing,
        statusLabel: 'Cloning Voice...',
        progress: 0.6,
      );
      notifyListeners();

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(body);

        String finalUrl = data['outputUrl'];

        if (!finalUrl.contains('ngrok-skip-browser-warning')) {
          finalUrl = finalUrl.contains('?')
              ? '$finalUrl&ngrok-skip-browser-warning=true'
              : '$finalUrl?ngrok-skip-browser-warning=true';
        }

        _job = _job.copyWith(
          status: JobStatus.done,
          statusLabel: 'Done',
          progress: 1.0,
          outputUrl: finalUrl,
        );
      } else {
        _job = CloneJob(
          status: JobStatus.error,
          statusLabel: 'Failed',
          errorMessage: body,
        );
      }
      notifyListeners();
    } catch (e) {
      _job = CloneJob(
        status: JobStatus.error,
        statusLabel: 'Error',
        errorMessage: e.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> downloadResult() async {
    if (_job.outputUrl == null) return;

    html.window.open(_job.outputUrl!, '_blank');
  }

  void reset() {
    _job = const CloneJob();
    _voiceBytes = null;
    _songBytes = null;
    notifyListeners();
  }
}
