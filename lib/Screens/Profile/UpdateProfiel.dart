import 'package:candid_vendors/Controllers/Profile/ProfileController.dart';
import 'package:flutter/material.dart';
import '../../Services/APIs/Auth/UpdateProfile.dart';
import '../../Services/Collections/User/VendorUserColl.dart';
import '../../main.dart'; // Import the UpdateProfile class

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final ProfileController _controller = ProfileController();
  bool isProfileImgUpdateOnly = false;
  late final VendorUserColl? currentUser;
  final UpdateProfile _updateProfileApi = UpdateProfile(); // Create an instance of UpdateProfile

  @override
  void dispose() {
    _controller.emailController.dispose();
    _controller.addressController.dispose();
    _controller.contactController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    Map<String, String> userData = {
      'userEmail1': _controller.emailController.text,
      'userAddress': _controller.addressController.text,
      'userMobile1': _controller.contactController.text,
      'firebaseMessagingToken': _controller.user?.firebaseMessagingToken ?? '',
    };

    try {
      await _updateProfileApi.updateProfileApi( // Call the method on the instance
        isProfileImgUpdateOnly: false, // Since we are updating everything, set this to false
        userData: userData,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
          Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: TextField(
            controller: TextEditingController(
                text: localSeller.userEmail1),
            obscureText: false,
            readOnly: false,
            textAlign: TextAlign.start,
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 16,
              color: Color(0xff000000),
            ),
            decoration: InputDecoration(
              disabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                    color: Color(0xff000000), width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                    color: Color(0xff000000), width: 1),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                    color: Color(0xff000000), width: 1),
              ),
              labelText: "Email",
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff444444),
              ),
              filled: true,
              fillColor: const Color(0xffffffff),
              isDense: false,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
          ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: TextField(
                  controller: TextEditingController(text: localSeller.userAddress),
                  obscureText: false,
                  readOnly: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(
                          color: Color(0xff000000), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(
                          color: Color(0xff000000), width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(
                          color: Color(0xff000000), width: 1),
                    ),
                    labelText: "Name",
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff444444),
                    ),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    isDense: false,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: TextField(
                  controller: TextEditingController(text: localSeller.userMobile1),
                  obscureText: false,
                  readOnly: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(
                          color: Color(0xff000000), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(
                          color: Color(0xff000000), width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(
                          color: Color(0xff000000), width: 1),
                    ),
                    labelText: "Name",
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff444444),
                    ),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    isDense: false,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
