import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../Controllers/Auth/VerifyMobileController.dart';
import '../../main.dart';

class VerifyNumber extends StatelessWidget {
  final String mobileNumber, countryCode;
  final bool isSignInProcess;

  const VerifyNumber({
    super.key,
    required this.mobileNumber,
    required this.isSignInProcess,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: GetBuilder(
            init: VerifyMobileController(
              mobileNumber: mobileNumber,
              isSignInProcess: isSignInProcess,
              countryCode: countryCode,
            ),
            builder: (
                VerifyMobileController controller,
                ) {
              return AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              // height: 35.h,
                              // width: 50.w,
                              padding: EdgeInsets.only(top: 6.h),
                              child: SvgPicture.asset(
                                'lib/Images/Layer_1-2.svg', // Path to your SVG asset
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h,),
                            Center(
                            child: Column(
                              children: [
                                Text(
                                  " Plz Verify Your OTP!",
                                  style: GoogleFonts.workSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h,),
                          Form(
                            key: controller.verifyPhoneFormKey,
                            child: Center(
                              child: FractionallySizedBox(
                                widthFactor: 0.90,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          focusNode: controller.focus1,
                                          controller: controller.otp1Controller,
                                          textAlign: TextAlign.center,
                                          autofocus: true,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(color: Colors.grey)),
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          onChanged: (updatedOTP) {
                                            if (updatedOTP.length == 1) {
                                              controller.focus2.requestFocus();
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter OTP';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          focusNode: controller.focus2,
                                          controller: controller.otp2Controller,
                                          textAlign: TextAlign.center,
                                          autofocus: false,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(color: Colors.grey)),
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          onChanged: (updatedOTP) {
                                            if (updatedOTP.length == 1) {
                                              controller.focus3.requestFocus();
                                            } else if (updatedOTP.isEmpty) {
                                              controller.focus1.requestFocus();
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter OTP';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          focusNode: controller.focus3,
                                          controller: controller.otp3Controller,
                                          textAlign: TextAlign.center,
                                          autofocus: false,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(color: Colors.grey)),
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          onChanged: (updatedOTP) {
                                            if (updatedOTP.length == 1) {
                                              controller.focus4.requestFocus();
                                            } else if (updatedOTP.isEmpty) {
                                              controller.focus2.requestFocus();
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter OTP';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          focusNode: controller.focus4,
                                          controller: controller.otp4Controller,
                                          textAlign: TextAlign.center,
                                          autofocus: false,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(color: Colors.grey)),
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          onChanged: (updatedOTP) {
                                            if (updatedOTP.length == 1) {
                                              controller.focus5.requestFocus();
                                            } else if (updatedOTP.isEmpty) {
                                              controller.focus3.requestFocus();
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter OTP';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          focusNode: controller.focus5,
                                          controller: controller.otp5Controller,
                                          textAlign: TextAlign.center,
                                          autofocus: false,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(color: Colors.grey)),
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          onChanged: (updatedOTP) {
                                            if (updatedOTP.length == 1) {
                                              controller.focus6.requestFocus();
                                            } else if (updatedOTP.isEmpty) {
                                              controller.focus4.requestFocus();
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter OTP';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          focusNode: controller.focus6,
                                          controller: controller.otp6Controller,
                                          textAlign: TextAlign.center,
                                          autofocus: false,
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(color: Colors.grey)),
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          onChanged: (updatedOTP) {
                                            if (updatedOTP.isEmpty) {
                                              controller.focus5.requestFocus();
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter OTP';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h,),
                           Center(child: Text('Enter the 6 Digit code sent on your number',style: GoogleFonts.workSans(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),)),
                          SizedBox(height: 3.h,),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(335, 50), // Set your custom width and height
                                backgroundColor: Colors.black,   // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Rounded corners if needed
                                ),
                              ),
                              onPressed: controller.verifyOTP, // Call the verifyOTP function
                              child:   Text(
                                'VERIFY',
                                style: GoogleFonts.workSans(
                                  color: Colors.white, // Text color
                                  fontSize: 16,        // Text size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h,),
                          Opacity(
                            opacity: controller.enableResend? 1 : 0.3,
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                    text: 'Did not recieve OTP ?  ',
                                    style:   GoogleFonts.workSans(color: Colors.grey),
                                    children: [
                                      TextSpan(
                                        text: ' Resend OTP ${utils.formattedTime(timeInSecond: controller.secondsRemaining)!= '00 : 00'? ' in ${utils.formattedTime(timeInSecond: controller.secondsRemaining)} Sec' : ''}',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = controller.enableResend
                                              ? controller.sendOTP
                                              : null,
                                        style:   GoogleFonts.workSans(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.normal,
                                             ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        persistentFooterButtons:   [
          Center(
            child: Text(
              'By Continuing, you agree to Candid offers\nTerms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
