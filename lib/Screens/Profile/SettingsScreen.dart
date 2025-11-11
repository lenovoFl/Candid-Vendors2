import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../AuthScreens/LoginScreen.dart';
import 'AccountDeletion.dart';

class Settings1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar:  AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              color: const Color(0xffffffff),
              shadowColor: const Color(0xffd5d2d2),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Support",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff000000),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: ListTile(
                        onTap: () {
                          // Navigate to Request Account Deletion screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  Settings(),
                            ),
                          );
                        },
                        tileColor: const Color(0x00ffffff),
                        title: const Text(
                          "Request For Account Deletion ",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        dense: false,
                        contentPadding: const EdgeInsets.all(0),
                        selected: false,
                        selectedTileColor: const Color(0x42000000),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Color(0xff767678), size: 18),
                      ),
                    ),
                    const Divider(
                      color: Color(0xff808080),
                      height: 16,
                      thickness: 0.3,
                      indent: 0,
                      endIndent: 0,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Launch email client
                        launch("mailto:support@candidoffers.com");
                      },
                      child: const ListTile(
                        tileColor: Color(0x00ffffff),
                        title: Text(
                          "Contact Us",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        dense: false,
                        contentPadding: EdgeInsets.all(0),
                        selected: false,
                        selectedTileColor: Color(0x42000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Color(0xff767678), size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: MaterialButton(
                onPressed: () {
                logOutUser();
                },
                color: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.all(16),
                textColor: const Color(0xffffffff),
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}

logOutUser() async {
  try {
    await firebaseAuth.signOut();
    await isar.writeTxn(() async => await isar.clear());
    //  showSnackBar('Logout Or Session got expired!');
    await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
          (route) => false,
    );
  } catch (e) {
    debugPrint('logOutUser: CATCH: $e');
  }
}