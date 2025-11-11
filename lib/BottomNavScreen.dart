import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Controllers/BottomNavController.dart';
import 'Screens/AcoountScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/OfferScreens/CreateOfferScreen.dart';
import 'Screens/OfferScreens/OfferUploadHistory.dart';
import 'Screens/Profile/ProfileScreen.dart';
import 'main.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const HomeScreen(),
      const OfferUploadHistory(),
      const CreateOfferScreen(),
      const AccountScreen(),
      const ProfileScreen(),
    ];

    return GetBuilder<BottomNavController>(
      init: bottomNavController,
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: myWidgets.myAppbar(
            title: _getAppBarTitle(controller.selectedIndex),
            context: context,
            bottomNavController: controller,
          ),
          drawer: myWidgets.buildDrawer(context, controller),
          body: widgetOptions.elementAt(controller.selectedIndex),
          bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              margin: const EdgeInsets.all(0),
              color: const Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildBottomNavigationBarItems(
                    controller.selectedIndex, context, controller),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "Dashboard";
      case 1:
        return "View Previous Offers";
      case 2:
        return "Create Offer";
      case 3:
        return "Account";
      case 4:
        return "Profile";
      default:
        return "";
    }
  }

  List<Widget> _buildBottomNavigationBarItems(
      int selectedIndex, BuildContext context, BottomNavController controller) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_outlined, 'label': 'Home', 'index': 0},
      {'icon': Icons.local_offer_outlined, 'label': 'View', 'index': 1},
      {'icon': Icons.add, 'label': 'Create', 'index': 2},
      {'icon': Icons.percent, 'label': 'Account', 'index': 3},
      {'icon': Icons.person_outline, 'label': 'Profile', 'index': 4},
    ];

    return items.map((item) {
      bool isSelected = selectedIndex == item['index'];
      return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact(); // Haptic feedback on tap
              _onItemTapped(item['index'], controller, context);
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: item['index'] == 2
                          ? ScaleTransitionIcon(
                              icon: item['icon'],
                              isSelected: isSelected,
                            )
                          : AnimatedScale(
                              scale: isSelected ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                item['icon'],
                                color: isSelected
                                    ? Colors.blue[800]
                                    : Colors.black,
                                size: 26.0,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width <= 320
                          ? (isSelected ? 9.0 : 7.0)
                          : (isSelected ? 12.0 : 10.0),
                      color: isSelected ? Colors.blue[800] : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _onItemTapped(
      int index, BottomNavController controller, BuildContext context) {
    if (index == 2) {
      controller.fetchIsActiveStatus().then((isActive) {
        if (isActive) {
          controller.changeSelectedIndex(index);
        } else {
          _showAlertDialog(context);
        }
      });
    } else {
      controller.changeSelectedIndex(index);
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Card(
            color: Colors.white,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'lib/Images/stores.png',
                      width: 100,
                      height: 50,
                    ),
                  ],
                ),
                const ListTile(
                  title: Text('Profile Under Review'),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your profile has been submitted for review. '
                    'Once your profile is approved by Candid Offers, you can create an offer.',
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget for scaling animation on create button
class ScaleTransitionIcon extends StatefulWidget {
  final IconData icon;
  final bool isSelected;

  const ScaleTransitionIcon(
      {Key? key, required this.icon, required this.isSelected})
      : super(key: key);

  @override
  State<ScaleTransitionIcon> createState() => _ScaleTransitionIconState();
}

class _ScaleTransitionIconState extends State<ScaleTransitionIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _scaleAnimation = _controller.drive(Tween(begin: 1.0, end: 1.2));

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ScaleTransitionIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CircleAvatar(
        backgroundColor: const Color(0xFFFF0000),
        child: Icon(widget.icon, color: Colors.white, size: 25.0),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
