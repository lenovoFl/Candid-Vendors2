import 'package:candid_vendors/Screens/AuthScreens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // Added dependency
import '../../Controllers/Offers/OfferUploadHistoryController.dart';
import '../../Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import '../../main.dart';
import 'offerdetailsScreen.dart';

enum FilterOption { Inactive, Active, Review, expired, outOfStock, All }

class OfferUploadHistory extends StatefulWidget {
  const OfferUploadHistory({Key? key});

  @override
  State<OfferUploadHistory> createState() => _OfferUploadHistoryState();
}

class _OfferUploadHistoryState extends State<OfferUploadHistory> {
  FilterOption _selectedOption = FilterOption.All;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller after widget is built and bind search controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<OfferUploadHistoryController>();
      _searchController.text = controller.searchedOffer;
      _searchController.addListener(() {
        controller.updateSearchedOffer(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper function to filter offers based on status AND search query
  List<OfferHistoryColl>? _filterAndSearchOffers(
      List<OfferHistoryColl>? offers, String searchQuery) {
    if (offers == null) return null;

    final queryLower = searchQuery.toLowerCase();

    final List<OfferHistoryColl> statusFiltered = offers.where((offer) {
      // 1. Filter by Status
      bool statusMatch = false;
      switch (_selectedOption) {
        case FilterOption.Inactive:
          statusMatch = offer.offerStatus == OfferStatus.rejected;
          break;
        case FilterOption.expired:
          statusMatch = offer.offerStatus == OfferStatus.expired;
          break;
        case FilterOption.outOfStock:
          statusMatch = offer.offerStatus == OfferStatus.outOfStock;
          break;
        case FilterOption.Active:
          statusMatch = offer.offerStatus == OfferStatus.live;
          break;
        case FilterOption.Review:
          statusMatch = offer.offerStatus == OfferStatus.created;
          break;
        case FilterOption.All:
          statusMatch = true;
          break;
      }

      // 2. Filter by Search Query
      if (queryLower.isEmpty) {
        return statusMatch;
      }

      final nameLower = offer.offerName.toLowerCase();
      final descriptionLower = offer.offerDescription.toLowerCase();

      // Offer must match the status AND the search query
      return statusMatch &&
          (nameLower.contains(queryLower) ||
              descriptionLower.contains(queryLower));
    }).toList();

    return statusFiltered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Your Previous Offers',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Aileron',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.03,
            ),
          ),
        ),
      ),
      body: GetBuilder<OfferUploadHistoryController>(
        init: OfferUploadHistoryController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.search_outlined),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search offer name or description...',
                            ),
                            // onChanged is now handled by the controller listener
                            // in initState, but the controller is updated
                            // to trigger a rebuild (using controller.update()).
                          ),
                        ),
                        // Voice Search Button
                        IconButton(
                          onPressed: () {
                            if (controller.isListening) {
                              controller.stopListening();
                            } else {
                              controller.startListening(_searchController);
                            }
                          },
                          icon: Icon(
                            controller.isListening ? Icons.mic : Icons.mic_none,
                            color: controller.isListening
                                ? Colors.red
                                : Colors.grey[700],
                            size: 28,
                          ),
                          splashRadius: 24,
                          tooltip: controller.isListening
                              ? 'Stop Listening'
                              : 'Voice Search',
                        ),
                        IconButton(
                          onPressed: () {
                            _showFilterDialog(context);
                          },
                          icon: Icon(
                            Icons.format_line_spacing_sharp,
                            color: Colors.grey[700],
                            size: 28,
                          ),
                          splashRadius: 24,
                          tooltip: 'Filter',
                        ),
                      ],
                    ),
                  ),
                ),
                // Display listening status for voice search
                if (controller.isListening)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Listening... speak now',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                SizedBox(height: 2.h),
                StreamBuilder<List<OfferHistoryColl>?>(
                  stream: isar.offerHistoryColls
                      .where()
                      .offerIDIsNotEmpty()
                      .build()
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    final List<OfferHistoryColl>? offers = snapshot.data;
                    // Apply filtering logic with search query from GetX Controller
                    final List<OfferHistoryColl>? filteredOffers =
                    _filterAndSearchOffers(
                        offers, controller.searchedOffer);

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: filteredOffers == null
                          ? const Center(child: CircularProgressIndicator())
                          : filteredOffers.isEmpty
                          ? Center(
                        child: Text(
                          controller.searchedOffer.isNotEmpty
                              ? 'No offers found for "${controller.searchedOffer}"'
                              : 'No offers to display!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                          : Column(
                        children: List.generate(
                          filteredOffers.length,
                              (index) => Padding(
                            padding:
                            const EdgeInsets.only(bottom: 8.0),
                            child: _buildCardWithButtons(
                                filteredOffers[index], context),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardWithButtons(OfferHistoryColl offer, BuildContext context) {
    // --- New Status Styling Logic Start ---
    Color statusTextColor;
    String statusText;

    switch (offer.offerStatus) {
      case OfferStatus.live:
        statusText = "Active";
        statusTextColor = Colors.green; // Active text color: Green
        break;
      case OfferStatus.outOfStock:
        statusText = "Out of stock";
        statusTextColor = Colors.red; // Out of stock text color: Red
        break;
      case OfferStatus.rejected:
        statusText = "Rejected";
        statusTextColor = Colors.red; // Rejected text color: Red
        break;
      case OfferStatus.expired:
        statusText = "Expired";
        statusTextColor = Colors.grey; // Expired text color: Grey
        break;
      case OfferStatus.created:
      default:
        statusText = "Review";
        statusTextColor = Colors.black; // Review text color: Black
        break;
    }
    // --- New Status Styling Logic End ---

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Loading Offer Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Aileron',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.03,
                    ),
                  ),
                ],
              ),
            );
          },
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OfferDetailsScreen(offerID: offer.offerID),
            ),
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: myWidgets.getCachedNetworkImage(
                  imgUrl:
                  offer.offerImages.isNotEmpty ? offer.offerImages[0] : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.offerName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Aileron',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    offer.offerDescription,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Updated Status Text Widget
                      Text(
                        statusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: statusTextColor, // Using calculated color
                          fontSize: 12,
                          fontFamily: 'Aileron',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.01,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 1.w,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22.w, // Adjust this value as needed
                              height: 4.h, // Adjust this value as needed
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OfferDetailsScreen(
                                          offerID: offer.offerID),
                                    ),
                                  );
                                },
                                child: Text(
                                  'VIEW OFFER',
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            if (offer.offerStatus == OfferStatus.live)
                              SizedBox(
                                width: 25.w, // Adjust this value as needed
                                height: 4.h, // Adjust this value as needed
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    _showEditOfferDialog(context, offer);
                                  },
                                  child: Text(
                                    'EDIT OFFER',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditOfferDialog(BuildContext context, OfferHistoryColl offer) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedStatus;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Offer Status',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: DropdownButton<String>(
                        hint: const Text('Select Offer Status'),
                        value: selectedStatus,
                        items: ['Out of Stock'].map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        isExpanded: true,
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            // Call the endOffer method with the updated status
                            homeScreenController.endOffer(
                                offer, selectedStatus, null);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 10,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filter by:',
                      style: GoogleFonts.workSans(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildRadioTile(context, FilterOption.Active, "Active Offers"),
              _buildRadioTile(context, FilterOption.Review, "Review Offers"),
              _buildRadioTile(
                  context, FilterOption.Inactive, "Rejected Offers"),
              _buildRadioTile(context, FilterOption.expired, "Expired Offers"),
              _buildRadioTile(
                  context, FilterOption.outOfStock, "Out of Stock Offers"),
              _buildRadioTile(context, FilterOption.All, "All Offers"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioTile(
      BuildContext context, FilterOption option, String title) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: GoogleFonts.workSans(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Radio<FilterOption>(
        value: option,
        groupValue: _selectedOption,
        activeColor: Colors.blueAccent,
        onChanged: (FilterOption? value) {
          setState(() {
            _selectedOption = value!;
            // Trigger a GetX update so the StreamBuilder re-filters
            Get.find<OfferUploadHistoryController>().update();
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}