// import 'dart:io';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:record/record.dart';
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
//   bool _isUploaded = false;
//
//   double _trimStart = 0.0;
//   double _trimEnd = 0.0;
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
//           /// ✅ Directly upload to Firebase after trimming
//           await _uploadTrimmedVideo();
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
//         await _trimmedController?.dispose();
//         _trimmedController = VideoPlayerController.file(_trimmedFile!);
//         await _trimmedController!.initialize();
//
//         setState(() {
//           _isUploaded = true;
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
//   Future<void> removeUploadedVideo() async {
//     if (_trimmedFile != null && await _trimmedFile!.exists()) {
//       await _trimmedFile!.delete();
//     }
//     setState(() {
//       _trimmedFile = null;
//       _isTrimmedLoaded = false;
//       _isUploaded = false;
//     });
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
//         child: !_isOriginalLoaded && !_isUploaded
//             ? Center(
//                 child: ElevatedButton(
//                   onPressed: _pickVideoFromGallery,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     minimumSize: Size(150, 150),
//                   ),
//                   child: Icon(
//                     Icons.video_library,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                 ),
//               )
//             : _isUploaded
//                 ? Stack(
//                     children: [
//                       Center(
//                         child: _trimmedFile != null
//                             ? _buildVideoPlayer(_trimmedController!)
//                             : const Text('No video'),
//                       ),
//                       Positioned(
//                         top: 10,
//                         right: 10,
//                         child: IconButton(
//                           icon: Icon(Icons.close, color: Colors.red, size: 30),
//                           onPressed: removeUploadedVideo,
//                         ),
//                       )
//                     ],
//                   )
//                 : Column(
//                     children: [
//                       Expanded(child: _buildVideoPlayer(_originalController)),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ElevatedButton.icon(
//                           icon: Icon(Icons.edit, color: Colors.white),
//                           label: Text(
//                             "Edit",
//                             style: GoogleFonts.workSans(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _showEditOptions = !_showEditOptions;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                           ),
//                         ),
//                       ),
//                       if (_showEditOptions)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 8),
//                           child: Wrap(
//                             spacing: 16,
//                             children: [
//                               Column(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.video_library,
//                                         color: Colors.white),
//                                     onPressed: _pickVideoFromGallery,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Change",
//                                     style: GoogleFonts.workSans(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.mic, color: Colors.white),
//                                     onPressed: _isProcessing
//                                         ? null
//                                         : () async {
//                                             await _startMicRecordingOnly();
//                                             _originalController.play();
//                                           },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Record",
//                                     style: GoogleFonts.workSans(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.save_alt,
//                                         color: Colors.white),
//                                     onPressed:
//                                         _isProcessing ? null : _trimVideo,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Save & Upload",
//                                     style: GoogleFonts.workSans(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   IconButton(
//                                     icon:
//                                         Icon(Icons.filter, color: Colors.white),
//                                     onPressed: () {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                               content: Text(
//                                         "Filter feature coming soon",
//                                         style: GoogleFonts.workSans(),
//                                       )));
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                     ),
//                                   ),
//                                   Text("Filter",
//                                       style: GoogleFonts.workSans(
//                                           fontSize: 15,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600)),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart'; // if you use Sizer for responsive units

class VideoPickerScreen extends StatefulWidget {
  const VideoPickerScreen({super.key});

  @override
  State<VideoPickerScreen> createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  final List<XFile> selectedVideos = [];
  final List<VideoPlayerController> videoControllers = [];

  Future<void> selectVideosFromLocal() async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      selectedVideos.add(picked);
      final controller = VideoPlayerController.file(File(picked.path));
      await controller.initialize();
      controller.setLooping(true);
      controller.play();
      videoControllers.add(controller);
      setState(() {});
    }
  }

  Future<void> initializeVideoPlayer(int index) async {
    if (!videoControllers[index].value.isInitialized) {
      await videoControllers[index].initialize();
    }
  }

  void removeSelectedVideoAtIndex(int index) {
    videoControllers[index].dispose();
    videoControllers.removeAt(index);
    selectedVideos.removeAt(index);
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void openFullScreen(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) {
        final fullController =
        VideoPlayerController.file(File(selectedVideos[index].path));
        return FutureBuilder(
          future: fullController.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              fullController.play();
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: fullController.value.aspectRatio,
                        child: VideoPlayer(fullController),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: MediaQuery.of(context).size.width / 2 - 30,
                      child: IconButton(
                        icon: Icon(
                          fullController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            if (fullController.value.isPlaying) {
                              fullController.pause();
                            } else {
                              fullController.play();
                            }
                          });
                        },
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          fullController.dispose();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 20.h,
          width: 90.w,
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedVideos.isNotEmpty)
                  SizedBox(
                    height: 10.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedVideos.length,
                      itemBuilder: (context, index) {
                        final videoController = videoControllers[index];
                        if (!videoController.value.isPlaying) {
                          videoController.play();
                        }
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                openFullScreen(index);
                              },
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                                width: 40.w,
                                height: 10.h,
                                child: AspectRatio(
                                  aspectRatio:
                                  videoController.value.aspectRatio,
                                  child: VideoPlayer(videoController),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (videoController.value.isPlaying) {
                                      videoController.pause();
                                    } else {
                                      videoController.play();
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  child: Icon(
                                    videoController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  removeSelectedVideoAtIndex(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await selectVideosFromLocal();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 1.h,
                ),
                const Text(
                  'Upload Video',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
