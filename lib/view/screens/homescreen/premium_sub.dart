import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/constants/app_styling.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

class PremiumSub extends StatefulWidget {
  const PremiumSub({Key? key}) : super(key: key);

  @override
  _PremiumSubState createState() => _PremiumSubState();
}

const String subId = 'ocular_vision_sub'; // PremiumSub ID

class _PremiumSubState extends State<PremiumSub> {
  final List<String> features = [
    '3 days Free Trial',
    'Only \$19.99/month, billed annually',
    'Cancel from your google or your iCloud account',
    'Reminders to change your mindset',
    'Enjoy your first 3 days; it\'s free',
    'Affirmations that resonate with you',
  ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;

  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = true;
  List<ProductDetails> _products = [];
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
    initialize();
  }

  void initialize() async {
    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      setState(() {
        _available = isAvailable;
      });
      return;
    }

    Set<String> ids = {subId}; // Set your product ID
    final response = await _iap.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error, could not find ids
    }

    setState(() {
      _products = response.productDetails;
    });

    _subscription = _iap.purchaseStream.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
          _setPremiumStatus();
        }
      } else if (purchase.status == PurchaseStatus.error) {
        Get.snackbar('Purchase Error', purchase.error!.message!);
      }
    }
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('userData').doc(_user!.uid).get();
        if (snapshot.exists) {
          setState(() {
            _userData = snapshot.data() as Map<String, dynamic>?;
          });
          print('User Data: $_userData'); // Debug print
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No user logged in.');
    }
  }

  Future<void> _setPremiumStatus() async {
    if (_user != null) {
      try {
        await _firestore
            .collection('userData')
            .doc(_user!.uid)
            .update({'premium': true});
        print('Premium status updated successfully.');
      } catch (e) {
        print('Failed to update premium status: $e');
        Get.snackbar('Update Failed', 'Failed to set premium status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: AppSize.DEFAULT,
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Get.to(() => BottomNavBar()),
                ),
              ],
            ),
            Expanded(
              flex: 4,
              child: Image.asset(Assets.imagesPremiumIcon),
            ),
            const SizedBox(height: 30),
            Expanded(
              flex: 6,
              child: Container(
                decoration: AppStyling.cardDecoration,
                child: ListView.builder(
                  padding: const EdgeInsets.all(21),
                  physics: const BouncingScrollPhysics(),
                  itemCount: features.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 17),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Assets.imagesCheckRounded, height: 18),
                        Expanded(
                          child: MyText(
                            text: features[index],
                            size: 15,
                            paddingLeft: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            MyText(
              text:
                  'You will be automatically charged \$19.99 per year after your trial ends.',
              color: kGreyColor10,
              weight: FontWeight.w500,
              textAlign: TextAlign.center,
              paddingBottom: 18,
            ),
            MyButton(
              buttonText: 'Continue',
              onTap: () async {
                if (_products.isNotEmpty) {
                  final ProductDetails product = _products.firstWhere(
                      (p) => p.id == subId,
                      orElse: () =>
                          throw Exception("Subscription product not found"));
                  final PurchaseParam param =
                      PurchaseParam(productDetails: product);
                  _iap.buyNonConsumable(
                      purchaseParam:
                          param); // You should replace this method with the correct one for subscriptions if needed.

                  await _setPremiumStatus();
                  Get.offAll(() => BottomNavBar());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
