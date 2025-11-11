import 'package:candid_vendors/Controllers/Auth/CreateProfileController.dart';
import 'package:candid_vendors/Screens/AuthScreens/CreateProfileSteps/CreateProfileStep1.dart';
import 'package:candid_vendors/Screens/AuthScreens/CreateProfileSteps/CreateProfileStep2.dart';
import 'package:candid_vendors/Screens/AuthScreens/CreateProfileSteps/CreateProfileStep3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CreateProfile extends StatelessWidget {
  final String mobileNumber;
  final String countryCode;
  final User user;

  const CreateProfile({
    super.key,
    this.mobileNumber = '',
    required this.user,
    this.countryCode = '+91',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            backgroundColor: const Color(0xFF00BADD),
            automaticallyImplyLeading: false, // Remove the back arrow
            title: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10), // Adjust the margin to move the content downwards
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/Images/stores.png',
                    width: 15.w,
                    height: 6.5.h,
                  ),
                  const SizedBox(width: 18),
                  Text(
                    'Seller Registration',
                    style: TextStyle(
                      color: const Color(0xFFF8F8F8),
                      fontSize: 16.sp,
                      fontFamily: 'Aileron',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: GetBuilder(
          init: CreateProfileController(
            mobileNumber: mobileNumber,
            user: user,
            countryCode: countryCode,
          ),
          builder: (controller) {
            List<Step> steps = [];
            steps.add(
              Step(
                title: const Text(
                  'Welcome to Candid Offers',
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 16,
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: const Text('Write personal details in this section!'),
                content: Column(
                  children: [
                    CreateProfileStep1(
                      controller: controller,
                      mobileNumber: '',
                      countryCode: '+91',
                      user: user,
                    ),
                  ],
                ),
                state: controller.selectedStep == 0 ? StepState.editing : StepState.complete,
                isActive: controller.selectedStep >= 0,
              ),
            );
            steps.add(
              Step(
                title: const Text('Kyc details'),
                subtitle: const Text('Write your Kyc details'),
                content: Column(
                  children: [CreateProfileStep2(controller: controller)],
                ),
                state: controller.selectedStep == 1
                    ? StepState.editing
                    : controller.selectedStep > 1
                    ? StepState.complete
                    : StepState.disabled,
                isActive: controller.selectedStep >= 1,
              ),
            );
            steps.add(
              Step(
                title: const Text('Payment'),
                subtitle: const Text('You can complete payment in this section to register successfully!'),
                content: Column(
                  children: [CreateProfileStep3(controller: controller)],
                ),
                state: controller.selectedStep == 2
                    ? StepState.editing
                    : controller.selectedStep >= 2
                    ? StepState.editing
                    : StepState.disabled,
                isActive: controller.selectedStep == 2,
              ),
            );
            return Stepper(
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: details.currentStep < 2 ||
                          controller.isPaymentDone &&
                              !controller.isLoading
                          ? SizedBox(
                        height: 5.h,
                        width: 33.w,
                        child: SizedBox(
                          width: 5.w,
                          height: 4.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: controller.onStepContinue,
                            child: Text(
                              details.currentStep == 2 ? 'Register' : 'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                          : const SizedBox(height: 10),
                    ),
                    const SizedBox(
                      width: 10,
                      height: 20,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: !controller.isLoading && !controller.isPaymentDone
                          ? SizedBox(
                        width: 33.w,
                        height: 5.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: controller.onStepCancel,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          : const SizedBox(height: 20,),
                    ),
                  ],
                );
              },
              onStepCancel: controller.onStepCancel,
              onStepContinue: controller.onStepContinue,
              onStepTapped: controller.onStepTapped,
              currentStep: controller.selectedStep,
              steps: steps,
              elevation: 10,
              physics: const AlwaysScrollableScrollPhysics(),
            );
          },
        ),
      ),
    );
  }
}