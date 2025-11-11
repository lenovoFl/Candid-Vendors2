import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';
import 'package:candid_vendors/Services/Collections/Offers/OfferHistory/OfferHistoryColl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../main.dart';
import 'offerdetailsScreen.dart';

// Assuming OfferStatus is defined somewhere, typically in OfferHistoryColl.dart
// For this code to compile, I'll assume it is an enum or class accessible here.
// Example:
// enum OfferStatus { live, rejected, expired, outOfStock, created }

enum FilterOption { Inactive, Active, Review, expired, outOfStock, All }

class ActiveOfferScreen extends StatefulWidget {
  const ActiveOfferScreen({super.key});

  @override
  _ActiveOfferScreenState createState() => _ActiveOfferScreenState();
}

class _ActiveOfferScreenState extends State<ActiveOfferScreen> {
  FilterOption _selectedOption = FilterOption.All;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    // Initialize speech to text. This is often an async operation.
    _initSpeechState();
    // Listen for changes in the search field
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Handle text changes in the search field
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Initialize Speech-to-Text
  Future<void> _initSpeechState() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (!available) {
      print("The user has denied the use of speech recognition.");
    }
  }

  // Start listening for voice input
  void _startListening() async {
    if (!_isListening && await _speech.initialize()) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          // Immediately update the search field and query state
          _searchController.text = result.recognizedWords;
          _onSearchChanged(); // Triggers filtering
          if (result.finalResult) {
            _stopListening();
          }
        },
        listenFor: const Duration(seconds: 5), // Listen for max 5 seconds
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US', // Use your desired locale
      );
    }
  }

  // Stop listening for voice input
  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  // Logic to filter offers based on status AND search query
  List<OfferHistoryColl>? _filterOffers(List<OfferHistoryColl>? offers) {
    if (offers == null) return null;

    final List<OfferHistoryColl> statusFiltered = offers.where((offer) {
      switch (_selectedOption) {
        case FilterOption.Inactive:
          return offer.offerStatus == OfferStatus.rejected;
        case FilterOption.expired:
          return offer.offerStatus == OfferStatus.expired;
        case FilterOption.outOfStock:
          return offer.offerStatus == OfferStatus.outOfStock;
        case FilterOption.Active:
          return offer.offerStatus == OfferStatus.live;
        case FilterOption.Review:
          return offer.offerStatus == OfferStatus.created;
        case FilterOption.All:
          return true;
      }
    }).toList();

    if (_searchQuery.isEmpty) {
      return statusFiltered;
    }

    return statusFiltered.where((offer) {
      final nameLower = offer.offerName.toLowerCase();
      final descriptionLower = offer.offerDescription.toLowerCase();
      return nameLower.contains(_searchQuery) ||
          descriptionLower.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Active Offers',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Aileron',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.03,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
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
                            ),
                          ),
                          // Voice Search Button
                          IconButton(
                            onPressed: _isListening ? _stopListening : _startListening,
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: _isListening ? Colors.red : Colors.grey[700],
                              size: 28,
                            ),
                            splashRadius: 24,
                            tooltip: _isListening ? 'Stop Listening' : 'Voice Search',
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
                      // Display listening status for voice search
                      if (_isListening)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Listening... speak now',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox.shrink(),
                    ],
                  ),
                ),
                StreamBuilder<List<OfferHistoryColl>?>(
                  stream: isar.offerHistoryColls
                      .where()
                      .offerIDIsNotEmpty()
                      .build()
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    // Filter the data using the new combined function
                    final List<OfferHistoryColl>? filteredOffers =
                    _filterOffers(snapshot.data);

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : filteredOffers == null || filteredOffers.isEmpty
                          ? Center(
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? 'No results found for "$_searchQuery"'
                              : 'No offers to display!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWithButtons(OfferHistoryColl offer, BuildContext context) {
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
          // Use a smaller delay for better UX
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
                  imgUrl: offer.offerImages.isNotEmpty
                      ? offer.offerImages[0]
                      : null,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 4),
                        decoration: BoxDecoration(
                          color: offer.offerStatus == OfferStatus.live
                              ? const Color(0xFFB4FFB2) // Active (light green)
                              : offer.offerStatus == OfferStatus.rejected
                              ? const Color(0xFFFF0000) // Rejected (red)
                              : offer.offerStatus == OfferStatus.outOfStock
                              ? const Color(
                              0xFFFFD700) // Out of stock (gold/yellow)
                              : offer.offerStatus == OfferStatus.expired
                              ? const Color(
                              0xFF808080) // Expired (gray)
                              : const Color(
                              0xFFADD8E6), // Review (light blue)
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          offer.offerStatus == OfferStatus.live
                              ? "Active"
                              : offer.offerStatus == OfferStatus.outOfStock
                              ? "Out of stock"
                              : offer.offerStatus == OfferStatus.rejected
                              ? "Rejected"
                              : offer.offerStatus == OfferStatus.expired
                              ? "Expired"
                              : "Review",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Aileron',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.01,
                          ),
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
                            // Assuming 'homeScreenController' is globally accessible as in your original code
                            // and 'endOffer' handles the update logic (e.g., changing status to outOfStock)
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
                      // Clear search query on filter application for a clean list display
                      _searchController.clear();
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
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}