import 'dart:typed_data';
import 'package:candid_vendors/Controllers/HomeScreenController.dart';
import 'package:candid_vendors/Screens/OfferScreens/ManageScreen.dart';
import 'package:candid_vendors/Screens/QRDataScreen.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({Key? key}) : super(key: key);
  final widthFactor = 0.90;

  @override
  Widget build(BuildContext context) {
    final MobileScannerController cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal, // Set to normal for faster response
      facing: CameraFacing.back,
      returnImage: true,
    );

    Future<void> showScanQRView(HomeScreenController homeController) async {
      homeController.changeCanShowQRData(true);

      showGeneralDialog(
        context: navigatorKey.currentContext!,
        transitionBuilder: (context, a1, a2, child) {
          var curve = Curves.easeInOut.transform(a1.value);
          return Transform.scale(
            scale: curve,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      fit: BoxFit.contain,
                      controller: cameraController,
                      onDetect: (capture) async {
                        final List<Barcode> barcodes = capture.barcodes;
                        final Uint8List? image = capture.image;

                        if (homeController.canShowQRData) {
                          homeController.changeCanShowQRData(false);
                          await cameraController.stop(); // Stop the camera as soon as the scan is detected
                          Navigator.of(navigatorKey.currentContext!).pop(); // Close the QR scanner
                          await Navigator.of(navigatorKey.currentContext!).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => QRDataScreen(
                                image: image,
                                barcodes: barcodes,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconButton(
                          //   color: Colors.white,
                          //   icon: ValueListenableBuilder(
                          //     valueListenable: cameraController.torchState,
                          //     builder: (context, state, child) {
                          //       return Icon(
                          //         state == TorchState.off
                          //             ? Icons.flash_off
                          //             : Icons.flash_on,
                          //         color: state == TorchState.off
                          //             ? Colors.grey
                          //             : Colors.yellow,
                          //       );
                          //     },
                          //   ),
                          //   iconSize: 32.0,
                          //   onPressed: () => cameraController.toggleTorch(),
                          // ),
                          // IconButton(
                          //   color: Colors.white,
                          //   icon: ValueListenableBuilder(
                          //     valueListenable: cameraController.cameraFacingState,
                          //     builder: (context, state, child) {
                          //       return Icon(
                          //         state == CameraFacing.front
                          //             ? Icons.camera_front
                          //             : Icons.camera_rear,
                          //       );
                          //     },
                          //   ),
                          //   iconSize: 32.0,
                          //   onPressed: () => cameraController.switchCamera(),
                          // ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300), // Reduce transition duration
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container();
        },
      );
    }

    return GetBuilder(
      init: homeScreenController,
      builder: (homeController) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SizedBox(
            height: 100.h,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500), // Reduce animation time
                    child: homeController.acceptedVendorOffer
                        ? SizedBox(
                      width: 90.w,
                      child: Column(
                        // Add any content for accepted vendor offer here
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: homeController.showManageOffers
                                  ? ManageScreen(
                                  homeController: homeController,
                                  widthFactor: widthFactor)
                                  : Column(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        showScanQRView(homeController),
                                    child: Container(
                                      height: 15.h,
                                      margin:
                                      EdgeInsets.only(top: 14.h),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(0.3),
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.qr_code_scanner,
                                        size: 80.sp,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  const Text(
                                    'Scan Customer QR\n To Accept Offers',
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Aileron',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                      letterSpacing: 0.02,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
