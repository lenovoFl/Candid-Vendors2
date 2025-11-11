// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:isar/isar.dart';
// import 'package:sizer/sizer.dart';
// import '../Controllers/Auth/CreateProfileController.dart';
// import '../Services/Collections/State/StateColl.dart';
// import '../main.dart';
//
// class SellerRegistrationScreen extends StatelessWidget {
//
//   static const double yourStoreLatitude = 37.7749;
//   static const double yourStoreLongitude = -122.4194;
//   final String mobileNumber;
//   final String countryCode;
//   final User user;
//
//   final CreateProfileController controller;
//   const SellerRegistrationScreen({super.key, this.mobileNumber = '',
//     required this.user,
//     this.countryCode = '+91', required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     bool storeAddressSameAsCompany = false;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size(double.infinity, 90),
//           child: AppBar(
//             backgroundColor: const Color(0xFF00BADD),
//             title: Row(
//               children: [
//                 Container(
//                   height: 100,
//                   width: 90,
//                   margin: const EdgeInsets.only(right: 60, top: 10),
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: AssetImage('lib/Images/stores.png'),
//                     ),
//                   ),
//                 ),
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Seller Registration',
//                       style: TextStyle(
//                         color: Color(0xFFF8F8F8),
//                         fontSize: 22,
//                         fontFamily: 'Aileron',
//                         fontWeight: FontWeight.w700,
//                         height: 0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             centerTitle: false,
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 1.h,),
//                 const Padding(
//                   padding: EdgeInsets.only(left: 130),
//                   child: Text(
//                     'Welcome to Candid Offers',
//                     style: TextStyle(
//                       color: Color(0xFFB0B0B0),
//                       fontSize: 16,
//                       fontFamily: 'Aileron',
//                       fontWeight: FontWeight.w400,
//                       height: 0.06,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20), // Adjust the height as needed
//                 Container(
//                   height: 8.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0), // Add rounded corners
//                     color: Colors.white, // Background color for the row
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 10.w,
//                         height: 3.h,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.green,
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.check_sharp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 6.h,
//                           width: 100.w,
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Company Information',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 1.h,),
//                 SizedBox(
//                   width: 326,
//                   height: 30,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Are you GST Registered?',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                           fontFamily: 'Aileron',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       Container(
//                         width: 15.w,
//                         height: 3.h,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFB4FFB2), // Background color for "Yes"
//                           borderRadius: BorderRadius.circular(10.0), // Rounded corners
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'Yes',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontFamily: 'Aileron',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 15.w,
//                         height: 3.h,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFFB2B2), // Background color for "No"
//                           borderRadius: BorderRadius.circular(10.0), // Rounded corners
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'No',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontFamily: 'Aileron',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 1.h,),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.gstEditingController,
//                   textAlign: TextAlign.center,
//                   textCapitalization: TextCapitalization.characters,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter GST number here!',
//                       label: const Text('Enter GST number'),
//                       suffixIcon: myWidgets.validateButtonForTxtField(
//                           title: 'Validate',
//                           onPress: controller.validateGSTBtnClickHandler)),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.streetAddress,
//                   onChanged: (value) {
//                     controller.gstEditingController.value =
//                         TextEditingValue(
//                             text: value.toUpperCase(),
//                             selection:
//                             controller.gstEditingController.selection);
//                   },
//                   maxLength: 15,
//                   validator: (gstNumber) =>
//                       utils.validateGSTNumber(gstNumber.toString()),
//                 ),
//                 myWidgets.requiredField(),
//                 DropdownButtonFormField(
//                   icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                   decoration: const InputDecoration(
//                       filled: true,
//                       border: OutlineInputBorder(),
//                       fillColor: Colors.transparent,
//                       labelText: 'Select Type of company',
//                       hintText: 'Select Type of company'),
//                   elevation: 16,
//                   style: const TextStyle(color: Colors.deepPurple),
//                   hint: const Text('Select Type of company'),
//                   items: controller.typeOfCompany
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value,
//                           style: const TextStyle(color: Colors.black)),
//                     );
//                   }).toList(),
//                   value: controller.selectedTypeOfCompany,
//                   onChanged: (value) =>
//                       controller.changeSelectedCompanyType(value!),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.companyNameEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter company name here!',
//                       label: const Text('Enter Company name')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.text,
//                   maxLength: 30,
//                   validator: (value) => utils.validateText(
//                       string: value.toString(), required: true),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.addressLine1EditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                     ),
//                     hintText: 'Enter address line 1 here!',
//                     label: const Text('Enter address line 1'),
//                   ),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.streetAddress,
//                   maxLength: 30,
//                   validator: (value) => utils.validateText(
//                       string: value.toString(), required: true),
//                 ),
//                 TextFormField(
//                   controller: controller.addressLine2EditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter address line 2 here!',
//                       label: const Text('Enter address line 2')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.streetAddress,
//                   maxLength: 30,
//                   validator: (value) => utils.validateText(
//                       string: value.toString(), required: false),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller:
//                   controller.addressBuildingStreetAreaEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText:
//                       'Enter building name, street and area here!',
//                       label: const Text('Enter building name, street and area')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.streetAddress,
//                   maxLength: 150,
//                   maxLines: 2,
//                   validator: (value) =>
//                       utils.validateTextAddress(value.toString()),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.addressPinCodeEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter pin code here!',
//                       label: const Text('Enter pin code')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.number,
//                   maxLength: 6,
//                   validator: (value) {
//                     if (value!.length == 6) {
//                       return null;
//                     } else {
//                       return 'Pin code of 6 digit required';
//                     }
//                   },
//                 ),
//                 Container(
//                   height: 8.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0), // Add rounded corners
//                     color: Colors.white, // Background color for the row
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 10.w,
//                         height: 3.h,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                             color: Color(0xFFFF971D),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.info_outline,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 6.h,
//                           width: 100.w,
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '   Owners Information',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 1.h,),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.fullNameEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.0), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter full name here!',
//                       label: const Text('Enter full name')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.text,
//                   maxLength: 20,
//                   validator: (value) => utils.validateText(
//                       string: value.toString(), required: true),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.emailIdEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.0), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter Email here!',
//                       label: const Text('Enter Email')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) =>
//                       utils.validateEmail(value.toString()),
//                 ),
//                 SizedBox(height: 1.h,),
//                 Align(
//                     alignment: Alignment.centerRight,
//                     child: GestureDetector(
//
//                       onTap: controller.sendVerificationEmail,
//                       child: Text(
//                         !firebaseAuth.currentUser!.emailVerified
//                             ? controller.isVerifyEmailSent
//                             ? 'verify Email sent!'
//                             : 'Send verification Email'
//                             : 'Email Verified!',
//                         textScaleFactor: 1.3,
//                         style: TextStyle(
//                             color: Colors.blue.shade900,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     )),
//                 SizedBox(height: 2.h,),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.panNoEditingController,
//                   textCapitalization: TextCapitalization.characters,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.0), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter PAN number here!',
//                       label: const Text('Enter PAN number'),
//                       suffixIcon: myWidgets.validateButtonForTxtField(
//                           title: 'Validate',
//                           onPress: controller.validatePanBtnClickHandler)),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.text,
//                   maxLength: 10,
//                   onChanged: (value) {
//                     controller.panNoEditingController.value =
//                         TextEditingValue(
//                             text: value.toUpperCase(),
//                             selection: controller
//                                 .panNoEditingController.selection);
//                   },
//                   validator: (value) =>
//                       utils.validatePanNumber(value.toString()),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.aadhaarNoEditingController,
//                   textCapitalization: TextCapitalization.characters,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.0), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter Aadhaar number here!',
//                       label: const Text('Enter Aadhaar number'),
//                       suffixIcon: myWidgets.validateButtonForTxtField(
//                           title: 'Validate',
//                           onPress:
//                           controller.getAadhaarOtpBtnClickHandler)),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.number,
//                   maxLength: 14,
//                   onChanged: controller.onAadhaarNumberChange,
//                   validator: (value) =>
//                       utils.validateAadhaarNumber(value.toString()),
//                 ),
//                 SizedBox(height: 2.h,),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                  // controller: controller.aadhaarNoEditingController,
//                   textCapitalization: TextCapitalization.characters,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.0), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Gumasta',
//                       label: const Text('Gumasta'),
//                     ),
//                 //  autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.number,
//                   maxLength: 14,
//           //        onChanged: controller.onAadhaarNumberChange,
//              //     validator: (value) =>
//               //        utils.validateAadhaarNumber(value.toString()),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//               //    controller: controller.companyNameEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.0), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter Parent company name here!',
//                       label: const Text('Enter  Parent Company name')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.text,
//                   maxLength: 30,
//                   validator: (value) => utils.validateText(
//                       string: value.toString(), required: true),
//                 ),
//                 myWidgets.requiredField(),
//                 Column(
//                   children: [
//                     Container(
//                       width: 90.w, // Set the desired width for the square border
//                       height: 8.h, // Set the desired height for the square border
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10), // You can adjust the border radius as needed
//                         border: Border.all(width: 1, color: Colors.black), // Border properties
//                       ),
//                       child: controller.aadhaarCardImage == null
//                           ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('Upload Aadhar Image'),
//                           OutlinedButton(
//                             onPressed: () {
//                               controller.selectOrCaptureAadhaarCardImage(fromCamera: false);
//                             },
//                             child: const Icon(Icons.upload_outlined),
//                           ),
//                         ],
//                       )
//                           : Image.file(
//                         File(controller.aadhaarCardImage!.path),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(height: 16), // Adjust the spacing as needed
//                     Row(
//                       children: [
//                         Expanded(
//                           child: FittedBox(
//                             child: myWidgets.getLargeButtonWithIcon(
//                               title: 'Select from Gallery',
//                               icon: Icons.browse_gallery_outlined,
//                               onPressed: () {
//                                 controller.selectOrCaptureAadhaarCardImage(fromCamera: false);
//                               },
//                               bgColor: Colors.black,
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(left: 8, right: 8),
//                           child: Text('OR', textScaleFactor: 1.7),
//                         ),
//                         Expanded(
//                           child: FittedBox(
//                             child: myWidgets.getLargeButtonWithIcon(
//                               title: 'Capture from Camera',
//                               icon: Icons.camera_alt_outlined,
//                               onPressed: () {
//                                 controller.selectOrCaptureAadhaarCardImage(fromCamera: true);
//                               },
//                               bgColor: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 myWidgets.requiredField(),
//                 Column(
//                   children: [
//                     if (controller.panCardImage != null)
//                       Column(
//                         children: [
//                           OutlinedButton(
//                             onPressed: () {
//                               controller.panCardImage = null;
//                               controller.update();
//                             },
//                             child: const Icon(Icons.close_outlined),
//                           ),
//                           SizedBox(
//                             height: 150, // Set the desired height for the square image container
//                             width: 150,  // Set the desired width for the square image container
//                             child: Image.file(
//                               File(controller.panCardImage!.path),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ],
//                       ),
//                     Container(
//                       width: 90.w, // Set the desired width for the square border
//                       height: 8.h,  // Set the desired height for the square border
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10), // You can adjust the border radius as needed
//                         border: Border.all(width: 1, color: Colors.black), // Border properties
//                       ),
//                       child: controller.panCardImage == null
//                           ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('Upload Pan Card Image'),
//                           OutlinedButton(
//                             onPressed: () {
//                               controller.selectOrCapturePanCardImage(fromCamera: false);
//                             },
//                             child: const Icon(Icons.upload_outlined),
//                           ),
//                         ],
//                       )
//                           : const SizedBox(),
//                     ),
//                     const SizedBox(height: 16), // Adjust the spacing as needed
//                     Row(
//                       children: [
//                         Expanded(
//                           child: FittedBox(
//                             child: myWidgets.getLargeButtonWithIcon(
//                               title: 'Select from Gallery',
//                               icon: Icons.browse_gallery_outlined,
//                               onPressed: () {
//                                 controller.selectOrCapturePanCardImage(fromCamera: false);
//                               },
//                               bgColor: Colors.black,
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(left: 8, right: 8),
//                           child: Text('OR', textScaleFactor: 1.7),
//                         ),
//                         Expanded(
//                           child: FittedBox(
//                             child: myWidgets.getLargeButtonWithIcon(
//                               title: 'Capture from Camera',
//                               icon: Icons.camera_alt_outlined,
//                               onPressed: () {
//                                 controller.selectOrCapturePanCardImage(fromCamera: true);
//                               },
//                               bgColor: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 myWidgets.requiredField(),
//                 Column(
//                   children: [
//                     if (controller.personalImage != null)
//                       Column(
//                         children: [
//                           OutlinedButton(
//                             onPressed: () {
//                               controller.personalImage = null;
//                               controller.update();
//                             },
//                             child: const Icon(Icons.close_outlined),
//                           ),
//                           SizedBox(
//                             height: 150, // Set the desired height for the square image container
//                             width: 150,  // Set the desired width for the square image container
//                             child: Image.file(
//                               File(controller.personalImage!.path),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ],
//                       ),
//                     Container(
//                       width: 90.w, // Set the desired width for the square border
//                       height: 8.h,  // Set the desired height for the square border
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10), // You can adjust the border radius as needed
//                         border: Border.all(width: 1, color: Colors.black), // Border properties
//                       ),
//                       child: controller.personalImage == null
//                           ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('Upload Personal Image'),
//                           OutlinedButton(
//                             onPressed: () {
//                               controller.selectPersonalImage();
//                             },
//                             child: const Icon(Icons.upload_outlined),
//                           ),
//                         ],
//                       )
//                           : const SizedBox(), // Hide the text and button when an image is selected
//                     ),
//                     const SizedBox(height: 16), // Adjust the spacing as needed
//                     Row(
//                       children: [
//                         Expanded(
//                           child: FittedBox(
//                             child: myWidgets.getLargeButtonWithIcon(
//                               title: 'Select from Gallery',
//                               icon: Icons.browse_gallery_outlined,
//                               onPressed: () {
//                                 controller.selectPersonalImage();
//                               },
//                               bgColor: Colors.black,
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(left: 8, right: 8),
//                           child: Text('OR', textScaleFactor: 1.7),
//                         ),
//                         Expanded(
//                           child: FittedBox(
//                             child: myWidgets.getLargeButtonWithIcon(
//                               title: 'Capture from Camera',
//                               icon: Icons.camera_alt_outlined,
//                               onPressed: () {
//                                 controller.capturePersonalImage();
//                               },
//                               bgColor: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   height: 8.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0), // Add rounded corners
//                     color: Colors.white, // Background color for the row
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 10.w,
//                         height: 3.h,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFFFF971D),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.info_outline,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 6.h,
//                           width: 100.w,
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '   Store information',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 myWidgets.requiredField(),
//                 Container(
//                   height: 5.h, // Adjust the height as needed
//                   width: double.infinity,
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0), // Add rounded corners
//                     color: Colors.black, // Background color for the square box
//                   ),
//                   child: TextButton(
//                     onPressed: () async {
//                       // Add your logic to open the camera or gallery here
//                       final ImagePicker _picker = ImagePicker();
//                       final XFile? image = await _picker.pickImage(
//                         source: ImageSource.camera, // You can also use ImageSource.gallery
//                         maxWidth: 800,
//                         maxHeight: 600,
//                       );
//
//                       if (image != null) {
//                         // Handle the selected image (you can save it or use it as needed)
//                       }
//                     },
//                     child: const Text(
//                       'Take Picture of your store/outlet and upload',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                 myWidgets.requiredField(),
//                 Text(
//                   'Referred by',
//                   style: TextStyle(color: Colors.blue.shade900),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Radio<String>(
//                       value: 'Self',
//                       groupValue: controller.referBy,
//                       onChanged: (String? value) {
//                         controller.referBy = value.toString();
//                         controller.update();
//                       },
//                     ),
//                     Text(
//                       'Self',
//                       style: TextStyle(color: Colors.blue.shade900),
//                     ),
//                     Radio<String>(
//                       value: 'Champion',
//                       groupValue: controller.referBy,
//                       onChanged: (String? value) {
//                         controller.referBy = value.toString();
//                         controller.update();
//                       },
//                     ),
//                     Text(
//                       'Champion',
//                       style: TextStyle(color: Colors.blue.shade900),
//                     ),
//                   ],
//                 ),
//                 AnimatedSwitcher(
//                   duration: const Duration(seconds: 1),
//                   child: controller.referBy == 'Self'
//                       ? const SizedBox()
//                       : controller.championList.isEmpty
//                       ? const Text('No champion available')
//                       : DropdownButtonFormField(
//                     decoration: const InputDecoration(
//                       filled: true,
//                       border: OutlineInputBorder(),
//                       fillColor: Colors.transparent,
//                       labelText: 'Select Champion ID',
//                     ),
//                     isExpanded: true,
//                     elevation: 16,
//                     style:
//                     const TextStyle(color: Colors.black),
//                     hint: const Text(
//                       'Select Champion ID',
//                     ),
//                     items: controller.championList
//                         .map<DropdownMenuItem<String>>(
//                             (String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                     color: Colors.black)),
//                           );
//                         }).toList(),
//                     value: controller.selectedChampionID,
//                     onChanged: (selectedChampionID) {
//                       controller.selectedChampionID =
//                           selectedChampionID.toString();
//                       controller.update();
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 myWidgets.requiredField(),
//                 Card(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: const BorderSide(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//                   ),
//                   child: SizedBox(
//                     width: 90.w,
//                     height: 23.h,
//                     child: Stack(
//                       children: [
//                         const Positioned(
//                           left: 10,
//                           top: 10,
//                           child: Text.rich(
//                             TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: 'Vendor Category',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 12,
//                                     fontFamily: 'Aileron',
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: 0,
//                           top: 27,
//                           child: SizedBox(
//                             width: 320,
//                             height: 150,
//                             child: Stack(
//                               children: [
//                                 for (int i = 0; i < 3; i++)
//                                   Positioned(
//                                     left: 43,
//                                     top: 62 + i * 30,
//                                     child: Text(
//                                       i == 0 ? 'Products' : (i == 1 ? 'Services' : 'Both'),
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 12,
//                                         fontFamily: 'Aileron',
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ),
//                                 const Positioned(
//                                   left: 16,
//                                   top: 18,
//                                   child: Text(
//                                     'Select your applicable category',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 12,
//                                       fontFamily: 'Aileron',
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                                 for (int i = 0; i < 3; i++)
//                                   Positioned(
//                                     left: 15,
//                                     top: 59 + i * 30,
//                                     child: Container(
//                                       width: 19,
//                                       height: 19,
//                                       decoration: ShapeDecoration(
//                                         shape: RoundedRectangleBorder(
//                                           side: const BorderSide(width: 1, color: Color(0xFFC4C4C4)),
//                                           borderRadius: BorderRadius.circular(4),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//                 SizedBox(height: 1.h,),
//                 myWidgets.getLargeButton(
//                   onPress: controller.showMultiSelect,
//                   bgColor: Colors.black,
//                   txtScale: 1.3,
//                   title: 'Select Categories',
//                 ),
//                 const Divider(
//                   height: 30,
//                 ),
//                 Wrap(
//                   children: controller.selectedCatsList
//                       .map((e) => Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Chip(
//                       label: Text(e['catName']!),
//                     ),
//                   ))
//                       .toList(),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     myWidgets.requiredField(),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'Name of the outlet',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       controller: controller.companyNameEditingController,
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         hintText: 'Type Your company name here!',
//                         label: const Text('Type Your Company name'),
//                       ),
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       keyboardType: TextInputType.text,
//                       maxLength: 30,
//                       validator: (value) => utils.validateText(
//                         string: value.toString(),
//                         required: true,
//                       ),
//                     ),
//                     myWidgets.requiredField(),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CheckboxListTile(
//                         title: const Text('Store address same as company address if not please fill in the details' ,
//                           style: TextStyle(
//                           color: Colors.black, // Text color
//                           fontSize: 15, // Font size
//                           fontFamily: 'Aileron', // Font family
//                           fontWeight: FontWeight.w700, // Font weight
//                         ),
//                         ),
//                         value: storeAddressSameAsCompany,
//                         onChanged: (newValue) {
//                           // Handle checkbox state change
//                           // You can set the value to a variable or update your state accordingly
//                           // For example: setState(() { storeAddressSameAsCompany = newValue; });
//                         },
//                         controlAffinity: ListTileControlAffinity.leading,
//                         checkColor: Colors.black, // Color of the tick mark
//                         activeColor: Colors.grey, // Color of the checkbox when selected
//                       ),
//                     ),
//                   ],
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.addressLine1EditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                     ),
//                     hintText: 'Enter address line 1 here!',
//                     label: const Text('Enter address line 1'),
//                   ),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.streetAddress,
//                   maxLength: 30,
//                   validator: (value) => utils.validateText(
//                       string: value.toString(), required: true),
//                 ),
//                 TextFormField(
//                   controller: controller.addressLine2EditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter address line 2 here!',
//                       label: const Text('Enter address line 2')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.streetAddress,
//                   maxLength: 30,
//                   validator: (value) => utils.validateText(
//                       string: value.toString(), required: false),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller:
//                   controller.addressBuildingStreetAreaEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText:
//                       'Enter building name, street and area here!',
//                       label: const Text('Enter building name, street and area')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.streetAddress,
//                   maxLength: 150,
//                   maxLines: 2,
//                   validator: (value) =>
//                       utils.validateTextAddress(value.toString()),
//                 ),
//                 myWidgets.requiredField(),
//                 TextFormField(
//                   controller: controller.addressPinCodeEditingController,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
//                       ),
//                       hintText: 'Enter pin code here!',
//                       label: const Text('Enter pin code')),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   keyboardType: TextInputType.number,
//                   maxLength: 6,
//                   validator: (value) {
//                     if (value!.length == 6) {
//                       return null;
//                     } else {
//                       return 'Pin code of 6 digit required';
//                     }
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           myWidgets.requiredField(),
//                           AnimatedSwitcher(
//                             duration: const Duration(seconds: 1),
//                             child: controller.cityList.isEmpty
//                                 ? const Center(
//                               child: CircularProgressIndicator(),
//                             )
//                                 : DropdownButtonFormField(
//                               icon: const Icon(Icons.arrow_downward_rounded),
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 fillColor: Colors.transparent,
//                                 labelText: 'Select City',
//                               ),
//                               elevation: 16,
//                               style: const TextStyle(color: Colors.deepPurple),
//                                   hint: const Text('Select City'),
//                               items: controller.cityList
//                                   .map<DropdownMenuItem<String>>((String city) {
//                                 return DropdownMenuItem<String>(
//                                   value: city,
//                                   child: Text(city, style: const TextStyle(color: Colors.black)),
//                                 );
//                               }).toList(),
//                               value: controller.selectedCity,
//                               onChanged: (value) {
//                                 controller.changeSelectedCity(value!);
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//
//
//                 Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           myWidgets.requiredField(),
//                           StreamBuilder(
//                             stream: isar.stateColls.where().build().watch(fireImmediately: true),
//                             builder: (context, snapshot) {
//                               List<StateColl> stateList = [];
//                               if (snapshot.hasError) {
//                                 return const Text('Error or not having data to show!');
//                               }
//                               if (snapshot.hasData) {
//                                 stateList = snapshot.data as List<StateColl>;
//                               }
//                               return AnimatedSwitcher(
//                                 duration: const Duration(seconds: 1),
//                                 child: stateList.isEmpty
//                                     ? const Center(
//                                   child: CircularProgressIndicator(),
//                                 )
//                                     : DropdownButtonFormField(
//                                   icon: const Icon(Icons.arrow_downward_rounded),
//                                   decoration: InputDecoration(
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     fillColor: Colors.transparent,
//                                     labelText: 'Select State',
//                                     hintText: 'Select State',
//                                   ),
//                                   elevation: 16,
//                                   style: const TextStyle(color: Colors.deepPurple),
//                                   hint: const Text('Select State'),
//                                   items: stateList.map<DropdownMenuItem<String>>(
//                                         (StateColl state) {
//                                       return DropdownMenuItem<String>(
//                                         value: state.stateName,
//                                         child: Text(state.stateName, style: const TextStyle(color: Colors.black)),
//                                       );
//                                     },
//                                   ).toList(),
//                                   onChanged: (value) {
//                                     controller.changeSelectedState(value!);
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 1.h,),
//                 const Text(
//                   "We're available in above cities only, others are coming soon!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 Container(
//                   height: 8.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0), // Add rounded corners
//                     color: Colors.white, // Background color for the row
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 10.w,
//                         height: 3.h,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFFFF971D),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.info_outline,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 6.h,
//                           width: 100.w,
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '   Bank information',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             Column(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(
//                       left: 1, right: 200),
//                   child: Text(
//                     'Bank Acoount Number',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontFamily: 'Aileron',
//                       fontWeight:
//                       FontWeight.w700,
//                       height: 0,
//                     ), // Change hint text color
//                   ),
//                 ),
//                 TextFormField(
//                   controller: controller
//                       .bankAccountHolderAcNumberController,
//                   textCapitalization:
//                   TextCapitalization
//                       .characters,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                     border:
//                     OutlineInputBorder(
//                       borderRadius:
//                       BorderRadius
//                           .circular(10.0),
//                       // Adjust the radius as needed
//                       borderSide:
//                       const BorderSide(
//                           color: Colors
//                               .black),
//                     ),
//                     // hintText: 'Enter account number here',
//                   ),
//                   autovalidateMode:
//                   AutovalidateMode
//                       .onUserInteraction,
//                   keyboardType:
//                   TextInputType.number,
//                   maxLength: 18,
//                   validator: (value) => utils
//                       .validateBankAccountNumber(
//                     value.toString(),
//                     controller
//                         .bankAccountHolderAc1NumberController
//                         .text,
//                   ),
//                   obscureText: true,
//                 ),
//               ],
//             ),
//
//             Column(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(
//                       left: 1, right: 200),
//                   child: Text(
//                     'Re-Enter Bank account Number',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontFamily: 'Aileron',
//                       fontWeight:
//                       FontWeight.w700,
//                       height: 0,
//                     ), //, // Change hint text color
//                   ),
//                 ),
//                 TextFormField(
//                   controller: controller
//                       .bankAccountHolderAc1NumberController,
//                   textCapitalization:
//                   TextCapitalization
//                       .characters,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                     border:
//                     OutlineInputBorder(
//                       borderRadius:
//                       BorderRadius
//                           .circular(10.0),
//                       // Adjust the radius as needed
//                       borderSide:
//                       const BorderSide(
//                           color: Colors
//                               .black),
//                     ),
//                     hintText: '',
//                   ),
//                   autovalidateMode:
//                   AutovalidateMode
//                       .onUserInteraction,
//                   keyboardType:
//                   TextInputType.number,
//                   maxLength: 18,
//                   validator: (value) => utils
//                       .validateBankAccountNumber(
//                     controller
//                         .bankAccountHolderAcNumberController
//                         .text,
//                     value.toString(),
//                   ),
//                 ),
//               ],
//             ),
//
//             // Column(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(
//                       left: 1, right: 200),
//                   child: Text(
//                     'Enter account IFSC code',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontFamily: 'Aileron',
//                       fontWeight:
//                       FontWeight.w700,
//                       height: 0,
//                     ), // // Change hint text color
//                   ),
//                 ),
//                 TextFormField(
//                   controller: controller
//                       .bankAccountHolderIFSCController,
//                   textCapitalization:
//                   TextCapitalization
//                       .characters,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                     border:
//                     OutlineInputBorder(
//                       borderRadius:
//                       BorderRadius
//                           .circular(10.0),
//                       // Adjust the radius as needed
//                       borderSide:
//                       const BorderSide(
//                           color: Colors
//                               .black),
//                     ),
//                     //       hintText: 'Enter account IFSC code here',
//                   ),
//                   autovalidateMode:
//                   AutovalidateMode
//                       .onUserInteraction,
//                   keyboardType:
//                   TextInputType.text,
//                   maxLength: 11,
//                   validator: (value) => utils
//                       .validateBankIFSCCode(
//                     value.toString(),
//                     controller
//                         .bankAccountHolderIFSC1Controller
//                         .text,
//                   ),
//                 ),
//               ],
//             ),
//
//             Column(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(
//                         left: 1, right: 220),
//                     child: Text(
//                       'Re-Enter IFSC Code',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                         fontFamily: 'Aileron',
//                         fontWeight:
//                         FontWeight.w700,
//                         height: 0,
//                       ), // // Change hint text color
//                     ),
//                   ),
//                   TextFormField(
//                     controller: controller
//                         .bankAccountHolderIFSC1Controller,
//                     textCapitalization:
//                     TextCapitalization
//                         .characters,
//                     textAlign: TextAlign.center,
//                     decoration: InputDecoration(
//                       border:
//                       OutlineInputBorder(
//                         borderRadius:
//                         BorderRadius
//                             .circular(10.0),
//                         // Adjust the radius as needed
//                         borderSide:
//                         const BorderSide(
//                             color: Colors
//                                 .black),
//                       ),
//                       hintText: '',
//                     ),
//                     autovalidateMode:
//                     AutovalidateMode
//                         .onUserInteraction,
//                     keyboardType:
//                     TextInputType.text,
//                     maxLength: 11,
//                     validator: (value) => utils
//                         .validateBankIFSCCode(
//                       controller
//                           .bankAccountHolderIFSCController
//                           .text,
//                       value.toString(),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                 SizedBox(height: 2.h,),
//                 const Text(
//                   "Locate your Store on Google Maps ",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.black, // Text color
//                     fontSize: 15, // Font size
//                     fontFamily: 'Aileron', // Font family
//                     fontWeight: FontWeight.w700, // Font weight
//                   ),
//                 ),
//                 SizedBox(height: 2.h,),
//                 Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15), // Adjust the value as needed
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15), // Use the same value as above
//                     child: GoogleMap(
//                       initialCameraPosition: const CameraPosition(
//                         target: LatLng(yourStoreLatitude, yourStoreLongitude),
//                         zoom: 15,
//                       ),
//                       markers: Set<Marker>.from([
//                         const Marker(
//                           markerId: MarkerId("Your Store"),
//                           position: LatLng(yourStoreLatitude, yourStoreLongitude),
//                           // Add more properties like icon, infoWindow, etc. if needed
//                         ),
//                       ]),
//                       onMapCreated: (GoogleMapController controller) {
//                         // You can use the controller to interact with the map if needed
//                       },
//                     ),
//                   ),
//                 ),
//
//
//                 SizedBox(height: 1.h,),
//                 Row(
//                   children: [
//                     Center(
//                       child: Checkbox(
//                         value: controller.acceptedTermsAndCondition,
//                         onChanged: (value) {
//                           controller.acceptedTermsAndCondition = value!;
//                           controller.update();
//                         },
//                       ),
//                     ),
//                     const Expanded(
//                       child: Text(
//                         'I agree Terms and condiditon',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         textScaleFactor: 1,
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 35, // Adjust the height to your desired value
//                   //   width: 300, // Adjust the width to your desired value
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                     ),
//                     onPressed: controller.showPoliciesView,
//                     child: const Text(
//                       'Click to Read our policies',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 2.h,),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Show a loading screen while you prepare the account details.
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) {
//                           return const Center(
//                             child: CircularProgressIndicator(), // You can customize the loading screen as needed.
//                           );
//                         },
//                       );
//
//                       // Simulate loading account details for 2 seconds (you can replace this with actual data loading).
//                       Future.delayed(const Duration(seconds: 2), () {
//                         // Pop the loading screen.
//                         Navigator.pop(context);
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white, backgroundColor: Colors.black,
//                       fixedSize: const Size(320, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text('PROCCED'),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 const Center(
//                   child: Text(
//                     '@ Candid Offers.',
//                     style: TextStyle(
//                       color: Color(0xFFB0B0B0),
//                       fontSize: 12,
//                       fontFamily: 'Aileron',
//                       fontWeight: FontWeight.w400,
//                       height: 0,
//                     ),
//                   ),
//                 ),
//               ]
//               ),
//       ]    ),
//         ),
//       ),
//       ) );
//   }
// }
