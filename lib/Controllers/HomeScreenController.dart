
import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../Services/APIs/Offers/OffersConnect.dart';


class HomeScreenController extends GetxController {
  bool isLoading = false;
  bool showManageOffers = false,
      acceptedVendorOffer = false,
      isScanQR = false,
      canShowQRData = true;
  int activeOfferIndex = 0,
      liveCount = 0,
      availableCount = 0,
      expiredCount = 0,
      totalEncashCount = 0;
  OfferStatus selectedOfferStatus = OfferStatus.live;

  List<Widget> offersTypeList = [];
  List<String> offersType = ['Live Now', 'Out of Stock', 'Expired', 'Availed Offers'],
      chartDropDownList = ['Monthly'];
  late Query<OfferHistoryColl> offersList;
  late Stream<List<OfferHistoryColl>> queryChanged;
  String selectedChartVal = "";

  changeChartDropDownSelectVal(String newSelectedChartVal) {
    selectedChartVal = newSelectedChartVal;
    update();
  }

  changeCanShowQRData(newCanShowQRData) {
    Future.delayed(
      Duration.zero,
      () => () {
        canShowQRData = newCanShowQRData;
        update();
      },
    );
  }

  void endOffer(OfferHistoryColl offer, String? selectedStatus, bool? isInStock) async {
    isLoading = true;
    update();

    Map<String, dynamic> updatedOfferData = {
      if (selectedStatus == 'Out of Stock') 'offerStatus': 'Out of Stock',
    };
    await OffersConnect().editProductOfferApi(offer: offer, updatedOfferData: updatedOfferData);
    isLoading = false;
    update();
  }

  changeAcceptedVendorOffer(bool updatedAcceptedVendorOffer) {
    acceptedVendorOffer = updatedAcceptedVendorOffer;
    update();
  }

  updateActiveOfferIndex(int index) {
    activeOfferIndex = index;
    switch (index) {
      case 0:
        selectedOfferStatus = OfferStatus.live;
        break;
      case 1:
        selectedOfferStatus = OfferStatus.outOfStock;
        break;
      case 2:
        selectedOfferStatus = OfferStatus.expired;
        break;
    }
    update();
  }

  updateManageOffers(bool val) {
    showManageOffers = val;
    update();
  }

  Map<String, double> pieChartData = {
    'Live': 0,
    'Available': 0,
    'Expired': 0,
    'Availed Offers': 0,
  };

  void updatePieChartData() {
    print("Updating pie chart data"); // Debug print
    print("localSeller: $localSeller"); // Debug print
    if (localSeller != null) {
      print("offerCount: ${localSeller!.offerCount}"); // Debug print
      pieChartData = {
        'Live ($liveCount)': liveCount.toDouble(),
        'Available (${localSeller!.offerCount ?? 0})': (localSeller!.offerCount ?? 0).toDouble(),
        'Expired ($expiredCount)': expiredCount.toDouble(),
        'Availed Offers ($totalEncashCount)': totalEncashCount.toDouble(),
      };
      print("Updated pieChartData: $pieChartData"); // Debug print
      update(); // Notify listeners if using GetX
    } else {
      print('localSeller is null');
    }
  }




  // showScanQRView() {
 //    showGeneralDialog(
 //      context: navigatorKey.currentContext!,
 //      transitionBuilder: (context, a1, a2, child) {
 //        changeCanShowQRData(true);
 //        var curve = Curves.easeInOut.transform(a1.value);
 //        final MobileScannerController cameraController = MobileScannerController(
 //            detectionSpeed: DetectionSpeed.noDuplicates,
 //            facing: CameraFacing.back,
 //            returnImage: true);
 //        return Transform.scale(
 //          scale: curve,
 //          child: SafeArea(
 //            child: Dialog(
 //              insetPadding: EdgeInsets.zero,
 //              child: SizedBox(
 //                height: double.infinity,
 //                width: double.infinity,
 //                child: Stack(
 //                  clipBehavior: Clip.none,
 //                  fit: StackFit.expand,
 //                  children: [
 //                    SizedBox(
 //                      child: MobileScanner(
 //                        fit: BoxFit.contain,
 //                        controller: cameraController,
 //                        onDetect: (capture) async {
 //                          final List<Barcode> barcodes = capture.barcodes;
 //                          final Uint8List? image = capture.image;
 //                          debugPrint('canShowQRData: $canShowQRData');
 //                          if (canShowQRData) {
 //                            changeCanShowQRData(false);
 //                            await cameraController.stop();
 //                            cameraController.dispose();
 //                            await Navigator.of(navigatorKey.currentContext!)
 //                                .pushReplacement(
 //                              MaterialPageRoute(
 //                                builder: (BuildContext context) => QRDataScreen(
 //                                  image: image,
 //                                  barcodes: barcodes,
 //                                ),
 //                              ),
 //                            );
 //                          }
 //                        },
 //                      ),
 //                    ),
 //                    Align(
 //                      alignment: Alignment.bottomCenter,
 //                      child: Row(
 //                        crossAxisAlignment: CrossAxisAlignment.center,
 //                        mainAxisAlignment: MainAxisAlignment.center,
 //                        children: [
 //                          IconButton(
 //                            color: Colors.white,
 //                            icon: ValueListenableBuilder(
 //                              valueListenable: cameraController.torchState,
 //                              builder: (context, state, child) {
 //                                switch (state) {
 //                                  case TorchState.off:
 //                                    return const Icon(Icons.flash_off,
 //                                        color: Colors.grey);
 //                                  case TorchState.on:
 //                                    return const Icon(Icons.flash_on,
 //                                        color: Colors.yellow);
 //                                }
 //                              },
 //                            ),
 //                            iconSize: 32.0,
 //                            onPressed: () => cameraController.toggleTorch(),
 //                          ),
 //                          IconButton(
 //                            color: Colors.white,
 //                            icon: ValueListenableBuilder(
 //                              valueListenable: cameraController.cameraFacingState,
 //                              builder: (context, state, child) {
 //                                switch (state) {
 //                                  case CameraFacing.front:
 //                                    return const Icon(Icons.camera_front);
 //                                  case CameraFacing.back:
 //                                    return const Icon(Icons.camera_rear);
 //                                }
 //                              },
 //                            ),
 //                            iconSize: 32.0,
 //                            onPressed: () => cameraController.switchCamera(),
 //                          ),
 //                        ],
 //                      ),
 //                    ),
 //                    Positioned(
 //                      right: 0.0,
 //                      child: InkResponse(
 //                        onTap: () {
 //                          Navigator.of(context).pop();
 //                        },
 //                        child: const SizedBox(
 //                          height: 50,
 //                          width: 50,
 //                          child: CircleAvatar(
 //                            backgroundColor: Colors.transparent,
 //                            child: Icon(
 //                              Icons.close,
 //                              color: Colors.white,
 //                            ),
 //                          ),
 //                        ),
 //                      ),
 //                    ),
 //                  ],
 //                ),
 //              ),
 //            ),
 //          ),
 //        );
 //      },
 //      transitionDuration: const Duration(seconds: 1),
 //      pageBuilder: (context, animation, secondaryAnimation) {
 //        return Container();
 //      },
 //    );
 //  }

  @override
  Future<void> onInit() async {
    offersList = isar.offerHistoryColls.filter().offerIDIsNotEmpty().build();
    queryChanged = offersList.watch(fireImmediately: true);
    queryChanged.listen((offers) {
      activeOfferIndex = 0;
      liveCount = 0;
      availableCount = 0;
      expiredCount = 0;
      totalEncashCount = 0;
      offersTypeList = [];
      for (var offer in offers) {
        switch (offer.offerStatus) {
          case OfferStatus.live:
            liveCount++;
            break;
          case OfferStatus.available:
            availableCount++;
            break;
          case OfferStatus.expired:
            expiredCount++;
            break;
          case OfferStatus.totalEncash:
            totalEncashCount++;
            break;
          case OfferStatus.outOfStock:
            break;
          case OfferStatus.created:
            break;
          case OfferStatus.rejected:
            break;
        }
      }
      for (int i = 0; i <= 4; i++) {
        offersTypeList.add(i != 0
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          i == 1
                              ? liveCount.toString()
                              : i == 2
                                  ? availableCount.toString()
                                  : i == 3
                                      ? expiredCount.toString()
                                      : i == 4
                                          ? totalEncashCount.toString()
                                          : 'NAN',
                          textScaleFactor: 2,
                          style: const TextStyle(
                              color: Colors.pink, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Text(
                          i == 1
                              ? 'LIVE'
                              : i == 2
                                  ? 'AVAILABLE'
                                  : i == 3
                                      ? 'EXPIRED'
                                      : i == 4
                                          ? 'TOTAL\n ENCASH'
                                          : 'NAN',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: i != 4,
                    child: VerticalDivider(
                      color: Colors.pink.shade900,
                    ),
                  ),
                ],
              )
            : RotatedBox(
                quarterTurns: 3,
                child: Container(
                    padding: EdgeInsets.only(left: 5.h),
                    color: Colors.pink,
                    child: const Text(
                      'OFFERS',
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 1.5,
                    ))));
      }

      // Call the data update function for the pie chart
      updatePieChartData();
    });
    selectedChartVal = chartDropDownList.first;
    update();
    super.onInit();
  }
}
