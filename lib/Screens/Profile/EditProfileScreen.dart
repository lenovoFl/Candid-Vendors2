import 'package:candid_vendors/Controllers/Profile/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileController profileController;

  const EditProfileScreen({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: profileController,
      builder: (controller) {
        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: profileController.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: profileController.editProfileFormKey,
                  child: FractionallySizedBox(
                    widthFactor: 0.90,
                    heightFactor: 0.90,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: profileController.emailController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter email',
                                    border: OutlineInputBorder()),
                                maxLength: 50,
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                validator: (value) => utils.validateEmail(value!),
                              ),
                              TextFormField(
                                controller: profileController.addressController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter address',
                                    border: OutlineInputBorder()),
                                maxLength: 200,
                                keyboardType: TextInputType.streetAddress,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 3,
                                validator: (value) =>
                                    utils.validateText(string: value!, required: true),
                              ),
                              TextFormField(
                                controller: profileController.contactController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter Contact',
                                    border: OutlineInputBorder()),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                validator: (value) => utils.validateMobileNumber(value!),
                              ),
                              myWidgets.getLargeButton(
                                  title: 'Update!',
                                  bgColor: Colors.blue.shade900,
                                  txtScale: 1.5,
                                  onPress: profileController.updateProfile),
                            ]
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: e,
                                    ))
                                .toList()),
                      ),
                    ),
                  )),
        );
      },
    );
  }
}
