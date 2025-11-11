
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';


import '../../main.dart';

class OfferDetailsController extends GetxController {
  final String offerID;

  OfferDetailsController({required this.offerID});

  List<String> offerImages = [
    'lib/Images/offer.jpg',
    'lib/Images/offer.jpg',
    'lib/Images/offer.jpg'
  ];
  bool isLoading = false, trendingNowIsLoading = false;
  String selectedCity = '';
  var currentImageIndex = 0.obs;

//   Future<void> shareOfferOnSocialMedia({required OffersColl offer}) async {
//     // Create dynamic link parameters
//     DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse(
//           "https://candidcustomer.page.link/?offerID=${offer.offerID}"),
//       uriPrefix: "https://candidcustomer.page.link",
//       androidParameters: const AndroidParameters(
//         packageName: "com.customer.candid.candid_customer",
//         minimumVersion: 1,
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: "com.customer.candid.candidCustomer",
//         minimumVersion: "1",
//       ),
//       socialMetaTagParameters: SocialMetaTagParameters(
//         title: offer.offerName,
//         description: offer.offerDescription,
//         imageUrl: Uri.parse(offer.offerImages.isNotEmpty ? offer.offerImages[0] : 'https://example.com/default-image.png'),
//       ),
//     );
//
//     // Generate short dynamic link
//     final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
//       dynamicLinkParams,
//       shortLinkType: ShortDynamicLinkType.unguessable,
//     );
//
//     // Share the dynamic link
//     Share.share('Checkout this offer ${dynamicLink.shortUrl}');
//
//     // Increment the offerSharedCount in Firestore
//     try {
//       final firestore = FirebaseFirestore.instance;
//       final offerDocRef = firestore.collection('candidOffers').doc(offer.offerID);
//
//       await firestore.runTransaction((transaction) async {
//         final offerDoc = await transaction.get(offerDocRef);
//
//         if (!offerDoc.exists) {
//           throw Exception("Offer not found");
//         }
//
//         final currentSharedCount = offerDoc.data()?['sharesCount'] ?? 0;
//         transaction.update(offerDocRef, {'sharesCount': currentSharedCount + 1});
//
//         await isar.writeTxn(() async {
//           offer.isInRatingsList = !offer.isInRatingsList;
//           if (offer.isInRatingsList) {
//             offer.sharesCount++;
//           } else {
//             offer.sharesCount--;
//           }
//           isar.offersColls.put(offer);
//         });
//       });
//     } catch (e) {
//       print("Failed to update share count: $e");
//     }
//
//     // Log event to analytics
//     utils.analyticsLogEvent(
//       eventName: Utils.offerShareContentType,
//       parameters: {
//         "offerID": offer.offerID,
//       },
//     );
//   }
//
//   Future<void> addOrRemoveOfferFromWishListClickHandler({required OffersColl offer}) async {
//     try {
//       isLoading = true;
//       update(); // Update UI to show loading state
//
//       // Toggle wishlist status via API call
//       await OffersConnect().addOrRemoveOfferFromWishList(offerID: offer.offerID);
//
//       // Update local Isar database and offer state
//       await isar.writeTxn(() async {
//         offer.isInWishList = !offer.isInWishList;
//         if (offer.isInWishList) {
//           offer.offerSavedCount++;
//         } else {
//           offer.offerSavedCount--;
//         }
//         isar.offersColls.put(offer);
//       }
//       );
//
//       isLoading = false;
//       update(); // Update UI to reflect new state
//     } catch (e) {
//       isLoading = false;
//       update(); // Update UI in case of errors
//       debugPrint('addOrRemoveOfferFromWishListClickHandler | catch | $e');
//       // Handle error gracefully
//     }
//   }
//
//   Future<void> toggleLike({required OffersColl offer}) async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       final offerDocRef = firestore.collection('candidOffers').doc(offer.offerID);
//       final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//
//       if (currentUserId == null) {
//         throw Exception("User not logged in");
//       }
//
//       await firestore.runTransaction((transaction) async {
//         final offerDoc = await transaction.get(offerDocRef);
//
//         if (!offerDoc.exists) {
//           throw Exception("Offer not found");
//         }
//
//         final currentLikesCount = offerDoc.data()?['likesCount'] ?? 0;
//         final likedBy = Set<String>.from(offerDoc.data()?['likedBy'] ?? []);
//
//         if (likedBy.contains(currentUserId)) {
//           // User is disliking
//           likedBy.remove(currentUserId);
//           offer.likedByCurrentUser = false;
//           offer.likesCount = currentLikesCount - 1;
//         } else {
//           // User is liking
//           likedBy.add(currentUserId);
//           offer.likedByCurrentUser = true;
//           offer.likesCount = currentLikesCount + 1;
//         }
//
//         transaction.update(offerDocRef, {
//           'likesCount': offer.likesCount,
//           'likedBy': likedBy.toList(),
//         });
//
//         await isar.writeTxn(() async {
//           await isar.offersColls.put(offer);
//         });
//       });
//
//       update();
//     } catch (e) {
//       update();
//       debugPrint("Failed to update Like: $e");
//     }
//   }
//
//
//   Future<void> submitRating(OffersColl offer, double rating) async {
//     if (offer.hasRated) {
//       debugPrint("User has already rated this offer.");
//       return;
//     }
//
//     try {
//       final firestore = FirebaseFirestore.instance;
//       final offerDocRef = firestore.collection('candidOffers').doc(offer.offerID);
//       final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//
//       if (currentUserId == null) {
//         throw Exception("User not logged in");
//       }
//
//       await firestore.runTransaction((transaction) async {
//         final offerDoc = await transaction.get(offerDocRef);
//
//         if (!offerDoc.exists) {
//           throw Exception("Offer not found");
//         }
//
//         final currentRatingCount = offerDoc.data()?['ratingCount'] ?? 0;
//         final currentCumulativeRating = offerDoc.data()?['cumulativeRating'] ?? 0.0;
//         final userRatings = Map<String, double>.from(offerDoc.data()?['userRatings'] ?? {});
//
//         if (userRatings.containsKey(currentUserId)) {
//           throw Exception("User has already rated this offer");
//         }
//
//         final newRatingCount = currentRatingCount + 1;
//         final newCumulativeRating = currentCumulativeRating + rating;
//         final newAverageRating = newCumulativeRating / newRatingCount;
//
//         userRatings[currentUserId] = rating;
//
//         transaction.update(offerDocRef, {
//           'ratingCount': newRatingCount,
//           'cumulativeRating': newCumulativeRating,
//           'averageRating': newAverageRating,
//           'userRatings': userRatings,
//         });
//
//         await isar.writeTxn(() async {
//           offer.ratingCount = newRatingCount;
//           offer.cumulativeRatingSum = newCumulativeRating;
//           offer.rating = rating;
//           offer.averageRating = newAverageRating;
//           offer.hasRated = true;
//           await isar.offersColls.put(offer);
//         });
//       });
//
//       update();
//     } catch (e) {
//       update();
//       debugPrint('submitRating | catch | $e');
//     }
//   }
//
//
//   Future<void> fetchWishlistStatus() async {
//     try {
//       isLoading = true;
//       update();
//
//       // Fetch the wishlist data from the backend
//       await OffersConnect().getCustomerOfferWishListApi();
//
//       isLoading = false;
//       update();
//     } catch (e) {
//       isLoading = false;
//       update();
//       debugPrint('fetchWishlistStatus | catch | $e');
//       // Handle error gracefully
//     }
//   }
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     fetchWishlistStatus();
//     utils.analyticsLogSelectContent(
//         contentType: Utils.offerContentType, itemId: offerID);
//   }
 }
