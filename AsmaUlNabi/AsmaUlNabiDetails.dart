import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/AsmaUlNabiController.dart';

class AsmaUlNabiDetailPage extends StatelessWidget {
  final RxInt nameNumber;
  final AsmaUlNabiController controller = Get.find<AsmaUlNabiController>();

  AsmaUlNabiDetailPage({Key? key, required int initialNameNumber}) 
      : nameNumber = initialNameNumber.obs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final name = controller.names.firstWhere(
        (name) => name['number'] == nameNumber.value, 
        orElse: () => {}
      );
      
      if (name.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Name Not Found'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Get.back(),
            ),
          ),
          body: const Center(
            child: Text('The requested name could not be found.'),
          ),
        );
      }

      return Scaffold(
        backgroundColor: kBackgroundWhite,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: kDarkPurpleColor,
                size: 18,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            Obx(() {
              final isFavorite = controller.isFavorite(nameNumber.value);
              
              return IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kShadowColor.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? kPurpleColor : kDarkPurpleColor,
                    size: 18,
                  ),
                ),
                onPressed: () {
                  controller.toggleFavorite(nameNumber.value);
                },
              );
            }),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kShadowColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.share_outlined,
                  color: kDarkPurpleColor,
                  size: 18,
                ),
              ),
              onPressed: () {
                // Share the name details using the controller
                controller.shareName(name);
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kBackgroundPurpleLight.withOpacity(0.7),
                    kBackgroundWhite,
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
            
            // Add a fade transition effect for name changes
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: SingleChildScrollView(
                key: ValueKey<int>(nameNumber.value), // Add a key based on name number for animation
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 120),
                      
                      // Number badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: kPurpleColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Name ${name['number']}",
                          style: TextStyle(
                            color: kDarkPurpleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Arabic name with decorative frame
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: kShadowColor.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: kLightPurpleColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              name['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 1,
                              color: kLightGray.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              name['transliteration'] ?? '',
                              style: TextStyle(
                                fontSize: 24,
                                color: kDarkPurpleColor,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Meaning
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: kLightPurpleColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: kLightPurpleColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Meaning",
                              style: TextStyle(
                                fontSize: 14,
                                color: kTextPurple,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              name['en']['meaning'] ?? '',
                              style: TextStyle(
                                fontSize: 22,
                                color: kTextPrimary,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Navigation buttons
                      _buildNavigationButtons(),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          nameNumber.value > 1
            ? _buildNavButton(
                icon: Icons.arrow_back_rounded,
                label: "Previous",
                onTap: () {
                  // Just update the nameNumber value within the same screen
                  nameNumber.value--;
                },
              )
            : const SizedBox(width: 110),
                
          // Info button
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: kBackgroundPurpleLight.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.info_outline,
                color: kDarkPurpleColor,
                size: 24,
              ),
              onPressed: () {
                // Show information about the name
                _showNameInfo();
              },
            ),
          ),
          
          // Next button
          nameNumber.value < 99
            ? _buildNavButton(
                icon: Icons.arrow_forward_rounded,
                label: "Next",
                isNext: true,
                onTap: () {
                  // Just update the nameNumber value within the same screen
                  nameNumber.value++;
                },
              )
            : const SizedBox(width: 110),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isNext = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: kBackgroundPurpleLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (!isNext) Icon(icon, size: 20, color: kDarkPurpleColor),
            if (!isNext) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kDarkPurpleColor,
              ),
            ),
            if (isNext) const SizedBox(width: 8),
            if (isNext) Icon(icon, size: 20, color: kDarkPurpleColor),
          ],
        ),
      ),
    );
  }
  
  void _showNameInfo() {
    final name = controller.names.firstWhere(
      (name) => name['number'] == nameNumber.value, 
      orElse: () => {}
    );
    
    if (name.isEmpty) return;
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and number
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "About ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary,
                    ),
                  ),
                  Text(
                    name['transliteration'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kDarkPurpleColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Information text
              Text(
                "This is one of the 99 names associated with the Prophet Muhammad (peace be upon him). It represents the attribute of ${name['en']['meaning']}.",
                style: TextStyle(
                  fontSize: 14,
                  color: kTextPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Understanding text
              Text(
                "Understanding and reflecting on this name helps believers appreciate the noble character and teachings of the Prophet.",
                style: TextStyle(
                  fontSize: 14,
                  color: kTextPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Share button
                  OutlinedButton.icon(
                    icon: Icon(Icons.share, size: 18),
                    label: Text("Share"),
                    onPressed: () {
                      Get.back();
                      controller.shareName(name);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kDarkPurpleColor,
                      side: BorderSide(color: kLightPurpleColor),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Close button
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: const Text("Close"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}