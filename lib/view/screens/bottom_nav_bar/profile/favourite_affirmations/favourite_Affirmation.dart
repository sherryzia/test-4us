import 'dart:ui';
import 'package:affirmation_app/constants/app_fonts.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affirmation_app/controllers/favorites_controller.dart';
import 'package:share_plus/share_plus.dart';

class FavAffirmationsView extends StatelessWidget {
  final bool isPremium;

  FavAffirmationsView({Key? key, required this.isPremium}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoritesController _controller = Get.put(FavoritesController(
        isPremium ? 'personalized_favorite' : 'likedAffirmations'));

    return Obx(() {
      if (!_controller.isInitialized.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (_controller.favorites.isEmpty) {
        return Center(
          child: MyText(
            text: 'No favorite affirmations found.',
            size: 20,
            weight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        );
      }

      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.65),
                child: PageView.builder(
                  itemCount: _controller.favorites.length,
                  onPageChanged: (index) =>
                      _controller.currentIndex.value = index,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (ctx, index) {
                    return Center(
                      child: MyText(
                        text: _controller.favorites[index],
                        size: 41,
                        weight: FontWeight.w700,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.GEORGIA,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            width: Get.width,
            child: Padding(
              padding: AppSize.HORIZONTAL,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      Assets.imagesArrowBackWhite,
                      height: 50,
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      // Image.asset(
                      //   Assets.imagesDownload,
                      //   height: 50,
                      // ),
                      GestureDetector(
                        onTap: () {
                          Share.share(
                              _controller
                                  .favorites[_controller.currentIndex.value],
                              subject: 'Check out this affirmation!');
                        },
                        child: Image.asset(
                          Assets.imagesShare,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_controller.currentIndex.value == 0)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: MyText(
                text: 'SCROLL UP',
                size: 15,
                weight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
    });
  }
}
