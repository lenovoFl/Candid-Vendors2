import 'dart:io';
import 'package:candid_vendors/Controllers/Auth/CreateProfileController.dart';
import 'package:candid_vendors/Services/Collections/State/StateColl.dart';
import 'package:candid_vendors/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import '../../../Utils/MyWidgets.dart';

class CreateProfileStep1 extends StatefulWidget {
  final String mobileNumber;
  final String countryCode;
  final User user;
  final CreateProfileController controller;

  const CreateProfileStep1(
      {super.key,
        required this.controller,
        required this.mobileNumber,
        required this.countryCode,
        required this.user,
       });

  @override
  State<CreateProfileStep1> createState() => _CreateProfileStep1State();
}

class _CreateProfileStep1State extends State<CreateProfileStep1> {
  final CreateProfileController controller =
  Get.find<CreateProfileController>();
  bool isOtpValid = false;
  bool _isOtpRequested = false;
  bool isGSTFieldVisible = false;
  bool isButtonVisible = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isLoading) {
        controller.isLoading = true;
        controller.update();
      }
    });
    return AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: widget.controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.controller.selectedStep == 0
            ? Form(
            key: widget.controller.createProfileFormKeys[0],
            child: Center(
              child: SizedBox(
                width: 90.w,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 326,
                        height: 30,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Are you GST Registered?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Aileron',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFFB4FFB2),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                controller
                                    .handleGSTYes(); // Use new handler instead of just setting isGSTFieldVisible
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Aileron',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFFFFB2B2),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                controller
                                    .handleGSTNo(); // Use new handler instead of just setting isGSTFieldVisible
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Aileron',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      myWidgets.requiredField(),
                      InkWell(
                        onTap: () {
                          showGeneralDialog(
                            context: navigatorKey.currentContext!,
                            transitionBuilder:
                                (context, a1, a2, child) {
                              var curve =
                              Curves.easeInOut.transform(a1.value);
                              return Transform.scale(
                                scale: curve,
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15.0),
                                  ),
                                  elevation: 8.0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15.0),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment:
                                          Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                            child: const CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                              Colors.black,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            widget.controller
                                                .capturePersonalImage(
                                                fromCamera: true);
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors
                                                .white, // Icon color white
                                          ),
                                          label: const Text(
                                            'Capture from camera',
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // Text color white
                                          ),
                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Colors.black,
                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            widget.controller
                                                .selectPersonalImage(
                                                fromCamera: false);
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.image_sharp,
                                            color: Colors
                                                .white, // Icon color white
                                          ),
                                          label: const Text(
                                            'Select from gallery',
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // Text color white
                                          ),
                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Colors.black,
                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            transitionDuration:
                            const Duration(milliseconds: 300),
                            barrierDismissible: true,
                            barrierLabel: '',
                            pageBuilder: (context, animation,
                                secondaryAnimation) {
                              return Container();
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SizedBox(
                            height: 15.h,
                            width: 30.w,
                            child:
                            widget.controller.personalImage == null
                                ? Image.asset(
                              'lib/Images/3135715.png', // Replace 'local_image.png' with your actual image path
                              fit: BoxFit.fill,
                            )
                                : Image.file(
                              File(widget.controller
                                  .personalImage!.path),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              myWidgets
                                  .requiredField(), // Required field indicator
                              const SizedBox(
                                  width:
                                  4), // Add some space between the required field indicator and label
                              Text(
                                ' Enter Full Name',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                              8), // Space between label and TextFormField
                          TextFormField(
                            controller: widget
                                .controller.fullNameEditingController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled:
                              true, // Enable filling the background
                              fillColor: Colors
                                  .white, // Set background color to white
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Rounded corners
                                borderSide: const BorderSide(
                                  color: Colors
                                      .grey, // Set border color to grey
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors
                                      .grey, // Set border color to grey for enabled state
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors
                                      .grey, // Set border color to grey for focused state
                                ),
                              ),
                              hintText: 'Enter Full Name Here!',
                              // Remove the label text from the decoration
                            ),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            maxLength: 20,
                            validator: (value) => utils.validateText(
                                string: value.toString(),
                                required: true),
                          ), // Space between label and TextFormField
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                myWidgets
                                    .requiredField(), // Required field indicator
                                const SizedBox(
                                    width:
                                    4), // Add some space between the required field indicator and label
                                Text(
                                  ' Select Gender',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Center(
                              child: DropdownButtonFormField(
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_sharp),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors
                                      .white, // Set dropdown field background color
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Set border color to grey
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color for enabled state
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color for focused state
                                    ),
                                  ),
                                ),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors
                                        .black), // Ensure text color is black in the dropdown field
                                dropdownColor: Colors
                                    .white, // Set the dropdown background color to white
                                hint: const Text('Select Gender',
                                    style:
                                    TextStyle(color: Colors.black)),
                                items: widget.controller.gendersList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          color: Colors
                                              .white, // Ensure the dropdown item's background is white
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors
                                                    .black), // Ensure the text is black
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                value: widget.controller.selectedGender,
                                onChanged: (value) => widget.controller
                                    .changeSelectedGender(value!),
                              ),
                            ),
                          ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              myWidgets
                                  .requiredField(), // Required field indicator
                              const SizedBox(width: 4),
                              Text(
                                'Enter Email',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: widget
                                .controller.emailIdEditingController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey),
                              ),
                              hintText: 'Enter Email Here!',
                            ),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                utils.validateEmail(value.toString()),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap:
                          widget.controller.sendVerificationEmail,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.controller.isEmailVerified
                                  ? 'Email Verified'
                                  : widget.controller.isVerifyEmailSent
                                  ? 'Verification Email Sent'
                                  : 'Send Verification Email',
                              textScaleFactor: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                          color: Colors
                              .white, // Background color for the row
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Aadhaar with Picture is Required',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.5.sp,
                                        ),
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                myWidgets
                                    .requiredField(), // Required field indicator
                                const SizedBox(width: 4),
                                Text(
                                  ' Enter Aadhaar Number',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            TextFormField(
                              controller:
                              controller.aadhaarNoEditingController,
                              textCapitalization:
                              TextCapitalization.characters,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled:
                                true, // Enable filling the background
                                fillColor: Colors
                                    .white, // Set background color to white
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .grey, // Set border color to grey for enabled state
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .grey, // Set border color to grey for focused state
                                  ),
                                ),
                                hintText: 'Enter Aadhaar number here!',
                                label: const Text(
                                  'Enter Aadhaar number',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                suffixIcon:
                                myWidgets.validateButtonForTxtField(
                                  title: 'Request OTP',
                                  onPress: () {
                                    // Call your function to request OTP here
                                    controller
                                        .getAadhaarOtpBtnClickHandler(); // Assuming this function sets _isOtpRequested to true upon success
                                    setState(() {
                                      _isOtpRequested = true;
                                    });
                                  },
                                ),
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              maxLength: 14,
                              onChanged:
                              controller.onAadhaarNumberChange,
                              validator: (value) =>
                                  utils.validateAadhaarNumber(
                                      value.toString()),
                            ),
                          ]),
                      if (_isOtpRequested) // Only show OTP field if OTP is requested
                        TextFormField(
                          controller: controller.otpEditingController,
                          enabled: !controller.isLoading &&
                              !controller.isVerified,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            if (controller.isVerified) {
                              // Hide the button if the OTP field is edited after verification
                              controller.isVerified = false;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(1.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            hintText: 'Enter OTP here!',
                            label: const Text('Enter OTP'),
                            suffixIcon: controller.isLoading
                                ? const CircularProgressIndicator()
                                : Container(
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  minimumSize: const Size(80, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (!controller.isVerified) {
                                    if (controller
                                        .otpEditingController
                                        .text
                                        .length ==
                                        6) {
                                      controller
                                          .verifyAadhaarOtpWithTranBtnClickHandler();
                                    }
                                  }
                                },
                                child: Text(
                                  controller.isVerified
                                      ? 'Validated'
                                      : 'Validate',
                                  style: const TextStyle(
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          validator: (value) =>
                              utils.validateAadhaarotpNumber(
                                  value.toString()),
                        ),
                      // Fallback option if OTP fails: Show Aadhaar upload section with attachment icon
                      // if (controller.showUploadAadhaarOption)
                      Column(
                        children: [
                          Text(
                              'Did not receive OTP? Never Mind just upload Aadhaar image and enter Your Aadhaar Number.'),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: ElevatedButton.icon(
                                  onPressed: () => controller
                                      .selectOrCaptureAadhaarCardImage(
                                      fromCamera: false),
                                  icon: const Icon(Icons
                                      .attachment), // Attachment icon
                                  label: const Text(
                                      'Upload Aadhaar Image'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .black, // Set the background to black
                                    foregroundColor: Colors
                                        .white, // Set the text/icon color to white
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (controller.aadhaarCardImage != null)
                            Column(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    controller.aadhaarCardImage = null;
                                    controller.update();
                                  },
                                  child:
                                  const Icon(Icons.close_outlined),
                                ),
                                Image.file(
                                  File(controller
                                      .aadhaarCardImage!.path),
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                        ],
                      ),

                      // Divider(color: Colors.blue.shade900, thickness: 5),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                          color: Colors
                              .white, // Background color for the row
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Pan Card Details (Optional)',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.5.sp,
                                        ),
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller:
                        widget.controller.panNoEditingController,
                        textCapitalization:
                        TextCapitalization.characters,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true, // Enable filling the background
                          fillColor: Colors
                              .white, // Set background color to white
                          border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(1.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Set border color to grey for enabled state
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Set border color to grey for focused state
                            ),
                          ),
                          hintText: 'Enter PAN number here!',
                          label: const Text('Enter PAN number'),
                          suffixIcon: Obx(() => IconButton(
                            icon: Icon(
                              Icons.check_circle_outline,
                              color: widget.controller.isPanVerified
                                  .value
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: widget
                                .controller.isPanVerified.value
                                ? null
                                : () {
                              if (utils.validatePanNumber(widget
                                  .controller
                                  .panNoEditingController
                                  .text) ==
                                  null) {
                                widget.controller
                                    .validatePanBtnClickHandler();
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Please enter a valid PAN number format',
                                  snackPosition:
                                  SnackPosition.BOTTOM,
                                  duration: const Duration(
                                      seconds: 3),
                                );
                              }
                            },
                          )),
                        ),
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        onChanged: widget.controller.isPanVerified.value
                            ? null
                            : (value) {
                          widget.controller.panNoEditingController
                              .value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: widget.controller
                                .panNoEditingController.selection,
                          );
                          widget.controller.isPanValid = false;
                          widget.controller.update();
                        },
                        validator: (value) =>
                            utils.validatePanNumber(value.toString()),
                        enabled: !widget.controller.isPanVerified.value,
                      ),

                      SizedBox(
                        height: 6.h,
                        width: 100.w,
                        child: const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Company Pan (Optional)',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: widget
                            .controller.CompanyPanEditingController,
                        textCapitalization:
                        TextCapitalization.characters,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true, // Enable filling the background
                          fillColor: Colors
                              .white, // Set background color to white
                          border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(1.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Set border color to grey for enabled state
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Set border color to grey for focused state
                            ),
                          ),
                          hintText: 'Enter CompanyPan number here!',
                          label: const Text('Enter CompanyPan number'),
                          ////  suffixIcon: myWidgets.validateButtonForTxtField(
                          //    title: 'Validate',
                          //    onPress: widget.controller.validatePanBtnClickHandler)
                        ),
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        onChanged: (value) {
                          widget.controller.CompanyPanEditingController
                              .value =
                              TextEditingValue(
                                  text: value.toUpperCase(),
                                  selection: widget
                                      .controller
                                      .CompanyPanEditingController
                                      .selection);
                        },
                        validator: (value) =>
                            utils.validateCompanyPan(value.toString()),
                      ),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                          color: Colors
                              .white, // Background color for the row
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Select Or Capture Pan Image',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.controller.panCardImage != null)
                        Column(
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  widget.controller.panCardImage = null;
                                  widget.controller.update();
                                },
                                child:
                                const Icon(Icons.close_outlined)),
                            SizedBox(
                                height: 23.h,
                                width: 80.w,
                                child: Card(
                                    color: Colors
                                        .white, // Set the background color to white
                                    elevation:
                                    4, // Optional: Add elevation to the card for a shadow effect
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Optional: Add rounded corners
                                    ),
                                    child: Image.file(
                                      File(widget.controller
                                          .panCardImage!.path),
                                      fit: BoxFit.fill,
                                    )))
                          ],
                        ),
                      Row(
                        children: [
                          Flexible(
                            child: FittedBox(
                              child: myWidgets.getLargeButtonWithIcon(
                                  title: 'select from gallery',
                                  icon: Icons.browse_gallery_outlined,
                                  onPressed: () => widget.controller
                                      .selectOrCapturePanCardImage(
                                      fromCamera: false),
                                  bgColor: Colors.black),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text('OR', textScaleFactor: 1),
                          ),
                          Flexible(
                            child: FittedBox(
                              child: myWidgets.getLargeButtonWithIcon(
                                  title: 'capture from camera',
                                  icon: Icons.camera_alt_outlined,
                                  onPressed: () => widget.controller
                                      .selectOrCapturePanCardImage(
                                      fromCamera: true),
                                  bgColor: Colors.black),
                            ),
                          )
                        ],
                      ),
                      // Text(
                      //     'Valid password is with at lease 1 capital, small, digit, special symbol like (!@#\$&*~)',
                      //     textScaleFactor: 1.3,
                      //     style: TextStyle(color: Colors.blue.shade900)),
                      GetBuilder<CreateProfileController>(
                        builder: (controller) => Visibility(
                          visible: controller.isGSTFieldVisible,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  myWidgets.requiredField(),
                                  const SizedBox(width: 4),
                                  Text(
                                    'GST Number',
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller:
                                controller.gstEditingController,
                                textAlign: TextAlign.center,
                                textCapitalization:
                                TextCapitalization.characters,
                                enabled: !controller.isGstValid,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: 'Enter GST number here!',
                                  labelText: 'Enter GST number',
                                  suffixIcon: Container(
                                    margin: const EdgeInsets.all(8),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        controller.isGstValid
                                            ? Colors.green
                                            : Colors.black,
                                        foregroundColor: Colors.white,
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        minimumSize: const Size(80, 30),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: controller.isGstValid
                                          ? null
                                          : () => controller
                                          .validateGSTBtnClickHandler(),
                                      child: Text(
                                        controller.isGstValid
                                            ? 'Validated'
                                            : 'Validate',
                                        style: const TextStyle(
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  if (controller.isGstValid) {
                                    controller.isGstValid = false;
                                    controller.update();
                                  }
                                  controller.gstEditingController
                                      .value = TextEditingValue(
                                    text: value.toUpperCase(),
                                    selection: TextSelection.collapsed(
                                        offset:
                                        value.toUpperCase().length),
                                  );
                                },
                                maxLength: 15,
                                validator: (gstNumber) =>
                                    utils.validateGSTNumber(
                                        gstNumber.toString()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      myWidgets.requiredField(),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                          color: Colors
                              .white, // Background color for the row
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Referred By',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.5.sp,
                                        ),
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize
                              .min, // Set mainAxisSize to min
                          children: [
                            Flexible(
                              fit: FlexFit
                                  .loose, // Use Flexible with loose fit
                              child: Container(
                                height: 5.h,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 1.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Radio<String>(
                                        value: 'Self',
                                        groupValue:
                                        widget.controller.referBy,
                                        onChanged: (String? value) {
                                          widget.controller.referBy =
                                              value.toString();
                                          widget.controller.update();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Text(
                                      'Self',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                height: 5.h,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 1.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Radio<String>(
                                        value: 'Champion',
                                        groupValue:
                                        widget.controller.referBy,
                                        onChanged: (String? value) {
                                          widget.controller.referBy =
                                              value.toString();
                                          widget.controller.update();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Text(
                                      'Champion',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                height: 5.h,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 1.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Radio<String>(
                                        value: 'Seller',
                                        groupValue:
                                        widget.controller.referBy,
                                        onChanged: (String? value) {
                                          widget.controller.referBy =
                                              value.toString();
                                          widget.controller.update();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Text(
                                      'Seller',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: widget.controller.referBy == 'Self'
                            ? const SizedBox()
                            : widget.controller.referBy == 'Seller'
                            ? Column(
                          children: [
                            TextField(
                              controller: widget.controller
                                  .referralController,
                              decoration: InputDecoration(
                                labelText:
                                'Enter your referral ID',
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      10.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              width: 20.w,
                              height: 5.h,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await widget.controller
                                      .verifyReferral(
                                      context);
                                },
                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors.black,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        10.0),
                                  ),
                                  padding: const EdgeInsets
                                      .symmetric(
                                      vertical: 12),
                                ),
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : widget.controller.championList.isEmpty
                            ? const Text(
                            'No champion available')
                            : DropdownButtonFormField<String>(
                          decoration:
                          const InputDecoration(
                            filled: true,
                            fillColor: Colors
                                .white, // Set the background of the dropdown field to white
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius
                                  .all(Radius.circular(
                                  12.0)), // Rounded corners
                            ),
                            labelText: 'Select Champion',
                          ),
                          isExpanded: true,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors
                                  .black), // Text color for the selected item
                          dropdownColor: Colors
                              .white, // Set dropdown menu background color to white
                          hint: const Text(
                              'Select Champion'),
                          items: widget
                              .controller.championList
                              .map((String champion) {
                            List parts =
                            champion.split('|');
                            String name = parts[0];
                            String id = parts[1];
                            return DropdownMenuItem(
                              value: id,
                              child: Text(
                                name,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors
                                        .black), // Text color for dropdown items
                              ),
                            );
                          }).toList(),
                          value: widget
                              .controller.championList
                              .any((champion) =>
                          champion.split(
                              '|')[1] ==
                              widget.controller
                                  .selectedChampionID)
                              ? widget.controller
                              .selectedChampionID
                              : null, // Ensure value matches one of the items
                          onChanged:
                              (selectedChampionID) {
                            if (selectedChampionID !=
                                null) {
                              widget.controller
                                  .onChampionSelected(
                                  selectedChampionID);
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 2.h),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                myWidgets
                                    .requiredField(), // Required field indicator
                                const SizedBox(
                                    width:
                                    4), // Add some space between the required field indicator and label
                                Text(
                                  ' Name of the Outlet',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: widget.controller
                                  .companyNameEditingController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled:
                                true, // Enable filling the background
                                fillColor: Colors
                                    .white, // Set background color to white
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .grey, // Set border color to grey for enabled state
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .grey, // Set border color to grey for focused state
                                  ),
                                ),
                                hintText: 'Type your store/outlet Name',
                                // label: const Text('Enter Store/Company name')
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              maxLength: 50,
                              validator: (value) => utils.validateText(
                                  string: value.toString(),
                                  required: true),
                            ),
                          ]),
                      DropdownButtonFormField(
                        icon:
                        const Icon(Icons.keyboard_arrow_down_sharp),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                            ),

                            // fillColor: Colors.transparent,
                            labelText: 'Select Type of company',
                            hintText: 'Select Type of company'),
                        elevation: 16,
                        style:
                        const TextStyle(color: Colors.deepPurple),
                        hint: const Text('Select Type of company'),
                        items: widget.controller.typeOfCompany
                            .map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const TextStyle(
                                        color: Colors.black)),
                              );
                            }).toList(),
                        value: widget.controller.selectedTypeOfCompany,
                        onChanged: (value) => widget.controller
                            .changeSelectedCompanyType(value!),
                      ),
                      myWidgets.requiredField(),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                          color: Colors
                              .white, // Background color for the row
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Upload Your Store/Company logo',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.5.sp,
                                        ),
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showGeneralDialog(
                            context: navigatorKey.currentContext!,
                            transitionBuilder:
                                (context, a1, a2, child) {
                              var curve =
                              Curves.easeInOut.transform(a1.value);
                              return Transform.scale(
                                scale: curve,
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15.0),
                                  ),
                                  elevation: 8.0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15.0),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment:
                                          Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                            child: const CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                              Colors.black,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            widget.controller
                                                .selectCompanyLogo(
                                                fromCamera: true);
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors
                                                .white, // Icon color white
                                          ),
                                          label: const Text(
                                            'Capture from camera',
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // Text color white
                                          ),
                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Colors.black,
                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            widget.controller
                                                .selectCompanyLogo(
                                                fromCamera: false);
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.image_sharp,
                                            color: Colors
                                                .white, // Icon color white
                                          ),
                                          label: const Text(
                                            'Select from gallery',
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // Text color white
                                          ),
                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Colors.black,
                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            transitionDuration:
                            const Duration(milliseconds: 300),
                            barrierDismissible: true,
                            barrierLabel: '',
                            pageBuilder: (context, animation,
                                secondaryAnimation) {
                              return Container();
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SizedBox(
                            height: 6.h,
                            width: 30.w,
                            child: widget.controller.companyLogo == null
                                ? Icon(
                              Icons
                                  .attachment, // Replace image with attachment icon
                              size: 30
                                  .sp, // Adjust the size as needed
                              color: Colors
                                  .grey, // You can change the color
                            )
                                : Image.file(
                              File(widget
                                  .controller.companyLogo!.path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 3.h,),
                      MyWidgets().getLargeButton(
                        onPress: controller.showMultiSelect,
                        bgColor: Colors.black,
                        txtScale: 1.3,
                        title: 'Select Categories',
                      ),
                      const Divider(
                        height: 30,
                      ),
                      // display selected items
                      Wrap(
                        children: controller.selectedCatsList
                            .map((e) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Chip(
                            label: Text(
                              e['catName']!,
                              style: const TextStyle(
                                  color: Colors
                                      .white), // Set text color to white
                            ),
                            backgroundColor: Colors
                                .black, // Set background to black
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  0), // Make the Chip square
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                          color: Colors
                              .white, // Background color for the row
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Store information',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.5.sp,
                                        ),
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      myWidgets.requiredField(),
                      const Text(
                        '(Locate your store lat long in Google Map.)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            child: !controller.showMap
                                ? const SizedBox()
                                : SizedBox(
                              height: 30.h,
                              width: 90.w,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                buildingsEnabled: true,
                                // myLocationEnabled: true, // Remove this line
                                onTap: (LatLng latLng) {
                                  controller.onGoogleMapTap(
                                      latLng); // Call the controller method
                                  // controller.addOutletClickHandler(latLng); // Call the modified addOutletClickHandler with the tapped LatLng
                                },
                                initialCameraPosition:
                                controller.kGooglePlex!,
                                markers: <Marker>{
                                  Marker(
                                    markerId: const MarkerId(
                                        "My outlet"),
                                    position: controller.center,
                                    // icon: BitmapDescriptor.,
                                    infoWindow: const InfoWindow(
                                      title: 'Outlet Address',
                                    ),
                                  ),
                                },
                                gestureRecognizers: <Factory<
                                    OneSequenceGestureRecognizer>>{
                                  Factory<
                                      OneSequenceGestureRecognizer>(
                                        () =>
                                        EagerGestureRecognizer(),
                                  ),
                                },
                                onMapCreated: (GoogleMapController
                                myGoogleMapController) {
                                  controller.googleMapController
                                      .complete(
                                      myGoogleMapController);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                              height:
                              16), // Add some spacing between the map and the text
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              myWidgets.requiredField(),
                              const SizedBox(width: 4),
                              Text(
                                'Company Address/ Outlet Address',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: widget.controller
                                .addressLine1EditingController,
                            decoration: InputDecoration(
                              hintText: 'Type Address Line 1',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8)),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            validator: (value) => utils.validateText(
                                string: value.toString(),
                                required: true),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: widget.controller
                                .addressLine2EditingController,
                            decoration: InputDecoration(
                              hintText: 'Type Area, Locality',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8)),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            validator: (value) => utils.validateText(
                                string: value.toString(),
                                required: false),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: widget.controller
                                .addressBuildingStreetAreaEditingController,
                            decoration: InputDecoration(
                              hintText: 'Type Nearest Landmark',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8)),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            validator: (value) => utils
                                .validateTextAddress(value.toString()),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: StreamBuilder(
                                  stream: isar.stateColls
                                      .where()
                                      .build()
                                      .watch(fireImmediately: true),
                                  builder: (context, snapshot) {
                                    List<StateColl> stateList = [];
                                    if (snapshot.hasError) {
                                      return const Text(
                                          'Error or not having data to show!');
                                    }
                                    if (snapshot.hasData) {
                                      stateList = snapshot.data
                                      as List<StateColl>;
                                      var initialValueExists =
                                      stateList.any((state) =>
                                      state.stateName ==
                                          controller.selectedState);
                                      if (!initialValueExists) {
                                        controller.changeSelectedState(
                                            stateList.isNotEmpty
                                                ? stateList
                                                .first.stateName
                                                : '');
                                      }
                                    }
                                    return AnimatedSwitcher(
                                      duration:
                                      const Duration(seconds: 1),
                                      child: stateList.isEmpty
                                          ? const Center(
                                          child:
                                          CircularProgressIndicator())
                                          : DropdownButtonFormField<
                                          String>(
                                        icon: const Icon(Icons
                                            .keyboard_arrow_down_outlined),
                                        decoration:
                                        InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border:
                                          OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  8)),
                                          contentPadding:
                                          const EdgeInsets
                                              .symmetric(
                                              horizontal: 5,
                                              vertical: 16),
                                          hintText:
                                          'Select State',
                                          hintStyle: const TextStyle(
                                              color: Colors
                                                  .grey), // Optional: hint text color
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        dropdownColor: Colors
                                            .white, // Set dropdown background color to white
                                        items: stateList.map<
                                            DropdownMenuItem<
                                                String>>(
                                                (StateColl state) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value:
                                                state.stateName,
                                                child: Text(
                                                    state.stateName,
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .black)),
                                              );
                                            }).toList(),
                                        value: controller
                                            .selectedState,
                                        onChanged: (value) =>
                                            controller
                                                .changeSelectedState(
                                                value!),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(seconds: 1),
                                  child: controller.cityList.isEmpty
                                      ? const Center(
                                      child:
                                      CircularProgressIndicator())
                                      : DropdownButtonFormField<String>(
                                    icon: const Icon(Icons
                                        .keyboard_arrow_down_outlined),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(8)),
                                      contentPadding:
                                      const EdgeInsets
                                          .symmetric(
                                          horizontal: 5,
                                          vertical: 16),
                                      hintText: 'Select City',
                                      hintStyle: const TextStyle(
                                          color: Colors
                                              .grey), // Optional: hint text color
                                    ),
                                    style: const TextStyle(
                                        color: Colors.black),
                                    dropdownColor: Colors
                                        .white, // Set dropdown background color to white
                                    items: controller.cityList
                                        .toSet()
                                        .map<
                                        DropdownMenuItem<
                                            String>>(
                                            (String city) {
                                          return DropdownMenuItem<
                                              String>(
                                            value: city,
                                            child: Text(city,
                                                style:
                                                const TextStyle(
                                                    color: Colors
                                                        .black)),
                                          );
                                        }).toList(),
                                    value: controller.cityList
                                        .contains(controller
                                        .selectedCity)
                                        ? controller.selectedCity
                                        : null,
                                    onChanged: (value) =>
                                        controller
                                            .changeSelectedCity(
                                            value!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 40.w,
                            child: TextFormField(
                              controller: controller
                                  .addressPinCodeEditingController,
                              decoration: InputDecoration(
                                hintText: 'Type Pincode',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8)),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: (value) {
                                if (value!.length == 6) {
                                  return null;
                                } else {
                                  return 'Pin code of 6 digit required';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add rounded corners
                          color: Colors
                              .white, // Background color for the row
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'We are available in above cities only! others are coming soon!',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.5.sp,
                                        ),
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     myWidgets.requiredField(),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       'Select T-shirt Size',
                          //       style: TextStyle(
                          //           fontSize: 10.sp,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 8),
                          // DropdownButtonFormField<String>(
                          //   decoration: InputDecoration(
                          //     filled: true,
                          //     fillColor: Colors.white,
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(
                          //         color: Colors.grey,
                          //       ),
                          //     ),
                          //     enabledBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(
                          //         color: Colors.grey,
                          //       ),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(
                          //         color: Colors.grey,
                          //       ),
                          //     ),
                          //     hintText: 'Select T-shirt Size',
                          //   ),
                          //   items: widget.controller.tshirtSizes
                          //       .map((size) => DropdownMenuItem<String>(
                          //             value: size,
                          //             child: Text(size),
                          //           ))
                          //       .toList(),
                          //   value: widget.controller.selectedTshirtSize,
                          //   onChanged: (value) => widget.controller
                          //       .changeSelectedTshirtSize(value),
                          // ),
                        ],
                      ),
                    ]
                        .map((e) => Padding(
                      padding:
                      const EdgeInsets.only(bottom: 16),
                      child: e,
                    ))
                        .toList(),
                  ),
                ),
              ),
            ))
            : const SizedBox());
  }
}
