// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:record/record.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// ----------------------------------------------------------
/// Razorpay Payment Controller
/// ----------------------------------------------------------
class PaymentController extends GetxController {
  final Razorpay _razorpay = Razorpay();
  String razorpayKey = "rzp_live_mXMqD6Uq31IPNc";

  @override
  void onInit() {
    super.onInit();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  /// Open direct UPI screen (Google Pay / PhonePe / Paytm)
  void openPayment(Function onSuccess) async {
    var options = {
      'key': razorpayKey,
      'amount': (99 * 100), // ₹99 payment in paise
      'name': 'Candid Offers',
      'description': 'One-time video upload payment',
      'method': 'upi',
      'timeout': 120,
      'prefill': {
        'contact': '9999999999',
        'email': 'example@email.com',
      },
      'external': {
        'wallets': ['googlepay', 'phonepe', 'paytm', 'bhim']
      },
      'theme.color': '#00BADD',
    };

    try {
      _razorpay.open(options);
      _onSuccessCallback = onSuccess;
    } catch (e) {
      debugPrint('Payment Error: $e');
      Get.snackbar(
        'Payment Error',
        'Unable to open UPI payment screen.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Function? _onSuccessCallback;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar(
      'Payment Success',
      'You can now upload your video.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    if (_onSuccessCallback != null) _onSuccessCallback!();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      'Payment Failed',
      'Please try again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}

/// ----------------------------------------------------------
/// Upload Video Screen (with UPI payment before video selection)
/// ----------------------------------------------------------
class UploadVideo extends StatefulWidget {
  final String title;
  const UploadVideo({Key? key, required this.title}) : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final PaymentController paymentController = Get.put(PaymentController());
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
  bool _paymentDone = false;

  double _trimStart = 0.0;
  double _trimEnd = 0.0;

  late String _micAudioPath;
  final AudioRecorder _recorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openPaymentBeforeVideo();
    });
  }

  /// ✅ Step 1: Payment before opening gallery
  Future<void> _openPaymentBeforeVideo() async {
    paymentController.openPayment(() async {
      setState(() => _paymentDone = true);
      await Future.delayed(const Duration(seconds: 1));
      await _pickVideoFromGallery();
    });
  }

  @override
  void dispose() {
    if (_isOriginalLoaded) _originalController.dispose();
    _trimmedController?.dispose();
    super.dispose();
  }

  // 🔹 Pick video with 15 MB size limit
  Future<void> _pickVideoFromGallery() async {
    await Permission.microphone.request();
    await Permission.storage.request();

    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);

    // 🔸 Check size (max 15 MB)
    final int fileSizeBytes = await file.length();
    final double fileSizeMB = fileSizeBytes / (1024 * 1024);
    if (fileSizeMB > 15) {
      _showSnackbar('Video size exceeds 15 MB. Please select a smaller video.');
      return;
    }

    _originalFile = file;
    _originalController = VideoPlayerController.file(file);
    await _originalController.initialize();

    final videoDuration = _originalController.value.duration.inSeconds.toDouble();
    setState(() {
      _isOriginalLoaded = true;
      _trimStart = 0.0;
      _trimEnd = videoDuration > 45 ? 45.0 : videoDuration;
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
      _showSnackbar('Microphone permission not granted');
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
    final mergedPath =
        '${tempDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final cmd =
        '-i ${_originalFile!.path} -i $_micAudioPath -filter_complex "[0:a][1:a]amix=inputs=2[aout]" -map 0:v -map "[aout]" -c:v copy -c:a aac $mergedPath';

    setState(() => _isProcessing = true);

    final session = await FFmpegKit.execute(cmd);
    final rc = await session.getReturnCode();

    if (ReturnCode.isSuccess(rc)) {
      _mergedFile = File(mergedPath);
      _showSnackbar('Audio merged successfully');
    } else {
      _showSnackbar('Failed to merge audio and video');
    }

    setState(() => _isProcessing = false);
  }

  Future<void> _trimVideo({bool withVoice = true}) async {
    if (_originalController.value.isPlaying) {
      _originalController.pause();
    }

    if (_isRecording) {
      await _recorder.stop();
      setState(() => _isRecording = false);
    }

    final trimDuration = _trimEnd - _trimStart;
    if (trimDuration < 1 || trimDuration > 45) {
      _showSnackbar('Trim duration must be between 1 and 45 seconds');
      return;
    }

    File? sourceFile;
    if (withVoice) {
      await _mergeAudioVideo();
      if (_mergedFile == null) return;
      sourceFile = _mergedFile;
    } else {
      sourceFile = _originalFile;
    }

    setState(() {
      _isProcessing = true;
      _isTrimmedLoaded = false;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath =
          '${tempDir.path}/trimmed_${DateTime.now().millisecondsSinceEpoch}.mp4';

      final cmd = '-ss $_trimStart -to $_trimEnd -i ${sourceFile!.path} -c copy $outputPath';

      await FFmpegKit.executeAsync(cmd, (session) async {
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          _trimmedFile = File(outputPath);
          await _trimmedController?.dispose();
          _trimmedController = VideoPlayerController.file(_trimmedFile!);
          await _trimmedController!.initialize();

          setState(() {
            _isTrimmedLoaded = true;
            _isProcessing = false;
          });
        } else {
          setState(() => _isProcessing = false);
          _showSnackbar('Video trimming failed');
        }
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      _showSnackbar('Error trimming video: $e');
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

        Navigator.pop(context, _trimmedFile);
      }
    } catch (e) {
      _showSnackbar('Upload failed: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF111827),
        content: Text(message, style: GoogleFonts.workSans(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_paymentDone) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF00BADD)),
        ),
      );
    }

    final videoDuration =
    _isOriginalLoaded ? _originalController.value.duration.inSeconds.toDouble() : 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.workSans(color: Colors.white)),
        backgroundColor: const Color(0xFF00BADD),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _isOriginalLoaded
            ? Column(
          children: [
            Expanded(child: _buildVideoPlayer(_originalController)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: Text("Edit", style: GoogleFonts.workSans(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BADD),
                    ),
                    onPressed: () {
                      setState(() {
                        _showEditOptions = !_showEditOptions;
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Maximum video size: 15 MB (up to 45 seconds)',
                    style: GoogleFonts.workSans(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (_showEditOptions)
              _editOptions(videoDuration),
            if (_isTrimmedLoaded && _trimmedController != null)
              _trimPreviewSection(),
          ],
        )
            : const Center(
          child: CircularProgressIndicator(color: Color(0xFF00BADD)),
        ),
      ),
    );
  }

  Widget _editOptions(double videoDuration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          _buildIconButton(Icons.data_saver_on_rounded, "Change", _pickVideoFromGallery),
          _buildIconButton(Icons.mic, "Record", _isProcessing ? null : () async {
            await _startMicRecordingOnly();
            _originalController.play();
          }),
          _buildIconButton(Icons.save_alt, "Save With Voice",
              _isProcessing ? null : () => _trimVideo(withVoice: true)),
          _buildIconButton(Icons.save_alt_sharp, "Without Voice",
              _isProcessing ? null : () => _trimVideo(withVoice: false)),
          Column(
            children: [
              RangeSlider(
                min: 0,
                max: videoDuration,
                divisions: videoDuration.toInt(),
                activeColor: const Color(0xFF00BADD),
                inactiveColor: const Color(0xFF111827),
                values: RangeValues(_trimStart, _trimEnd),
                onChanged: (RangeValues values) {
                  double start = values.start;
                  double end = values.end;
                  double duration = end - start;

                  if (duration < 1) {
                    end = start + 1;
                  } else if (duration > 45) {
                    end = start + 45 <= videoDuration ? start + 45 : videoDuration;
                  }

                  if (end <= videoDuration) {
                    setState(() {
                      _trimStart = start;
                      _trimEnd = end;
                    });
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start: ${_trimStart.toStringAsFixed(2)} s',
                      style: GoogleFonts.workSans(color: const Color(0xFF111827))),
                  Text('End: ${_trimEnd.toStringAsFixed(2)} s',
                      style: GoogleFonts.workSans(color: const Color(0xFF111827))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trimPreviewSection() {
    return Column(
      children: [
        const Divider(color: Color(0xFF00BADD)),
        Text('Trimmed Video Preview',
            style: GoogleFonts.workSans(
                fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
        Text(
          'Trimmed Duration: ${_trimmedController!.value.duration.inSeconds} sec',
          style: GoogleFonts.workSans(
              fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF111827)),
        ),
        Expanded(child: _buildVideoPlayer(_trimmedController!)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.cloud_upload, color: Colors.white),
          label:
          Text('Upload video', style: GoogleFonts.workSans(color: Colors.white)),
          onPressed: _uploadTrimmedVideo,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BADD),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    );
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
              backgroundColor: const Color(0xFF00BADD),
              mini: true,
              onPressed: () {
                setState(() {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                });
              },
              child: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback? onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: const Color(0xFF111827)),
          onPressed: onPressed,
        ),
        Text(label,
            style:
            GoogleFonts.workSans(fontSize: 12, color: const Color(0xFF111827))),
      ],
    );
  }
}
