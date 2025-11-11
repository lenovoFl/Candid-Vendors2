import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class ShareRefer extends StatelessWidget {
  const ShareRefer({super.key});

  String getAppLink() {
    return 'https://play.google.com/store/apps/details?id=com.seller01.candid';
  }

  String getCurrentUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : 'UID not available';
  }

  @override
  Widget build(BuildContext context) {
    // Define theme colors
    const primaryColor = Color(0xFF00BADD);
    const secondaryColor = Color(0xFF00BADD);
    const backgroundColor = Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Invite & Earn',
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
          children: [
            // Stats Card

            // Share Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Share & Earn',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Invite friends and earn rewards for every successful referral',
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.card_giftcard,
                            color: primaryColor,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildReferralStep(
                          icon: Icons.share,
                          title: 'Share Your Link',
                          description: 'Share your unique referral code with friends',
                          color: primaryColor,
                        ),
                        const SizedBox(height: 15),
                        _buildReferralStep(
                          icon: Icons.person_add,
                          title: 'Friend Joins',
                          description: 'Your friend signs up using your referral',
                          color: primaryColor,
                        ),
                        const SizedBox(height: 15),
                        _buildReferralStep(
                          icon: Icons.celebration,
                          title: 'Earn Rewards',
                          description: 'Get exciting rewards for successful referrals',
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        final String appLink = getAppLink();
                        final String userUID = getCurrentUserUID();
                        Share.share(
                          'Join me on Candid! Use my referral code: $userUID\n\nDownload now: $appLink',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.share, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            'Share Now',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Referral Information
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    secondary: primaryColor,
                  ),
                ),
                child: Column(
                  children: [
                    _buildExpandableTile(
                      'Seller Benefits',
                      Icons.store,
                      'Earn More with Refer and Share Program!\n\n'
                          '• Get rewards for each seller referral\n'
                          '• Expand your business network\n'
                          '• Access exclusive offers\n'
                          '• Track referral status easily',
                      primaryColor,
                    ),
                    const Divider(height: 1),
                    _buildExpandableTile(
                      'Customer Benefits',
                      Icons.people,
                      'Share the Joy of Shopping!\n\n'
                          '• Earn rewards for prime customer referrals\n'
                          '• Help friends discover great deals\n'
                          '• Get special access to promotions\n'
                          '• Enjoy seamless reward crediting',
                      primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralStep({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableTile(
      String title,
      IconData icon,
      String content,
      Color color,
      ) {
    return ExpansionTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            content,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      ],
    );
  }
}