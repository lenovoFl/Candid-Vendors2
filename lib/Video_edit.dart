// import 'dart:io';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sizer/sizer.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:record/record.dart';
// import 'Controllers/Offers/CreateOfferController.dart';
// import 'Controllers/Profile/ProfileController.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: Screen3Mike2(title: 'Video Editor'),
//     debugShowCheckedModeBanner: false,
//   ));
// }
//
// class Screen3Mike2 extends StatefulWidget {
//   final String title;
//   const Screen3Mike2({Key? key, required this.title}) : super(key: key);
//
//   @override
//   State<Screen3Mike2> createState() => _Screen3Mike2State();
// }
//
// class _Screen3Mike2State extends State<Screen3Mike2> {
//   late VideoPlayerController _originalController;
//   VideoPlayerController? _trimmedController;
//   ProfileController profileController = ProfileController();
//
//   File? _originalFile;
//   File? _trimmedFile;
//   File? _mergedFile;
//
//   bool _isOriginalLoaded = false;
//   bool _isTrimmedLoaded = false;
//   bool _isProcessing = false;
//   bool _isRecording = false;
//   bool _showEditOptions = false;
//
//   double _trimStart = 0.0;
//   double _trimEnd = 0.0;
//   bool isChecked = false;
//   bool showFields = false;
//
//   late String _micAudioPath;
//   final AudioRecorder _recorder = AudioRecorder();
//
//   @override
//   void dispose() {
//     if (_isOriginalLoaded) _originalController.dispose();
//     _trimmedController?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickVideoFromGallery() async {
//     await Permission.microphone.request();
//     await Permission.storage.request();
//
//     final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if (picked == null) return;
//
//     final file = File(picked.path);
//     _originalFile = file;
//
//     _originalController = VideoPlayerController.file(file);
//     await _originalController.initialize();
//
//     setState(() {
//       _isOriginalLoaded = true;
//       _trimEnd = _originalController.value.duration.inSeconds.toDouble();
//       _trimStart = 0.0;
//       _isTrimmedLoaded = false;
//       _trimmedController?.dispose();
//       _trimmedController = null;
//       _trimmedFile = null;
//     });
//   }
//
//   Future<void> _startMicRecordingOnly() async {
//     final tempDir = await getTemporaryDirectory();
//     _micAudioPath = '${tempDir.path}/mic_audio.wav';
//
//     final hasPermission = await _recorder.hasPermission();
//     if (!hasPermission) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Microphone permission not granted')),
//       );
//       return;
//     }
//
//     await _recorder.start(
//       const RecordConfig(
//         encoder: AudioEncoder.wav,
//         bitRate: 128000,
//         sampleRate: 44100,
//       ),
//       path: _micAudioPath,
//     );
//
//     setState(() => _isRecording = true);
//   }
//
//   Future<void> _mergeAudioVideo() async {
//     final tempDir = await getTemporaryDirectory();
//     final mergedPath =
//         '${tempDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.mp4';
//
//     final cmd =
//         '-i ${_originalFile!.path} -i $_micAudioPath -filter_complex "[0:a][1:a]amix=inputs=2[aout]" -map 0:v -map "[aout]" -c:v copy -c:a aac $mergedPath';
//
//     setState(() => _isProcessing = true);
//
//     final session = await FFmpegKit.execute(cmd);
//     final rc = await session.getReturnCode();
//
//     if (ReturnCode.isSuccess(rc)) {
//       _mergedFile = File(mergedPath);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Audio merged successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to merge audio and video')),
//       );
//     }
//
//     setState(() => _isProcessing = false);
//   }
//
//   Future<void> _trimVideo() async {
//     if (_originalController.value.isPlaying) {
//       _originalController.pause();
//     }
//
//     if (_isRecording) {
//       await _recorder.stop();
//       setState(() => _isRecording = false);
//     }
//
//     await _mergeAudioVideo();
//
//     if (_mergedFile == null) return;
//
//     setState(() {
//       _isProcessing = true;
//       _isTrimmedLoaded = false;
//     });
//
//     try {
//       final tempDir = await getTemporaryDirectory();
//       final outputPath =
//           '${tempDir.path}/trimmed_${DateTime.now().millisecondsSinceEpoch}.mp4';
//
//       final cmd =
//           '-ss $_trimStart -to $_trimEnd -i ${_mergedFile!.path} -c copy $outputPath';
//
//       await FFmpegKit.executeAsync(cmd, (session) async {
//         final returnCode = await session.getReturnCode();
//
//         if (ReturnCode.isSuccess(returnCode)) {
//           _trimmedFile = File(outputPath);
//
//           if (_mergedFile != null && await _mergedFile!.exists()) {
//             await _mergedFile!.delete();
//           }
//
//           await _trimmedController?.dispose();
//           _trimmedController = VideoPlayerController.file(_trimmedFile!);
//           await _trimmedController!.initialize();
//
//           setState(() {
//             _isTrimmedLoaded = true;
//             _isProcessing = false;
//           });
//
//           await ImageGallerySaverPlus.saveFile(_trimmedFile!.path);
//         } else {
//           setState(() => _isProcessing = false);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Video trimming failed')),
//           );
//         }
//       });
//     } catch (e) {
//       setState(() => _isProcessing = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error trimming video: $e')),
//       );
//     }
//   }
//
//   Future<void> _uploadTrimmedVideo() async {
//     if (_trimmedFile == null) return;
//
//     try {
//       final fileName =
//           'trimmed_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
//       final storageRef =
//           FirebaseStorage.instance.ref().child('video/$fileName');
//
//       final uploadTask = storageRef.putFile(_trimmedFile!);
//       final snapshot = await uploadTask.whenComplete(() => null);
//
//       if (snapshot.state == TaskState.success) {
//         final downloadUrl = await snapshot.ref.getDownloadURL();
//
//         await FirebaseFirestore.instance.collection('video').add({
//           'url': downloadUrl,
//           'uploadedAt': Timestamp.now(),
//           'name': fileName,
//           'start': _trimStart,
//           'end': _trimEnd,
//           'duration': _trimEnd - _trimStart,
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Video uploaded successfully')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload failed: $e')),
//       );
//     }
//   }
//
//   Widget _buildVideoPlayer(VideoPlayerController controller) {
//     return AspectRatio(
//       aspectRatio: controller.value.aspectRatio,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           VideoPlayer(controller),
//           VideoProgressIndicator(controller, allowScrubbing: true),
//           Positioned(
//             child: FloatingActionButton(
//               mini: true,
//               onPressed: () {
//                 setState(() {
//                   controller.value.isPlaying
//                       ? controller.pause()
//                       : controller.play();
//                 });
//               },
//               child: Icon(
//                   controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                   color: Colors.white),
//               backgroundColor: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final videoDuration = _isOriginalLoaded
//         ? _originalController.value.duration.inSeconds.toDouble()
//         : 1.0;
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           widget.title,
//           style: GoogleFonts.workSans(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             letterSpacing: 1.2,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: SafeArea(
//         child: !_isOriginalLoaded
//             ? GetBuilder(
//                 init: CreateOfferController(),
//                 builder: (controller) {},
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: _pickVideoFromGallery,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue, // button color
//                       minimumSize: Size(150, 150), // button size
//                     ),
//                     child: Icon(
//                       Icons.video_library,
//                       color: Colors.white,
//                       size: 40, // make icon bigger
//                     ),
//                   ),
//                 ),
//               )
//             : Column(
//                 children: [
//                   Expanded(child: _buildVideoPlayer(_originalController)),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton.icon(
//                       icon: Icon(
//                         Icons.edit,
//                         color: Colors.white,
//                       ),
//                       label: Text(
//                         "Edit",
//                         style: GoogleFonts.workSans(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _showEditOptions = !_showEditOptions;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue, // button color
//                       ),
//                     ),
//                   ),
//                   if (_showEditOptions)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       child: Wrap(
//                         spacing: 16,
//                         children: [
//                           Column(
//                             children: [
//                               Center(
//                                 child: SizedBox(
//                                   height: 20,
//                                   width: 90,
//                                   child: Card(
//                                     color: Colors.white,
//                                     surfaceTintColor: Colors.black,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         if (controller
//                                             .selectedImages.isNotEmpty)
//                                           SizedBox(
//                                             height: 10.h,
//                                             child: ListView.builder(
//                                               scrollDirection: Axis.horizontal,
//                                               itemCount: controller
//                                                   .selectedImages.length,
//                                               itemBuilder: (context, index) {
//                                                 return Stack(
//                                                   children: [
//                                                     Container(
//                                                       margin: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 4),
//                                                       width: 40.w,
//                                                       height: 10.h,
//                                                       decoration:
//                                                           const BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: Colors.black,
//                                                       ),
//                                                       child: Image.file(
//                                                         File(controller
//                                                             .selectedImages[
//                                                                 index]
//                                                             .path),
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                     Positioned(
//                                                       top: 0,
//                                                       right: 0,
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           controller
//                                                               .removeSelectedImageAtIndex(
//                                                                   index);
//                                                         },
//                                                         child: Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(4),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             shape:
//                                                                 BoxShape.circle,
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     0.7),
//                                                           ),
//                                                           child: const Icon(
//                                                             Icons.cancel,
//                                                             color: Colors.white,
//                                                             size: 16,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             ),
//                                           )
//                                         else
//                                           Container(
//                                             width: 40,
//                                             height: 40,
//                                             decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.black,
//                                             ),
//                                             child: IconButton(
//                                               onPressed: () async {
//                                                 await controller
//                                                     .selectImagesFromLocal();
//                                               },
//                                               icon: const Icon(
//                                                 Icons.add,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         SizedBox(
//                                           height: 1.h,
//                                         ),
//                                         Text(
//                                           'Upload Image',
//                                           style: GoogleFonts.workSans(
//                                             color: Colors.black,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w700,
//                                             height: 0,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.video_library,
//                                     color: Colors.white),
//                                 onPressed: _pickVideoFromGallery,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue, // button color
//                                 ),
//                               ),
//                               Text(
//                                 "Change",
//                                 style: GoogleFonts.workSans(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.mic, color: Colors.white),
//                                 onPressed: _isProcessing
//                                     ? null
//                                     : () async {
//                                         await _startMicRecordingOnly();
//                                         _originalController.play();
//                                       },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue, // button color
//                                 ),
//                               ),
//                               Text(
//                                 "Record",
//                                 style: GoogleFonts.workSans(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.send, color: Colors.white),
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue, // button color
//                                 ),
//                               ),
//                               Text(
//                                 "Send",
//                                 style: GoogleFonts.workSans(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               RangeSlider(
//                                 min: 0,
//                                 max: videoDuration,
//                                 divisions: videoDuration.toInt(),
//                                 values: RangeValues(_trimStart, _trimEnd),
//                                 onChanged: (RangeValues values) {
//                                   setState(() {
//                                     double newStart = values.start;
//                                     double newEnd = values.end;
//                                     double duration = newEnd - newStart;
//
//                                     if (duration < 5) {
//                                       if (newEnd + (5 - duration) <=
//                                           videoDuration) {
//                                         newEnd += (5 - duration);
//                                       } else if (newStart - (5 - duration) >=
//                                           0) {
//                                         newStart -= (5 - duration);
//                                       } else {
//                                         if (newEnd + 5 <= videoDuration) {
//                                           newEnd = newStart + 5;
//                                         } else if (newStart - 5 >= 0) {
//                                           newStart = newEnd - 5;
//                                         }
//                                       }
//                                     }
//
//                                     if (duration > 45) {
//                                       newEnd = newStart + 45;
//                                       if (newEnd > videoDuration) {
//                                         newEnd = videoDuration;
//                                         newStart =
//                                             newEnd - 45 >= 0 ? newEnd - 45 : 0;
//                                       }
//                                     }
//
//                                     if (newStart >= 0 &&
//                                         newEnd <= videoDuration) {
//                                       _trimStart = newStart;
//                                       _trimEnd = newEnd;
//                                     }
//                                   });
//                                 },
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Start: ${_trimStart.toStringAsFixed(2)} s',
//                                     style: GoogleFonts.workSans(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   Text(
//                                     'End: ${_trimEnd.toStringAsFixed(2)} s',
//                                     style: GoogleFonts.workSans(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   Text(
//                                     'Duration: ${(_trimEnd - _trimStart).toStringAsFixed(2)} s',
//                                     style: GoogleFonts.workSans(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   if (_isTrimmedLoaded && _trimmedController != null) ...[
//                     const Divider(),
//                     const Text('Trimmed Video Preview',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                       'Trimmed Duration: ${_trimmedController!.value.duration.inSeconds} sec',
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                     ),
//                     Expanded(child: _buildVideoPlayer(_trimmedController!)),
//                     const SizedBox(height: 10),
//                     ElevatedButton.icon(
//                       icon: const Icon(Icons.cloud_upload,
//                           color: Colors.white, size: 30),
//                       label: Text(
//                         'Upload to Firebase',
//                         style: GoogleFonts.workSans(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                           color: Colors.white,
//                         ),
//                       ),
//                       onPressed: _uploadTrimmedVideo,
//                       style: ElevatedButton.styleFrom(
//                         minimumSize:
//                             const Size(300, 50), // width and height set here
//                         backgroundColor: Colors.blue,
//                       ),
//                     ),
//                   ]
//                 ],
//               ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:record/record.dart';

class Screen3Mike2 extends StatefulWidget {
  final String title;
  const Screen3Mike2({Key? key, required this.title, required String initialVideoPath}) : super(key: key);

  @override
  State<Screen3Mike2> createState() => _Screen3Mike2State();
}

class _Screen3Mike2State extends State<Screen3Mike2> {
  late VideoPlayerController _originalController;
  VideoPlayerController? _trimmedController;

  File? _originalFile;
  File? _trimmedFile;
  File? _mergedFile;

  bool _isOriginalLoaded = false;
  bool _isTrimmedLoaded = false;
  bool _isProcessing = false;
  bool _isRecording = false;
  bool _showEditOptions = false;

  double _trimStart = 0.0;
  double _trimEnd = 0.0;

  late String _micAudioPath;
  final AudioRecorder _recorder = AudioRecorder();

  @override
  void dispose() {
    _originalController.dispose();
    _trimmedController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideoFromGallery() async {
    await Permission.microphone.request();
    await Permission.storage.request();

    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    _originalFile = file;

    _originalController = VideoPlayerController.file(file);
    await _originalController.initialize();

    setState(() {
      _isOriginalLoaded = true;
      _trimEnd = _originalController.value.duration.inSeconds.toDouble();
      _trimStart = 0.0;
      _isTrimmedLoaded = false;
      _trimmedController?.dispose();
      _trimmedController = null;
      _trimmedFile = null;
    });
  }

  Future<void> _startMicRecordingOnly() async {
    final tempDir = await getTemporaryDirectory();
    _micAudioPath = '${tempDir.path}/mic_audio.wav';

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission not granted')),
      );
      return;
    }

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _micAudioPath,
    );

    setState(() => _isRecording = true);
  }

  Future<void> _mergeAudioVideo() async {
    final tempDir = await getTemporaryDirectory();
    final mergedPath = '${tempDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final cmd =
        '-i ${_originalFile!.path} -i $_micAudioPath -filter_complex "[0:a][1:a]amix=inputs=2[aout]" -map 0:v -map "[aout]" -c:v copy -c:a aac $mergedPath';

    setState(() => _isProcessing = true);

    final session = await FFmpegKit.execute(cmd);
    final rc = await session.getReturnCode();

    if (ReturnCode.isSuccess(rc)) {
      _mergedFile = File(mergedPath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio merged successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to merge audio and video')),
      );
    }

    setState(() => _isProcessing = false);
  }

  Future<void> _trimVideo() async {
    if (_originalController.value.isPlaying) {
      _originalController.pause();
    }

    if (_isRecording) {
      await _recorder.stop();
      setState(() => _isRecording = false);
    }

    await _mergeAudioVideo();

    if (_mergedFile == null) return;

    setState(() {
      _isProcessing = true;
      _isTrimmedLoaded = false;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/trimmed_${DateTime.now().millisecondsSinceEpoch}.mp4';

      final cmd = '-ss $_trimStart -to $_trimEnd -i ${_mergedFile!.path} -c copy $outputPath';

      await FFmpegKit.executeAsync(cmd, (session) async {
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          _trimmedFile = File(outputPath);

          if (_mergedFile != null && await _mergedFile!.exists()) {
            await _mergedFile!.delete();
          }

          await _trimmedController?.dispose();
          _trimmedController = VideoPlayerController.file(_trimmedFile!);
          await _trimmedController!.initialize();

          setState(() {
            _isTrimmedLoaded = true;
            _isProcessing = false;
          });

          await ImageGallerySaverPlus.saveFile(_trimmedFile!.path);
        } else {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video trimming failed')),
          );
        }
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error trimming video: $e')),
      );
    }
  }

  Future<void> _uploadTrimmedVideo() async {
    if (_trimmedFile == null) return;

    try {
      final fileName = 'trimmed_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final storageRef = FirebaseStorage.instance.ref().child('video/$fileName');

      final uploadTask = storageRef.putFile(_trimmedFile!);
      final snapshot = await uploadTask.whenComplete(() => null);

      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('video').add({
          'url': downloadUrl,
          'uploadedAt': Timestamp.now(),
          'name': fileName,
          'start': _trimStart,
          'end': _trimEnd,
          'duration': _trimEnd - _trimStart,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video uploaded successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  Widget _buildVideoPlayer(VideoPlayerController controller) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(controller),
          VideoProgressIndicator(controller, allowScrubbing: true),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  controller.value.isPlaying ? controller.pause() : controller.play();
                });
              },
              child: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoDuration = _isOriginalLoaded ? _originalController.value.duration.inSeconds.toDouble() : 1.0;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: _isOriginalLoaded
            ? Column(
          children: [
            Expanded(child: _buildVideoPlayer(_originalController)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text("Edit"),
                onPressed: () {
                  setState(() {
                    _showEditOptions = !_showEditOptions;
                  });
                },
              ),
            ),
            if (_showEditOptions)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 16,
                  children: [
                    Column(
                      children: [
                        IconButton(icon: Icon(Icons.video_library), onPressed: _pickVideoFromGallery),
                        Text("Change", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: _isProcessing
                              ? null
                              : () async {
                            await _startMicRecordingOnly();
                            _originalController.play();
                          },
                        ),
                        Text("Record", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(icon: Icon(Icons.save_alt), onPressed: _isProcessing ? null : _trimVideo),
                        Text("Save", style: TextStyle(fontSize: 12)),
                      ],
                    ),

                    Column(
                      children: [
                        RangeSlider(
                          min: 0,
                          max: videoDuration,
                          divisions: videoDuration.toInt(),
                          values: RangeValues(_trimStart, _trimEnd),
                          onChanged: (RangeValues values) {
                            setState(() {
                              if (values.start < values.end) {
                                _trimStart = values.start;
                                _trimEnd = values.end;
                              }
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Start: ${_trimStart.toStringAsFixed(2)} s'),
                            Text('End: ${_trimEnd.toStringAsFixed(2)} s'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (_isTrimmedLoaded && _trimmedController != null) ...[
              const Divider(),
              const Text('Trimmed Video Preview', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Trimmed Duration: ${_trimmedController!.value.duration.inSeconds} sec',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Expanded(child: _buildVideoPlayer(_trimmedController!)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('set'),
                onPressed: _uploadTrimmedVideo,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              ),
            ]
          ],
        )
            : Center(
          child: ElevatedButton(
            child: Image.network(
              "https://static.vecteezy.com/system/resources/previews/035/784/501/non_2x/gallery-icon-isolated-on-white-background-vector.jpg",
              height: 200,
              width: 200,
            ),
            onPressed: _pickVideoFromGallery,
          ),
        ),
      ),
    );
  }
}
