import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 15.h,
            backgroundColor: Colors.white,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'About Candid Offers',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              centerTitle: true,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  // Logo Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLogoCard(
                          'lib/Images/CandidOffers.png',
                          width: 30.w,
                          height: 7.h
                      ),
                      _buildLogoCard(
                          'lib/Images/stores.png',
                          width: 25.w,
                          height: 12.h
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // About Content Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Our Mission'),
                        SizedBox(height: 1.h),
                        _buildDescriptionText(
                          'Candid Offers is a revolutionary e-commerce platform that reimagines how consumers access deals. We connect neighborhood stores, specialty shops, and diverse service providers to bring unparalleled value to Indian consumers.',
                        ),

                        SizedBox(height: 2.h),

                        _buildSectionTitle('Our Vision'),
                        SizedBox(height: 1.h),
                        _buildDescriptionText(
                          'We aim to democratize access to the best deals across various product and service segments, creating abundant employment opportunities with minimal effort for our stakeholders.',
                        ),

                        SizedBox(height: 2.h),

                        _buildSectionTitle('Impact'),
                        SizedBox(height: 1.h),
                        _buildDescriptionText(
                          'Committed to significantly contributing to the Indian economy by empowering local businesses and providing consumers with unprecedented access to quality offers.',
                        ),

                        SizedBox(height: 2.h),

                        // Website Link
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse('https://www.candidoffers.com'));
                            },
                            child: Text(
                              'Visit Our Website',
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                fontSize: 11.sp,
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
        ],
      ),
    );
  }

  // Helper method to create logo cards
  Widget _buildLogoCard(String imagePath, {double? width, double? height}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  // Helper method to create description text
  Widget _buildDescriptionText(String text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        color: Colors.black87,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }
}