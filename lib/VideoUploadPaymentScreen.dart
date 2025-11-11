import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'VideoUpload.dart';

/// -------------------------------
/// Payment Controller
/// -------------------------------
class PaymentController extends GetxController {
  final Razorpay _razorpay = Razorpay();
  String razorpayKey = "rzp_live_mXMqD6Uq31IPNc";
  bool isPaymentDone = false;

  /// Callback to run when payment succeeds
  VoidCallback? onPaymentSuccessCallback;

  @override
  void onInit() {
    super.onInit();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void openPayment(num amount, {VoidCallback? onSuccess}) {
    onPaymentSuccessCallback = onSuccess;

    var options = {
      'key': razorpayKey,
      'amount': (amount * 100).round(), // amount in paise
      'name': 'Candid Offers',
      'description': 'One-time video upload payment',
      'timeout': 120,
      'prefill': {
        'contact': '9999999999',
        'email': 'example@email.com',
      },
      'external': {
        'wallets': ['googlepay'],
      },
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    isPaymentDone = true;
    update();

    Get.snackbar(
      'Payment Successful 🎉',
      'Redirecting to Upload Screen...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // ✅ Navigate to upload screen after success
    Future.delayed(const Duration(seconds: 1), () {
      if (onPaymentSuccessCallback != null) {
        onPaymentSuccessCallback!.call();
      }
    });
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

/// -------------------------------
/// Video Upload Payment Screen
/// -------------------------------
class VideoUploadPaymentScreen extends StatefulWidget {
  const VideoUploadPaymentScreen({super.key});

  @override
  State<VideoUploadPaymentScreen> createState() =>
      _VideoUploadPaymentScreenState();
}

class _VideoUploadPaymentScreenState extends State<VideoUploadPaymentScreen> {
  final PaymentController paymentController = Get.put(PaymentController());
  File? _uploadedVideoFile;
  VideoPlayerController? _previewController;

  void _goToUploadVideoScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UploadVideo(title: "Upload Video"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('Upload Video (One-Time Payment)'),
        backgroundColor: const Color(0xFF00BADD),
      ),
      body: Center(
        child: SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            color: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: GetBuilder<PaymentController>(
              builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (!controller.isPaymentDone) {
                            // 💳 Step 1: Payment first
                            controller.openPayment(
                              99, // ₹99 one-time payment
                              onSuccess: _goToUploadVideoScreen, // navigate after payment
                            );
                          } else {
                            // ✅ Already paid → Go directly
                            _goToUploadVideoScreen();
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.isPaymentDone
                          ? 'Payment done! Click to upload your video'
                          : 'Upload Video (₹99 per upload)',
                      style: GoogleFonts.workSans(
                        color: const Color(0xFF111827),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Max 15 MB / up to 45 sec',
                      style: GoogleFonts.workSans(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }
}
