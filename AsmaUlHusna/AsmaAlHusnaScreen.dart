import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/AsmaUlHusnaController.dart';
import 'package:quran_app/view/AsmaUlHusna/AsmaAlHusnaDetailPage.dart';

class AsmaAlHusnaScreen extends StatelessWidget {
  final AsmaAlHusnaController controller = Get.put(AsmaAlHusnaController());

  AsmaAlHusnaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        title: Text(
          "Asma Al-Husna",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kDarkPurpleColor, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.showFavorites.value ? Icons.favorite : Icons.favorite_border,
              color: controller.showFavorites.value 
                  ? kPurpleColor 
                  : (controller.favoriteNames.isNotEmpty ? kDarkPurpleColor : kLightGray),
              size: 24,
            ),
            onPressed: () {
              controller.toggleShowFavorites(!controller.showFavorites.value);
            },
          )),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: kDarkPurpleColor,
              size: 22,
            ),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          
          // Heading
          _buildHeading(),
          
          // Names list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingIndicator();
              }
              
              if (controller.filteredNames.isEmpty) {
                return controller.showFavorites.value
                    ? _buildNoFavoritesFound()
                    : _buildNoResultsFound();
              }
              
              return _buildNamesList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kBackgroundPurpleLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.search,
        decoration: InputDecoration(
          hintText: 'Search by name or meaning...',
          hintStyle: TextStyle(
            color: kTextSecondary.withOpacity(0.7),
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: kDarkPurpleColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return Obx(() {
      final displayCount = controller.filteredNames.length;
      final totalCount = controller.names.length;
      final favoritesCount = controller.favoriteNames.length;
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              controller.showFavorites.value 
                  ? "Favorite Names" 
                  : "The 99 Names of Allah",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextPurple,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: controller.showFavorites.value 
                    ? kPurpleColor.withOpacity(0.1)
                    : kChipBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                controller.showFavorites.value
                    ? "$displayCount Favorites"
                    : controller.searchQuery.isEmpty
                        ? "$totalCount Names"
                        : "$displayCount of $totalCount",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: kDarkPurpleColor,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPurpleColor),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading the Beautiful Names of Allah...",
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: kLightGray,
          ),
          const SizedBox(height: 16),
          Text(
            "No results found",
            style: TextStyle(
              fontSize: 18,
              color: kTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try different keywords or spelling",
            style: TextStyle(
              fontSize: 14,
              color: kTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              controller.search('');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurpleColor,
              foregroundColor: kWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Clear Search"),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFavoritesFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: kLightGray,
          ),
          const SizedBox(height: 16),
          Text(
            "No favorites yet",
            style: TextStyle(
              fontSize: 18,
              color: kTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add names to your favorites by tapping the heart icon",
            style: TextStyle(
              fontSize: 14,
              color: kTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              controller.toggleShowFavorites(false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurpleColor,
              foregroundColor: kWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Show All Names"),
          ),
        ],
      ),
    );
  }

  Widget _buildNamesList() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: controller.filteredNames.length,
      itemBuilder: (context, index) {
        final name = controller.filteredNames[index];
        return _buildNameCard(name);
      },
    );
  }

  Widget _buildNameCard(Map<String, dynamic> name) {
    final number = name['number'] as int;
    
    return Obx(() {
      final isFavorite = controller.isFavorite(number);
      
      return GestureDetector(
        onTap: () {
          _showNameDetailsBottomSheet(name);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kWhite,
                const Color.fromARGB(255, 182, 180, 253).withOpacity(0.01),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: const Color.fromARGB(255, 222, 207, 252).withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: kShadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Number badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kPurpleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color: kDarkPurpleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              
              // Favorite icon
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    controller.toggleFavorite(number);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isFavorite ? kPurpleColor.withOpacity(0.1) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? kPurpleColor : kLightGray,
                      size: 20,
                    ),
                  ),
                ),
              ),
              
              // Name content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      name['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name['transliteration'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: kDarkPurpleColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name['en']['meaning'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: kTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showNameDetailsBottomSheet(Map<String, dynamic> name) {
    final number = name['number'] as int;
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: kShadowColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kLightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // Number badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: kPurpleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Name ${name['number']}",
                style: TextStyle(
                  color: kDarkPurpleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Arabic name
            Text(
              name['name'] ?? '',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            
            // Transliteration
            Text(
              name['transliteration'] ?? '',
              style: TextStyle(
                fontSize: 22,
                color: kDarkPurpleColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Meaning
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kBackgroundPurpleLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                name['en']['meaning'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: kTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final isFavorite = controller.isFavorite(number);
                  
                  return ElevatedButton.icon(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                    ),
                    label: Text(isFavorite ? "Remove Favorite" : "Add to Favorites"),
                    onPressed: () {
                      controller.toggleFavorite(number);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFavorite ? kLightGray : kPurpleColor,
                      foregroundColor: isFavorite ? kTextPrimary : kWhite,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }),
                
                IconButton(
                  icon: Icon(Icons.open_in_new, size: 20),
                  onPressed: () {
                    Get.back(); // Close the bottom sheet
                    Get.to(() => AsmaAlHusnaDetailPage(initialNameNumber: number));
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: kBackgroundPurpleLight.withOpacity(0.3),
                    foregroundColor: kDarkPurpleColor,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  onPressed: () {
                    controller.shareName(name);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: kBackgroundPurpleLight,
                    foregroundColor: kDarkPurpleColor,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
  
  void _showInfoDialog() {
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
              Text(
                "Asma Al-Husna",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kDarkPurpleColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "The 99 Beautiful Names of Allah (Asma Al-Husna) are the divine attributes through which Allah has described Himself in the Quran and Sunnah.",
                style: TextStyle(
                  fontSize: 14,
                  color: kTextPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Memorizing and understanding these names is a means of increasing our knowledge and love of Allah.",
                style: TextStyle(
                  fontSize: 14,
                  color: kTextPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurpleColor,
                  foregroundColor: kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}