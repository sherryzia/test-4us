// lib/controllers/profile_controller.dart - Fixed with Proper Currency Change Notification
import 'package:expensary/services/supabase_service.dart';
import 'package:expensary/views/screens/login_screen.dart';
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/controllers/home_controller.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  // User information
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString currency = ''.obs;
  final RxString previousCurrency = ''.obs;
  final RxDouble monthlyBudget = 0.0.obs;
  final RxDouble monthlyIncome = 0.0.obs;
  final RxString avatarUrl = ''.obs;
  final RxBool isUploadingPhoto = false.obs;
  
  // Text controllers for editable fields
  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  final incomeController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  // Currency options with display names
  final List<Map<String, String>> currencyOptions = [
    {'code': 'PKR', 'display': 'PKR (₨)', 'symbol': '₨'},
    {'code': 'USD', 'display': 'USD (\$)', 'symbol': '\$'},
    {'code': 'EUR', 'display': 'EUR (€)', 'symbol': '€'},
    {'code': 'GBP', 'display': 'GBP (£)', 'symbol': '£'},
    {'code': 'JPY', 'display': 'JPY (¥)', 'symbol': '¥'},
  ];

  List<String> get currencies => currencyOptions.map((c) => c['display']!).toList();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    budgetController.dispose();
    incomeController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> fetchUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    email.value = user.email ?? '';

    try {
      final response = await SupabaseService.getUserProfileWithAvatar(user.id);

      if (response != null) {
        name.value = response['full_name'] ?? '';
        avatarUrl.value = response['avatar_url'] ?? '';
        
        String dbCurrency = response['currency'] ?? 'PKR';
        String displayCurrency = currencyOptions.firstWhere(
          (c) => c['code'] == dbCurrency,
          orElse: () => currencyOptions.first
        )['display']!;
        
        // Store previous currency for conversion tracking
        previousCurrency.value = currency.value;
        currency.value = displayCurrency;
        
        monthlyBudget.value = (response['monthly_budget'] ?? 0).toDouble();
        monthlyIncome.value = (response['monthly_income'] ?? 0).toDouble();
        
        nameController.text = name.value;
        budgetController.text = monthlyBudget.value.toString();
        incomeController.text = monthlyIncome.value.toString();
        
        // Update global controller currency
        try {
          final globalController = Get.find<GlobalController>();
          globalController.currentCurrency.value = dbCurrency;
        } catch (e) {
          debugPrint('Error updating global controller: $e');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  // ====== Profile Photo Methods ======
  
  Future<void> takePhotoFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (photo != null) {
        await _uploadProfilePhoto(photo.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> pickPhotoFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (photo != null) {
        await _uploadProfilePhoto(photo.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> removeProfilePhoto() async {
    if (avatarUrl.value.isEmpty) return;
    
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Color(0xFF2A2D40),
        title: Text('Remove Photo', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove your profile photo?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    
    isUploadingPhoto.value = true;
    
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;
      
      await SupabaseService.deleteProfilePhoto(
        userId: userId,
        photoUrl: avatarUrl.value,
      );
      
      avatarUrl.value = '';
      
      Get.snackbar('Success', 'Profile photo removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }
  
  Future<void> _uploadProfilePhoto(String filePath) async {
    isUploadingPhoto.value = true;
    
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;
      
      // Delete old photo if exists
      if (avatarUrl.value.isNotEmpty) {
        try {
          await SupabaseService.deleteProfilePhoto(
            userId: userId,
            photoUrl: avatarUrl.value,
          );
        } catch (e) {
          debugPrint('Failed to delete old photo: $e');
        }
      }
      
      // Upload new photo
      final fileName = filePath.split('/').last;
      final newAvatarUrl = await SupabaseService.uploadProfilePhoto(
        userId: userId,
        filePath: filePath,
        fileName: fileName,
      );
      
      // Update user record
      await SupabaseService.updateUserAvatar(
        userId: userId,
        avatarUrl: newAvatarUrl,
      );
      
      // Update local state
      avatarUrl.value = newAvatarUrl;
      
      Get.snackbar('Success', 'Profile photo updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  // ====== Profile Update Methods ======

  Future<void> updateName() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null || nameController.text.isEmpty) return;

    isLoading.value = true;

    try {
      await supabase
          .from('users')
          .update({'full_name': nameController.text})
          .eq('id', userId);

      name.value = nameController.text;

      Get.snackbar('Success', 'Name updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    isLoading.value = true;

    try {
      await supabase
          .from('users')
          .update({
            'full_name': nameController.text,
            'monthly_budget': double.tryParse(budgetController.text) ?? 0,
            'monthly_income': double.tryParse(incomeController.text) ?? 0,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      // Update local values
      name.value = nameController.text;
      monthlyBudget.value = double.tryParse(budgetController.text) ?? 0;
      monthlyIncome.value = double.tryParse(incomeController.text) ?? 0;

      // Update global controller
      try {
        final globalController = Get.find<GlobalController>();
        await globalController.refreshData();

        // Update home controller
        final homeController = Get.find<HomeController>();
        homeController.monthlyBudget.value = monthlyBudget.value;
        await homeController.loadData();
      } catch (e) {
        debugPrint('Error updating other controllers: $e');
      }

      Get.snackbar('Success', 'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all password fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'New password and confirmation do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(password: newPasswordController.text),
      );

      if (response.user != null) {
        Get.snackbar('Success', 'Password updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
        
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Enhanced currency change with conversion and proper notification
  Future<void> changeCurrency(String newCurrencyDisplay) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Show confirmation dialog for currency conversion
    final bool? confirmed = await _showCurrencyChangeDialog(newCurrencyDisplay);
    if (confirmed != true) return;

    isLoading.value = true;

    try {
      // Extract currency codes
      final newCurrencyCode = currencyOptions.firstWhere(
        (c) => c['display'] == newCurrencyDisplay,
        orElse: () => currencyOptions.first,
      )['code']!;
      
      final oldCurrencyCode = currencyOptions.firstWhere(
        (c) => c['display'] == currency.value,
        orElse: () => currencyOptions.first,
      )['code']!;

      debugPrint('Changing currency from $oldCurrencyCode to $newCurrencyCode');

      // Get global controller for conversion
      final globalController = Get.find<GlobalController>();
      
      // Convert current budget and income values
      final currentBudget = double.tryParse(budgetController.text) ?? 0;
      final currentIncome = double.tryParse(incomeController.text) ?? 0;
      
      final convertedBudget = globalController.convertCurrency(
        currentBudget, 
        oldCurrencyCode, 
        newCurrencyCode
      );
      
      final convertedIncome = globalController.convertCurrency(
        currentIncome, 
        oldCurrencyCode, 
        newCurrencyCode
      );

      debugPrint('Converting budget: $currentBudget -> $convertedBudget');
      debugPrint('Converting income: $currentIncome -> $convertedIncome');

      // Update database with converted values
      await supabase.from('users').update({
        'currency': newCurrencyCode,
        'monthly_budget': convertedBudget,
        'monthly_income': convertedIncome,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      // Update local state
      currency.value = newCurrencyDisplay;
      monthlyBudget.value = convertedBudget;
      monthlyIncome.value = convertedIncome;
      
      // Update text controllers with converted values
      budgetController.text = convertedBudget.toStringAsFixed(0);
      incomeController.text = convertedIncome.toStringAsFixed(0);
      
      // Update global controller and notify change
      globalController.currentCurrency.value = newCurrencyCode;
      
      // IMPORTANT: Explicitly notify currency change to trigger home controller update
      globalController.notifyCurrencyChange(oldCurrencyCode, newCurrencyCode);
      
      // Force refresh home controller
      try {
        final homeController = Get.find<HomeController>();
        await homeController.refreshData();
      } catch (e) {
        debugPrint('Error refreshing home controller: $e');
      }

      Get.snackbar(
        'Currency Changed', 
        'Currency changed to $newCurrencyDisplay. All amounts have been converted automatically.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to change currency: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show currency change confirmation dialog
  Future<bool?> _showCurrencyChangeDialog(String newCurrency) async {
    final oldCurrencyCode = currencyOptions.firstWhere(
      (c) => c['display'] == currency.value,
      orElse: () => currencyOptions.first,
    )['code']!;
    
    final newCurrencyCode = currencyOptions.firstWhere(
      (c) => c['display'] == newCurrency,
      orElse: () => currencyOptions.first,
    )['code']!;

    if (oldCurrencyCode == newCurrencyCode) return false;

    return await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Color(0xFF2A2D40),
        title: Text(
          'Change Currency', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are changing your currency from ${currency.value} to $newCurrency.',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All your amounts (budget, income, expenses) will be automatically converted to the new currency.',
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Do you want to continue?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Convert & Change', 
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resetAllExpenses() async {
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Color(0xFF2A2D40),
        title: Text('Reset All Expenses', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete all your expenses? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isLoading.value = true;

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase
          .from('expenses')
          .delete()
          .eq('user_id', userId);

      try {
        final homeController = Get.find<HomeController>();
        await homeController.loadData();
      } catch (e) {
        debugPrint('Error refreshing home controller: $e');
      }

      Get.snackbar('Success', 'All expenses have been reset',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to reset expenses: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAll(() => LoginScreen());
  }

  // ====== UI Helper Methods ======
  
  Widget buildProfileImage(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Obx(() => Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8E2DE2).withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: avatarUrl.value.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl.value,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF8E2DE2),
                                Color(0xFF4A00E0),
                              ],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF8E2DE2),
                                Color(0xFF4A00E0),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF8E2DE2),
                              Color(0xFF4A00E0),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
              ),
            )),
            
            Positioned(
              bottom: 0,
              right: 0,
              child: Obx(() => GestureDetector(
                onTap: () {
                  if (!isUploadingPhoto.value) {
                    showImageSelectionBottomSheet(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFAF4BCE),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: isUploadingPhoto.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              )),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Obx(() => MyText(
          text: name.value.isNotEmpty ? name.value : 'User',
          size: 24,
          weight: FontWeight.bold,
          color: Colors.white,
        )),
        
        const SizedBox(height: 4),
        
        Obx(() => MyText(
          text: email.value.isNotEmpty ? email.value : 'No email',
          size: 16,
          color: Colors.white.withOpacity(0.7),
        )),
      ],
    );
  }

  void showImageSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF2A2D40),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: 'Change Profile Picture',
              size: 18,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOptionButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    takePhotoFromCamera();
                  },
                ),
                _buildImageOptionButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    pickPhotoFromGallery();
                  },
                ),
                if (avatarUrl.value.isNotEmpty)
                  _buildImageOptionButton(
                    icon: Icons.delete,
                    label: 'Remove',
                    onTap: () {
                      Get.back();
                      removeProfilePhoto();
                    },
                  ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            MyButton(
              onTap: () => Get.back(),
              buttonText: 'Cancel',
              width: double.infinity,
              height: 46,
              fillColor: Colors.transparent,
              outlineColor: Colors.white.withOpacity(0.2),
              fontColor: Colors.white,
              fontSize: 16,
              radius: 23,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildImageOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          MyText(text: label, size: 14, color: Colors.white),
        ],
      ),
    );
  }
}