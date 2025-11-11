import 'package:candid_vendors/Services/APIs/Offers/OffersConnect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class OfferUploadHistoryController extends GetxController {
  String searchedOffer = '';
  bool isLoading = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  bool get isListening => _isListening;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getUpdatedOffersList();
    await _initSpeechState(); // Initialize speech to text
  }

  // Initialize Speech-to-Text
  Future<void> _initSpeechState() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (!available) {
      print("Speech recognition is not available on this device.");
    }
    update();
  }

  // Start listening for voice input
  void startListening(TextEditingController controller) async {
    if (!_isListening && await _speech.initialize()) {
      _isListening = true;
      update(); // Rebuild GetBuilder
      _speech.listen(
        onResult: (result) {
          // Update the search field and state immediately
          controller.text = result.recognizedWords;
          searchedOffer = result.recognizedWords;
          update(); // Triggers filtering
          if (result.finalResult) {
            stopListening();
          }
        },
        listenFor: const Duration(seconds: 5), // Listen for max 5 seconds
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US', // Use your desired locale
      );
    }
  }

  // Stop listening for voice input
  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
      update(); // Rebuild GetBuilder
    }
  }

  getUpdatedOffersList() async {
    // Note: Assuming OffersConnect.getOfferHistoryApi handles the loading state
    // and data retrieval necessary for your app logic.
    return await OffersConnect.getOfferHistoryApi(
        offerUploadHistoryController: this);
  }

  updateSearchedOffer(String newSearchedTxt) {
    searchedOffer = newSearchedTxt;
    update(); // Rebuilds the GetBuilder to trigger filtering
  }
}

