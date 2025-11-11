import 'dart:io';
import 'package:candid_vendors/Controllers/Offers/CreateOfferController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import '../../Controllers/Profile/ProfileController.dart';
import '../../Services/Collections/User/VendorUserColl.dart';
import '../../VideoUpload.dart';
import '../../main.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  // get dropdownValue => dropdownValue;
  ProfileController profileController = ProfileController();
  bool isChecked = false;
  bool showFields = false;

  File? _uploadedVideoFile;
  VideoPlayerController? _previewController;

  Future<void> _navigateAndUploadVideo() async {
    final file = await Navigator.push<File>(
      context,
      MaterialPageRoute(
          builder: (_) => const UploadVideo(title: "Upload Video")),
    );

    if (file != null) {
      _uploadedVideoFile = file;
      _previewController = VideoPlayerController.file(file);
      await _previewController!.initialize();
      setState(() {});
    }
  }

  void _removeUploadedVideo() {
    setState(() {
      _previewController?.pause();
      _previewController?.dispose();
      _previewController = null;
      _uploadedVideoFile = null;
    });
  }

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: GetBuilder(
        init: CreateOfferController(),
        builder: (controller) {
          return Center(
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.95,
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // Adjust the padding as needed
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.storefront,
                                        color: Color(0xFF00BADD),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8.0),
                                      StreamBuilder<List<VendorUserColl>>(
                                        stream: isar.vendorUserColls
                                            .where()
                                            .build()
                                            .watch(fireImmediately: true),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const SizedBox();
                                          }

                                          try {
                                            VendorUserColl? user =
                                                snapshot.data?.first;

                                            // Assuming myOutlets is a List<Outlet> in VendorUserColl
                                            List<Outlet> myOutlets =
                                                user?.myOutlets ?? [];

                                            // Extract store names from the outlets and join them
                                            myOutlets
                                                .map((outlet) =>
                                                    outlet.storeName)
                                                .join(', ');

                                            return AnimatedSwitcher(
                                              duration:
                                                  const Duration(seconds: 1),
                                              child: controller.isLoading ||
                                                      snapshot.hasError ||
                                                      !snapshot.hasData
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : snapshot.data!.isEmpty
                                                      ? const Center(
                                                          child: Text(
                                                              'No User data available!'),
                                                        )
                                                      : Text(
                                                          user!
                                                              .userBusinessName,
                                                          //   ? user.myOutlets.last.storeName
                                                          //   : 'No updated store names', // Show a default message if the list is empty
                                                          style: GoogleFonts
                                                              .workSans(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 0.03,
                                                          ),
                                                        ),
                                            );
                                          } catch (error) {
                                            // Handle errors appropriately
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                      SizedBox(width: 20.w),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  '* Offer Title',
                                  style: GoogleFonts.workSans(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                TextFormField(
                                  controller: TextEditingController(
                                      text: controller.OfferName)
                                    ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                          offset: controller.OfferName.length),
                                    ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 40,
                                  maxLines: 2,
                                  textCapitalization: TextCapitalization
                                      .characters, // ensures keyboard shows caps
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText:
                                        '"Minimum 5-7 Words And Maximum 40 Characters, All Caps"',
                                    labelText: 'Offer Title',
                                  ),
                                  validator: (offerName) =>
                                      utils.validateOfferName(offerName!),
                                  onChanged: (newOfferName) {
                                    // Force uppercase
                                    final upperCaseText =
                                        newOfferName.toUpperCase();
                                    controller
                                        .updateOfferNameTxt(upperCaseText);

                                    // Optional: Update the text field if needed
                                    if (controller.OfferName != upperCaseText) {
                                      controller.OfferName = upperCaseText;
                                    }
                                  },
                                ),

                                Text(
                                  '* Product Name',
                                  style: GoogleFonts.workSans(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                TextFormField(
                                  initialValue: controller.productName,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText:
                                        '${controller.selectedOfferType == 'product' ? 'Product' : 'Service'} name',
                                    labelText:
                                        '${controller.selectedOfferType == 'product' ? 'Product' : 'Service'} name',
                                  ),
                                  maxLength: 20,
                                  validator: (productName) =>
                                      utils.validateProductName(productName!),
                                  onChanged: (productName) => controller
                                      .updateProductNameTxt(productName),
                                ),
                                Text(
                                  '* Offer Description',
                                  style: GoogleFonts.workSans(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                SizedBox(
                                  width: 95.w,
                                  height: 25.h,
                                  child: TextFormField(
                                    initialValue: controller.offerDescription,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText: 'Maximum 100 Characters',
                                        labelText: 'Offer Description'),
                                    maxLength: 100,
                                    maxLines: 10,
                                    validator: (offerDescription) =>
                                        utils.validateOfferDescription(
                                            offerDescription!),
                                    onChanged: (newOfferDescription) =>
                                        controller.updateOfferDescriptionTxt(
                                            newOfferDescription),
                                  ),
                                ),

                                Text(
                                  '* Offer Banner',
                                  style: GoogleFonts.workSans(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 22.h,
                                    width: 90.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.black, // 👈 Border color
                                          width: 1, // 👈 Border thickness
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12), // 👈 Rounded corners
                                      ),
                                      child: Card(
                                        color: Colors.white,
                                        surfaceTintColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (controller
                                                .selectedImages.isNotEmpty)
                                              SizedBox(
                                                height: 10.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: controller
                                                      .selectedImages.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Stack(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4),
                                                          width: 40.w,
                                                          height: 10.h,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.black,
                                                          ),
                                                          child: Image.file(
                                                            File(controller
                                                                .selectedImages[
                                                                    index]
                                                                .path),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                  .removeSelectedImageAtIndex(
                                                                      index);
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                              ),
                                                              child: const Icon(
                                                                Icons.cancel,
                                                                color: Colors
                                                                    .white,
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
                                                    print('📸 Add Image Button Pressed');
                                                    await controller
                                                        .selectImagesFromLocal();
                                                  },
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            SizedBox(height: 1.h),
                                            Text(
                                              'Upload Image',
                                              style: GoogleFonts.workSans(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Maximum 5 images (1 MB each)',
                                              style: GoogleFonts.workSans(
                                                color: Colors.red,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '* Offer Video',
                                  style: GoogleFonts.workSans(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                Center(
                                  child: SizedBox(
                                    height: 20.h,
                                    width: 90.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.black, // 👈 Border color
                                          width: 1, // 👈 Border thickness
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12), // same as Card radius
                                      ),
                                      child: Card(
                                        color: Colors.white,
                                        surfaceTintColor:
                                            const Color(0xFF111827),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: _uploadedVideoFile == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    "You’ll need to pay separately to upload the video.",
                                                    style: GoogleFonts.workSans(
                                                      color: Colors.red,
                                                      // backgroundColor: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black,
                                                    ),
                                                    child: IconButton(
                                                      onPressed:
                                                          _navigateAndUploadVideo,
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Upload Video',
                                                    style: GoogleFonts.workSans(
                                                      color: const Color(
                                                          0xFF111827),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Maximum video size: 15 MB (up to 45 seconds)',
                                                    style: GoogleFonts.workSans(
                                                      color: Colors.red,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _previewController!
                                                                  .value
                                                                  .isPlaying
                                                              ? _previewController!
                                                                  .pause()
                                                              : _previewController!
                                                                  .play();
                                                        });
                                                      },
                                                      child: AspectRatio(
                                                        aspectRatio:
                                                            _previewController!
                                                                .value
                                                                .aspectRatio,
                                                        child: VideoPlayer(
                                                            _previewController!),
                                                      ),
                                                    ),
                                                    VideoProgressIndicator(
                                                      _previewController!,
                                                      allowScrubbing: true,
                                                      colors:
                                                          const VideoProgressColors(
                                                        playedColor:
                                                            Color(0xFF00BADD),
                                                        backgroundColor:
                                                            Colors.black26,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 8,
                                                      right: 8,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FloatingActionButton(
                                                            heroTag:
                                                                "playpause",
                                                            mini: true,
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF00BADD),
                                                            onPressed: () {
                                                              setState(() {
                                                                _previewController!
                                                                        .value
                                                                        .isPlaying
                                                                    ? _previewController!
                                                                        .pause()
                                                                    : _previewController!
                                                                        .play();
                                                              });
                                                            },
                                                            child: Icon(
                                                              _previewController!
                                                                      .value
                                                                      .isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow,
                                                              size: 20,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          FloatingActionButton(
                                                            heroTag:
                                                                "fullscreen",
                                                            mini: true,
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF111827),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      FullScreenVideo(
                                                                    controller:
                                                                        _previewController!,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.fullscreen,
                                                              size: 20,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          FloatingActionButton(
                                                            heroTag: "delete",
                                                            mini: true,
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            onPressed:
                                                                _removeUploadedVideo,
                                                            child: const Icon(
                                                              Icons.delete,
                                                              size: 20,
                                                              color:
                                                                  Colors.white,
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
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          // TextSpan(
                                          //   text: '*',
                                          // ),
                                          TextSpan(
                                            text: '* Offer Specification ',
                                            style: GoogleFonts.workSans(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText: 'Offer Type',
                                    labelText: 'Offer Type',
                                  ),
                                  child: DropdownButton(
                                    icon: Container(),
                                    elevation: 16,
                                    style: GoogleFonts.workSans(
                                        color: Colors.deepPurple),
                                    underline: Container(),
                                    hint: const Text('Select Type'),
                                    items: controller.offersType
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: GoogleFonts.workSans(
                                                color: Colors.black)),
                                      );
                                    }).toList(),
                                    value: controller.selectedOfferType,
                                    onChanged: (type) =>
                                        controller.changeSelectedOfferType(
                                            type!), // ⚡ Type change
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                // 🔹 Category Dropdown
                                InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText: 'Category',
                                    labelText: 'Category',
                                  ),
                                  child: DropdownButton(
                                    icon: Container(),
                                    elevation: 16,
                                    style: GoogleFonts.workSans(
                                        color: Colors.deepPurple),
                                    underline: Container(),
                                    hint: const Text('Select Category'),
                                    items: controller.offersCats
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: GoogleFonts.workSans(
                                                color: Colors.black)),
                                      );
                                    }).toList(),
                                    value: controller.selectedCategory,
                                    onChanged: (cat) =>
                                        controller.changeSelectedCategory(cat!),
                                  ),
                                ),

                                SizedBox(height: 3.h),

                                // 🔹 Product / Service Name

                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    // Start Date Button (OutlinedButton)
                                                    OutlinedButton(
                                                      onPressed: controller
                                                          .selectStartDate,
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        // બટનનો બેકગ્રાઉન્ડ કલર દૂર કરવા માટે, OutlinedButton નો ઉપયોગ કરો.
                                                        // text color black કરવા માટે:
                                                        foregroundColor:
                                                            Colors.black,
                                                        side: const BorderSide(
                                                          color: Colors
                                                              .black, // બોર્ડરનો કલર
                                                          width:
                                                              1.0, // બોર્ડરની જાડાઈ
                                                        ),
                                                        minimumSize: const Size(
                                                            double.infinity,
                                                            50), // myWidgets.getLargeButton ની જેમ આખો પહોળો કરવા માટે
                                                      ),
                                                      child: const Text(
                                                        'Start Date',
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        DateFormat.yMMMMEEEEd()
                                                            .format(controller
                                                                .selectedStartDate),
                                                        style: GoogleFonts
                                                            .workSans(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    // End Date Button (OutlinedButton)
                                                    OutlinedButton(
                                                      onPressed: controller
                                                          .selectEndDate,
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        // બટનનો બેકગ્રાઉન્ડ કલર દૂર કરવા માટે, OutlinedButton નો ઉપયોગ કરો.
                                                        // text color black કરવા માટે:
                                                        foregroundColor:
                                                            Colors.black,
                                                        side: const BorderSide(
                                                          color: Colors
                                                              .black, // બોર્ડરનો કલર
                                                          width:
                                                              1.0, // બોર્ડરની જાડાઈ
                                                        ),
                                                        minimumSize: const Size(
                                                            double.infinity,
                                                            50), // myWidgets.getLargeButton ની જેમ આખો પહોળો કરવા માટે
                                                      ),
                                                      child: const Text(
                                                        'End Date',
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        DateFormat.yMMMMEEEEd()
                                                            .format(controller
                                                                .selectedEndDate),
                                                        style: GoogleFonts
                                                            .workSans(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    isDense:
                                                        true, // Added for compact layout
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      vertical: 10,
                                                      horizontal:
                                                          8, // Reduced from 16 to avoid overflow
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    hintText: 'Select Type',
                                                    labelText: 'Select Type',
                                                  ),
                                                  items: controller
                                                      .discountTypeList
                                                      .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                    (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: GoogleFonts
                                                              .workSans(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  hint: Text(
                                                    'Select Type',
                                                    style: GoogleFonts.workSans(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  value: controller
                                                      .offerDiscountType,
                                                  onChanged: (String?
                                                          newValue) =>
                                                      controller
                                                          .updateSecondDropDownValue(
                                                    newValue.toString(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          DropdownButtonFormField(
                                                        isExpanded: true,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                            horizontal: 8,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          hintText:
                                                              'Select Unit',
                                                          labelText:
                                                              'Select Unit',
                                                        ),
                                                        value: controller
                                                            .discountDropDownValue,
                                                        icon: const Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: Colors.black,
                                                        ),
                                                        items: controller
                                                            .primeDiscountLst
                                                            .map((String item) {
                                                          return DropdownMenuItem(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: GoogleFonts
                                                                  .workSans(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          controller
                                                              .updatePrimeDiscountDropDown(
                                                                  newValue!);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    // Info Icon
                                                    if (controller
                                                            .discountDropDownValue ==
                                                        'EA')
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.help_outline,
                                                          color: Colors.blue,
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: Get
                                                                .context!, // ya context ko pass karo
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Unit Info'),
                                                                content:
                                                                    const Text(
                                                                  'EA = Each\nUsed to denote individual units of a product.',
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                            'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          AnimatedSwitcher(
                                            duration:
                                                const Duration(seconds: 1),
                                            child: !controller
                                                    .showChangeInPriceVolume
                                                ? const SizedBox()
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                        width: 2.0,
                                                      ),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      isExpanded: true,
                                                      value: controller
                                                          .dropDownValue,
                                                      icon: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Colors.black,
                                                      ),
                                                      items:
                                                          controller.items.map(
                                                        (String item) {
                                                          return DropdownMenuItem(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: GoogleFonts
                                                                  .workSans(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                      onChanged: (String?
                                                              newValue) =>
                                                          controller
                                                              .updateDiscountTypeDropDown(
                                                                  newValue!),
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, top: 1),
                                                child: Text(
                                                  'Enter Original price/MRP',
                                                  style: GoogleFonts.workSans(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              Container(
                                                width: 25.w,
                                                height: 6.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  initialValue:
                                                      controller.unitPrice2,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 1,
                                                            horizontal: 1),
                                                    border: InputBorder.none,
                                                    hintText: 'Original Price',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 7,
                                                  onChanged: (unitPrice) {
                                                    controller.updateUnitPrice2(
                                                        unitPrice);
                                                    controller
                                                        .calculateDiscountedPrice(); // Calculate discounted price when original price changes
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Center(
                                  child: Container(
                                    width: 90.w,
                                    height: 21.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 10),
                                          child: Text(
                                            'Regular Discount',
                                            style: GoogleFonts.workSans(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 6.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  initialValue:
                                                      controller.offerDiscount,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 1,
                                                            horizontal: 1),
                                                    border: InputBorder.none,
                                                    hintText: 'Number',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 2,
                                                  validator:
                                                      (newOfferDiscount) => utils
                                                          .validateOfferDiscount(
                                                              newOfferDiscount!),
                                                  onChanged: (offerDiscount) {
                                                    controller
                                                        .updateOfferDiscount(
                                                            offerDiscount);
                                                    controller
                                                        .calculateDiscountedPrice(); // Calculate discounted price when regular discount changes
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                width: 40.w,
                                                height: 6.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (controller
                                                        .offerDiscountedPrice
                                                        .isNotEmpty)
                                                      Text(
                                                        'Regular Discounted Price: ${controller.offerDiscountedPrice}',
                                                        style: GoogleFonts
                                                            .workSans(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 10),
                                          child: Text(
                                            'Prime Discount',
                                            style: GoogleFonts.workSans(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 6.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  initialValue: controller
                                                      .offerPrimeDiscount,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 1,
                                                            horizontal: 1),
                                                    border: InputBorder.none,
                                                    hintText: 'Number',
                                                  ),
                                                  maxLength: 2,
                                                  validator: (newOfferPrimeDiscount) =>
                                                      utils.validateOfferPrimeDiscount(
                                                          newOfferPrimeDiscount!,
                                                          controller
                                                              .offerDiscount),
                                                  onChanged:
                                                      (offerPrimeDiscount) {
                                                    //  utils.validateOfferPrimeDiscount(offerPrimeDiscount, offerDiscount)
                                                    controller
                                                        .updateOfferPrimeDiscount(
                                                            offerPrimeDiscount);
                                                    controller
                                                        .calculateDiscountedPrice(); // Calculate discounted price when prime discount changes
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 3.w),
                                              Container(
                                                width: 40.w,
                                                height: 6.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (controller
                                                        .offerPrimeDiscountedPrice
                                                        .isNotEmpty)
                                                      Text(
                                                        'Prime Discounted Price: ${controller.offerPrimeDiscountedPrice}',
                                                        style: GoogleFonts
                                                            .workSans(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //   Row(
                                //     children: [
                                ////     Checkbox(
                                //      value: controller.isCreativeDesigned,
                                ////      activeColor: Colors.blue.shade900,
                                //     onChanged: (isCreativeDesigned) =>
                                //        controller.updateIsCreativeDesigned(
                                //            isCreativeDesigned!),
                                //   ),
                                //    const Text(
                                //      'Get the Creative designed by professional',
                                //    ),
                                //   ],
                                //   ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Column(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '* Num of Claim ',
                                                        style: GoogleFonts
                                                            .workSans(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: .2.h,
                                                ),
                                                Container(
                                                  width: 20.w,
                                                  height: 8.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 50.w,
                                                      child: TextFormField(
                                                        initialValue: controller
                                                            .maxNumClaims,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                            .workSans(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black),
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          hintText: '100',
                                                          hintStyle: GoogleFonts
                                                              .workSans(
                                                                  color: Colors
                                                                      .grey),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        validator:
                                                            (maxNumClaims) {
                                                          // Allow empty input
                                                          if (maxNumClaims!
                                                              .isEmpty) {
                                                            return null; // Return null to indicate no error
                                                          }
                                                          // Validate only if not empty
                                                          return utils
                                                              .validatemaxNumClaims(
                                                                  maxNumClaims);
                                                        },
                                                        onChanged:
                                                            (newmaxNumClaims) {
                                                          // Set value to 0 if empty
                                                          if (newmaxNumClaims
                                                              .isEmpty) {
                                                            controller
                                                                .updatemaxNumClaimsTxt(
                                                                    '0');
                                                          } else {
                                                            controller
                                                                .updatemaxNumClaimsTxt(
                                                                    newmaxNumClaims);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Adjust spacing between the two sections
                                  ],
                                ),
                                SizedBox(
                                  height: .2.h,
                                ),
                                //   Row(
                                //  children: [
                                //     const Text.rich(
                                //      TextSpan(
                                //      children: [
                                //      TextSpan(
                                //         text: '*',
                                //         style: TextStyle(
                                //          color: Color(
                                //             0xFFFF0000),
                                //         fontSize: 12,
                                //        fontFamily:
                                //            'Aileron',
                                //       fontWeight:
                                //          FontWeight.w700,
                                //        height: 0,
                                //       ),
                                //     ),
                                //    TextSpan(
                                //     text:
                                //         'Deal Applies to',
                                //      style: TextStyle(
                                //        color: Colors.black,
                                //         fontSize: 15,
                                //        fontFamily:
                                //           'Aileron',
                                //      fontWeight:
                                //           FontWeight.w700,
                                //       height: 0,
                                //       ),
                                //      ),
                                //      ],
                                //    ),
                                //    ),
                                //     Container(
                                //       width: 90,
                                //      height: 24.63,
                                //     margin:
                                //         const EdgeInsets.only(
                                //             left: 10),
                                // Adjust the margin as needed
                                //     decoration: BoxDecoration(
                                //       color: Colors.transparent,
                                // Change to your preferred button color
                                //      borderRadius:
                                //         BorderRadius.circular(
                                //             5),
                                //     border: Border.all(
                                //         color: Colors.black,
                                //         width:
                                //              1), // Add black border
                                //     ),
                                //    alignment: Alignment.center,
                                //     child: const Text(
                                //       'Storewide',
                                //      style: TextStyle(
                                //        color: Colors.black,
                                //        fontSize: 10,
                                //        fontFamily: 'Aileron',
                                //        fontWeight:
                                //            FontWeight.w400,
                                //         height: 0,
                                //       ),
                                //     ),
                                //   ),
                                //    Container(
                                //      width: 90,
                                //     height: 24.63,
                                //     margin:
                                //         const EdgeInsets.only(
                                //             left: 10),
                                // Adjust the margin as needed
                                //    decoration: BoxDecoration(
                                //     color: Colors.black,
                                // Change to your preferred button color
                                //      borderRadius:
                                //         BorderRadius.circular(
                                //             5), // Optional: Rounded corners
                                //    ),
                                //     alignment: Alignment.center,
                                //     child: const Text(
                                //       'Selected',
                                //      style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 10,
                                //       fontFamily: 'Aileron',
                                //       fontWeight:
                                //          FontWeight.w400,
                                //      height: 0,
                                //     ),
                                //    ),
                                //   ),
                                //  ],
                                //  ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                //      Row(
                                //        children: [
                                //         Checkbox(
                                //          value: controller.isAgreePolicies,
                                //          activeColor: Colors.blue.shade900,
                                //         onChanged: (isAgreePolicies) => controller
                                //            .updateIsAgreePolicies(isAgreePolicies!),
                                //     ),
                                //     const Text(
                                //       'Agree our policies',
                                //     ),
                                //     const SizedBox(
                                //      width: 10,
                                //    ),
                                //    Expanded(
                                //      child: SizedBox(
                                //       height: 35,
                                //          // Adjust the height to your desired value
                                //        width: double.infinity,
                                //      // Adjust the width to your desired value
                                //      child: myWidgets.getLargeButton(
                                //      title: 'Click to Read our policies',
                                //      bgColor: Colors.blue.shade900,
                                //      onPress: controller.showPoliciesView,
                                //     ),
                                //   ),
                                //    )
                                //     ],
                                //      ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // const Text(
                                      //   '* Describe your Deal Details',
                                      //   style: TextStyle(
                                      //     color: Colors.black,
                                      //     fontSize: 13,
                                      //     fontFamily: 'Aileron',
                                      //     fontWeight:
                                      //         FontWeight.w700,
                                      //   ),
                                      // ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //       color: Colors.black12,
                                      //       // Black border color
                                      //       width:
                                      //           2.0, // Border width
                                      //     ),
                                      //     borderRadius:
                                      //         BorderRadius
                                      //             .circular(10.0),
                                      //   ),
                                      //   child: TextFormField(
                                      //     initialValue: controller
                                      //         .describeDealDetails,
                                      //     autovalidateMode:
                                      //         AutovalidateMode
                                      //             .onUserInteraction,
                                      //     maxLines: 3,
                                      //     // Adjust the number of lines as needed
                                      //     decoration:
                                      //         const InputDecoration(
                                      //       hintText:
                                      //           'If your deal is valid to a specific category, and conditional, please specify the deal here',
                                      //       hintStyle: TextStyle(
                                      //         color: Color(
                                      //             0xFFA6A6A6),
                                      //         fontSize: 13,
                                      //         fontFamily:
                                      //             'Aileron',
                                      //         fontWeight:
                                      //             FontWeight.w400,
                                      //       ),
                                      //       contentPadding:
                                      //           EdgeInsets.all(
                                      //               10),
                                      //       // Padding inside the TextFormField
                                      //       border: InputBorder
                                      //           .none, // Remove the default border
                                      //     ),
                                      //     validator: (describeDealDetails) =>
                                      //         utils.validatedescribeDealDetails(
                                      //             describeDealDetails!),
                                      //     onChanged: (newdescribeDealDetails) =>
                                      //         controller
                                      //             .updatedescribeDealDetailsTxt(
                                      //                 newdescribeDealDetails),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 2.h),
                                      // const Text(
                                      //   '* Steps to Redeem',
                                      //   style: TextStyle(
                                      //     color: Colors.black,
                                      //     fontSize: 13,
                                      //     fontFamily: 'Aileron',
                                      //     fontWeight:
                                      //         FontWeight.w700,
                                      //   ),
                                      // ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //       color: Colors.black12,
                                      //       width: 2.0,
                                      //     ),
                                      //     borderRadius:
                                      //         BorderRadius
                                      //             .circular(10.0),
                                      //   ),
                                      //   child: TextFormField(
                                      //     initialValue: controller
                                      //         .stepsToRedeem,
                                      //     autovalidateMode:
                                      //         AutovalidateMode
                                      //             .onUserInteraction,
                                      //     maxLines: 5,
                                      //     decoration:
                                      //         const InputDecoration(
                                      //       hintText:
                                      //           'Default steps here, edit if required.',
                                      //       hintStyle: TextStyle(
                                      //         color: Color(
                                      //             0xFFA6A6A6),
                                      //         fontSize: 13,
                                      //         fontFamily:
                                      //             'Aileron',
                                      //         fontWeight:
                                      //             FontWeight.w400,
                                      //       ),
                                      //       contentPadding:
                                      //           EdgeInsets.all(
                                      //               10),
                                      //       border:
                                      //           InputBorder.none,
                                      //     ),
                                      //     validator: (stepsToRedeem) =>
                                      //         utils.validatestepsToRedeem(
                                      //             stepsToRedeem!),
                                      //     onChanged: (newstepsToRedeem) =>
                                      //         controller
                                      //             .updatestepsToRedeemTxt(
                                      //                 newstepsToRedeem),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 2.h),
                                      //  const Text(
                                      //     '* Terms and Conditions',
                                      //     style: TextStyle(
                                      //      color: Colors.black,
                                      //      fontSize: 13,
                                      //      fontFamily:
                                      //      'Aileron',
                                      //       fontWeight:
                                      //           FontWeight.w700,
                                      //     ),
                                      //      ),
                                      //   Container(
                                      //     decoration:
                                      //         BoxDecoration(
                                      //       border: Border.all(
                                      //        color: Colors
                                      //             .black12,
                                      //         width: 2.0,
                                      //       ),
                                      //      borderRadius:
                                      //          BorderRadius
                                      //               .circular(
                                      //                   10.0),
                                      //     ),
                                      //      child: TextFormField(
                                      //       controller: controller.termsAndConditionController,
                                      //       maxLines: 5,
                                      //       decoration: const InputDecoration(
                                      //         hintText: 'Add your terms here, they will appear with default terms.',
                                      //         hintStyle: TextStyle(
                                      //           color: Color(0xFFA6A6A6),
                                      //           fontSize: 13,
                                      //           fontFamily: 'Aileron',
                                      //          fontWeight: FontWeight.w400,
                                      //          ),
                                      //           contentPadding: EdgeInsets.all(10),
                                      //          border: InputBorder.none,
                                      //         ),
                                      //        ),
                                      //      ),
                                      // SizedBox(height: 2.h),
                                      // SizedBox(height: 2.h),

                                      if (controller.isProductOffer) ...[
                                        Text(
                                          '* Warranty Policy',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue: controller.warranty,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Warranty Policy ',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (warranty) => utils
                                                .validatewarranty(warranty!),
                                            onChanged: (newwarranty) =>
                                                controller.updatewarrantyTxt(
                                                    newwarranty),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          '* Refund Policy',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue: controller.refund,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Refund Policy ',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (refund) =>
                                                utils.validaterefund(refund!),
                                            onChanged: (newrefund) => controller
                                                .updaterefundTxt(newrefund),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          '* Delivery Policy',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue: controller.delivery,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Delivery Policy ',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (delivery) => utils
                                                .validatedelivery(delivery!),
                                            onChanged: (newdelivery) =>
                                                controller.updatedeliveryTxt(
                                                    newdelivery),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          '* Other Policy (Optional)',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue: controller.other,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Other Policy ',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (other) =>
                                                utils.validateother(other!),
                                            onChanged: (newother) => controller
                                                .updateotherTxt(newother),
                                          ),
                                        ),
                                      ] else if (controller.isServiceOffer) ...[
                                        Text(
                                          '* Warranty Policy',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue:
                                                controller.serviceDescription,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: '*Warranty Policy',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (other) =>
                                                utils.validateother(other!),
                                            onChanged: (newother) => controller
                                                .updateotherTxt(newother),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          '* Refund Policy',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue:
                                                controller.serviceDuration,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Refund Policy',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (other) =>
                                                utils.validateother(other!),
                                            onChanged: (newother) => controller
                                                .updateotherTxt(newother),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          '* Reschedule/Cancellation',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue:
                                                controller.serviceTerms,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Reschedule/Cancellation',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (other) =>
                                                utils.validateother(other!),
                                            onChanged: (newother) => controller
                                                .updateotherTxt(newother),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          '* Remote/on-site',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue:
                                                controller.serviceTerms,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Remote/on-site',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (other) =>
                                                utils.validateother(other!),
                                            onChanged: (newother) => controller
                                                .updateotherTxt(newother),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          '* Other Policy',
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextFormField(
                                            initialValue:
                                                controller.serviceTerms,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText: 'Other Policy',
                                              hintStyle: GoogleFonts.workSans(
                                                color: Color(0xFFA6A6A6),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: InputBorder.none,
                                            ),
                                            validator: (other) =>
                                                utils.validateother(other!),
                                            onChanged: (newother) => controller
                                                .updateotherTxt(newother),
                                          ),
                                        ),
                                      ],

                                      SizedBox(
                                        height: 2.h,
                                      ),

                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      InkResponse(
                                        onTap: controller.createOffer,
                                        child: Container(
                                          width: 100.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            // Black border
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Preview Your Offer',
                                              style: GoogleFonts.workSans(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: 100
                                              .w, // Use percentage width with ScreenUtil
                                          child: Text(
                                            'Preview your offer before submitting for review.',
                                            textAlign: TextAlign
                                                .center, // Center-align text
                                            style: GoogleFonts.workSans(
                                              color: const Color(0xFFA6A6A6),
                                              fontSize:
                                                  12.sp, // Responsive font size
                                              fontWeight: FontWeight.w400,
                                              height:
                                                  1.5, // Line height for better readability
                                            ),
                                          ),
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
                    ),
            ),
          );
        },
      ),
    ));
  }
}

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideo({super.key, required this.controller});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  @override
  void initState() {
    super.initState();
    widget.controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            VideoProgressIndicator(
              widget.controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Color(0xFF00BADD),
                backgroundColor: Colors.white24,
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF00BADD),
                onPressed: () {
                  setState(() {
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                  });
                },
                child: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//    Container(
//      width: 30.w,
//     height: 6.h,
//    decoration: BoxDecoration(
//      borderRadius: BorderRadius.circular(6),
//       border: Border.all(
//         color: Colors.black,
//        width: 1,
//       ),
//       ),
//        child: TextFormField(
//        initialValue: controller.regularUnitPrice,
////        autovalidateMode: AutovalidateMode.onUserInteraction,
//       decoration: const InputDecoration(
//        contentPadding:
//       EdgeInsets.symmetric(vertical: 1, horizontal: 1),
//      border: InputBorder.none,
//       hintText: 'Original Price',
//      ),
//      keyboardType: TextInputType.number,
//      maxLength: 7,
//     onChanged: (regularUnitPrice) =>
//           controller.updateregularUnitPrice(regularUnitPrice),
//      ),
//      ),

//  AnimatedSwitcher(
//     duration: const Duration(seconds: 1),
//      child: controller.cityList.isEmpty
////          ? const Center(
//            child: CircularProgressIndicator(),
//          )
//       : Column(
//           children: [
//            DropdownButtonFormField(
//           icon: const Icon(
//               Icons.arrow_downward_rounded),
//          decoration: const InputDecoration(
//           filled: true,
//          border: OutlineInputBorder(),
//         fillColor: Colors.transparent,
//         labelText: 'Select City',
//      ),
//      elevation: 16,
//      style: const TextStyle(
//         color: Colors.deepPurple),
//       hint: const Text('Select City'),
//       items: controller.cityList
//          .map<DropdownMenuItem<String>>(
//              (String city) {
//        return DropdownMenuItem<String>(
//         value: city,
//         child: Text(city,
//            style: const TextStyle(
//                color: Colors.black)),
//      );
//    }).toList(),
//   value: controller.selectedCity,
//    onChanged: (value) =>
//        controller.changeSelectedCity(value!),
//  ),
//   Text(
//      "We're available in above cities only, others are coming soon!",
//      textAlign: TextAlign.center,
//      style: TextStyle(
//           color: Colors.blue.shade900)),
//  ],
//   ),
//     ),
//      StreamBuilder(
//        stream: isar.stateColls
//           .where()
//             .build()
//             .watch(fireImmediately: true),
//        builder: (context, snapshot) {
//         List<StateColl> stateList = [];
//       if (snapshot.hasError) {
//         return const Text(
//             'Error or not having data to show!');
//         }
//         if (snapshot.hasData) {
//          stateList = snapshot.data as List<StateColl>;
//       }
//       return AnimatedSwitcher(
//        duration: const Duration(seconds: 1),
//        child: stateList.isEmpty
//           ? const Center(
//               child: CircularProgressIndicator(),
//           )
//         : DropdownButtonFormField(
//            icon: const Icon(
//                Icons.arrow_downward_rounded),
//           decoration: const InputDecoration(
//               filled: true,
//              border: OutlineInputBorder(),
//              fillColor: Colors.transparent,
//              labelText: 'Select State',
//               hintText: 'Select State'),
//          elevation: 16,
//          style: const TextStyle(
//             color: Colors.deepPurple),
//         hint: const Text('Select State'),
//         items: stateList
////            .map<DropdownMenuItem<String>>(
//                (StateColl state) {
//          return DropdownMenuItem<String>(
//            value: state.stateName,
//           child: Text(state.stateName,
//                style: const TextStyle(
//                   color: Colors.black)),
//          );
//        }).toList(),
//        value: controller.selectedState,
//        onChanged: (value) => controller
//            .changeSelectedState(value!),
//       ),
//          );
//       },
//     ),
