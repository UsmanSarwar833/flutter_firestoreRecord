import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

import '../../../../../app_providers/record_provider.dart';
import '../../../../../dependency_injection.dart';


class NewRecording extends StatefulWidget {
  const NewRecording({super.key});

  @override
  State<NewRecording> createState() => _NewRecordingState();
}

class _NewRecordingState extends State<NewRecording> {
  final AudioRecorder recorder = AudioRecorder();
  bool isRecording = false;
  final recordProvider = sl<RecordProvider>();

  startRecording() async {
    try {
      if (await recorder.hasPermission()) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String filePath = p.join(appDir.path, "audio");

        await recorder.start(const RecordConfig(), path: filePath);
        setState(() {
          isRecording = true;
          recordProvider.setAudioPath = "";
        });
      }
    } catch (e) {
      print('Error Start Recording : $e');
    }
  }
  stopRecording() async {
    try {
      final path = await recorder.stop();
      if (path != null) {
        setState(() {
          recordProvider.setAudioPath = path.toString();
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
          isRecording = false;
        });
      }
    } catch (e) {
      print('Error Stop Recording : $e');
    }
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          isRecording
              ? const Text("Recording .....",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
              : const Text(""),
          const SizedBox(
            height: 70,
          ),
          // StreamBuilder<RecordingDisposition>(
          //     stream: recorder.,
          //     builder: (context, snapshot) {
          //       final duration =
          //       snapshot.hasData ? snapshot.data!.duration : Duration.zero;
          //       String twoDigits(int n) => n.toString().padLeft(2, '0');
          //       final twoDigitMinutes =
          //       twoDigits(duration.inMinutes.remainder(60));
          //       final twoDigitSeconds =
          //       twoDigits(duration.inSeconds.remainder(60));
          //       return Text(
          //         '$twoDigitMinutes : $twoDigitSeconds',
          //         style: const TextStyle(
          //             fontWeight: FontWeight.bold, fontSize: 20),
          //       );
          //     }),


          const SizedBox(
            height: 30,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (isRecording) {
                  stopRecording();
                } else {
                  startRecording();
                }
              },
              child: Icon(isRecording ? Icons.stop : Icons.mic),
            ),
          ),
        ],
      ),
    );
  }
}
