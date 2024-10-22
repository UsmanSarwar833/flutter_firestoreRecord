// import 'dart:io';
//
// import 'package:firestore_record/app_providers/record_provider.dart';
// import 'package:firestore_record/screens/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../dependency_injection.dart';
//
// class AudioRecordingScreen extends StatefulWidget {
//   const AudioRecordingScreen({super.key});
//
//   @override
//   State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
// }
//
// class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
//   final recorder = FlutterSoundRecorder();
//   bool isRecorderReady = false;
//   final recordProvider = sl<RecordProvider>();
//
//   @override
//   void initState() {
//     initRecorder();
//
//     super.initState();
//   }
//
//   Future initRecorder() async {
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Microphone permission is not granted';
//     }
//     await recorder!.openRecorder();
//     isRecorderReady = true;
//     recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
//   }
//
//   Future record() async {
//     if (!isRecorderReady) return;
//     await recorder.startRecorder(toFile: 'audio');
//     setState(() {
//       recordProvider.setAudioPath = "";
//     });
//   }
//
//   Future stop() async {
//     if (!isRecorderReady) return;
//     final path = await recorder.stopRecorder();
//
//     setState(() {
//       recordProvider.setAudioPath = path!;
//     });
//     Future.delayed(const Duration(milliseconds: 500), () {
//       Navigator.pop(context);
//     });
//   }
//
//
//
//
//   @override
//   void dispose() {
//     recorder.closeRecorder();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.3,
//           ),
//           recorder.isRecording
//               ? const Text(
//                   "Recording .....",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//                 )
//               : const Text(""),
//           const SizedBox(
//             height: 70,
//           ),
//           StreamBuilder<RecordingDisposition>(
//               stream: recorder.onProgress,
//               builder: (context, snapshot) {
//                 final duration =
//                     snapshot.hasData ? snapshot.data!.duration : Duration.zero;
//                 String twoDigits(int n) => n.toString().padLeft(2, '0');
//                 final twoDigitMinutes =
//                     twoDigits(duration.inMinutes.remainder(60));
//                 final twoDigitSeconds =
//                     twoDigits(duration.inSeconds.remainder(60));
//                 return Text(
//                   '$twoDigitMinutes : $twoDigitSeconds',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 20),
//                 );
//               }),
//           const SizedBox(
//             height: 30,
//           ),
//           Center(
//             child: ElevatedButton(
//               onPressed: () async {
//                 if (recorder.isRecording) {
//                   await stop();
//                 } else {
//                   await record();
//                 }
//               },
//               child: Icon(recorder.isRecording ? Icons.stop : Icons.mic),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
