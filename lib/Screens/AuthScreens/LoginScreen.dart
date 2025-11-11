import 'dart:async';
import 'package:candid_vendors/Controllers/Auth/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isTermsAccepted = false;
  bool isOtpSent = false;

  void showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'lib/Images/stores.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        ' CANDID OFFERS SELLER\n TERMS AND CONDITIONS',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.black, thickness: 1.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Section(
                            "1. Introduction",
                            "Welcome to Candid Offers Seller Platform. By using our app, you agree to comply with the following Terms and Conditions. These terms govern your access to and use of all our services.",
                          ),
                          Section(
                            "2. Eligibility",
                            "You must be at least 18 years old to use this platform. By registering, you confirm that the information you provide is accurate and complete.",
                          ),
                          Section(
                            "3. Account Responsibilities",
                            "You are responsible for maintaining the confidentiality of your account credentials. Any activity under your account will be considered as your responsibility.",
                          ),
                          Section(
                            "4. Data Privacy",
                            "We respect your privacy. Your data will be used solely for providing and improving services, and will not be shared without your consent.",
                          ),
                          Section(
                            "5. Seller Obligations",
                            "All sellers must provide accurate product details, adhere to fair pricing, and ensure product quality. Misleading information or fake products are strictly prohibited.",
                          ),
                          Section(
                            "6. Payments & Transactions",
                            "All payments are processed through our secure payment gateway. Transaction records will be maintained for verification and audits.",
                          ),
                          Section(
                            "7. Termination of Account",
                            "Candid Offers reserves the right to suspend or terminate accounts found violating these terms, without prior notice.",
                          ),
                          Section(
                            "8. Limitation of Liability",
                            "Candid Offers shall not be liable for any indirect or consequential losses arising from the use of our services.",
                          ),
                          Section(
                            "9. Changes to Terms",
                            "We may update or revise these Terms and Conditions at any time. You will be notified of any major changes through the app.",
                          ),
                          Section(
                            "10. Contact Information",
                            "For any queries regarding these Terms, please contact us at support@candidoffers.com.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        acceptTermsAndConditions();
                        Navigator.of(context).pop();
                      },
                      child:   Text('Accept',style: GoogleFonts.workSans(color: Colors.green) ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:   Text('Cancel',style: GoogleFonts.workSans(color: Colors.red) ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void acceptTermsAndConditions() {
    setState(() {
      isTermsAccepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: GetBuilder(
            init: LoginController(),
            builder: (controller) {
              final bool isRegisteredUser = controller.isRegisteredUser();
              if (isRegisteredUser) {
                isTermsAccepted = true;
              }

              return SingleChildScrollView(
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 6.h),
                          child: SvgPicture.asset(
                            'lib/Images/Layer_1-2.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Welcome",
                          style: GoogleFonts.workSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF524B6B),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Explore limitless possibilities, Achieve\nfinancial freedom with seller central.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.workSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF524B6B),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Form(
                                key: controller.loginRegisterFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontFamily: 'Aileron',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF524B6B),
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    TextFormField(
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        hintText: '1234567890',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                      ),
                                      initialValue: controller.mobileNumber,
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      onChanged: (updatedMobileNumber) =>
                                          controller.updateMobileNumber(
                                              updatedMobileNumber),
                                      validator: (value) =>
                                          utils.validateMobileNumber(
                                              value.toString()),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(350, 50),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isTermsAccepted
                              ? () async {
                            showCircularIndicator(context);
                            await Future.delayed(const Duration(seconds: 1));
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                const ImageDisplayScreen(),
                              ),
                            );
                            controller.loginButtonPress(
                              '${controller.dropdownSelectedValue.substring(controller.dropdownSelectedValue.indexOf('+'))} ${controller.mobileNumber}',
                            );
                          }
                              : null,
                          child: Text(
                            'SEND OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        if (!isRegisteredUser)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: isTermsAccepted,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isTermsAccepted = value ?? false;
                                  });
                                },
                              ),
                              const Text('I agree ', style: TextStyle(color: Colors.grey)),
                              GestureDetector(
                                onTap: showTermsAndConditionsDialog,
                                child: const Text(
                                  'Terms and Conditions',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        persistentFooterButtons: [
          Center(
            child: Text(
              'By Continuing, you agree to Candid Offers\nTerms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: const Color(0xFF524B6B),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String content;
  const Section(this.title, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Aileron',
              fontWeight: FontWeight.w700,
            ),
          ),
        SizedBox(height: 1.h),
        Text(
          content,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Aileron',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ImageDisplayScreen extends StatefulWidget {
  const ImageDisplayScreen({super.key});
  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer timer) {
      setState(() {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              Image.asset('lib/Images/01-slider (1).png', fit: BoxFit.cover),
              Image.asset('lib/Images/Spash Screen 3.jpg', fit: BoxFit.cover),
              Image.asset('lib/Images/Splash Screen 2.jpg', fit: BoxFit.cover),
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

void showCircularIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                'Processing. Welcome to The Candid Offers',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// class EmailLoginScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final LoginController controller;
//   final GlobalKey<FormState> emailLoginFormKey = GlobalKey<FormState>();
//
//   EmailLoginScreen({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Email Login',style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 16.0,
//           color: Colors.black,
//         ),),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: emailLoginFormKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 25.h,
//                     width: 43.w,
//                     padding: EdgeInsets.only(top: 3.h),
//                     child: const Image(
//                       fit: BoxFit.fill,
//                       image: AssetImage('lib/Images/stores.png'),
//                     ),
//                   ),
//                   SizedBox(height: 5.h,),
//                   const Text(
//                     'Email Verification',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.0,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: TextFormField(
//                       controller: emailController,
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         contentPadding: EdgeInsets.all(10.0),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: TextFormField(
//                       controller: passwordController,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Password',
//                         contentPadding: EdgeInsets.all(10.0),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50.0,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (emailLoginFormKey.currentState!.validate()) {
//                           String email = emailController.text.trim();
//                           String password = passwordController.text.trim();
//                           controller.emailLoginButtonPress(email, password);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(0),
//                         ),
//                       ),
//                       child: const Text('Login',style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                         color: Colors.white,
//                       ),),
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }