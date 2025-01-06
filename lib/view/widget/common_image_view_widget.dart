import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:svg_flutter/svg.dart';

class CommonImageView extends StatelessWidget {
  String? url;
  String? imagePath;
  String? svgPath;
  File? file;
  double? height;
  double? width;
  double? radius;
  final BoxFit fit;
  final String placeHolder;

  CommonImageView({
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.radius = 0.0,
    this.fit = BoxFit.cover,
    this.placeHolder = 'assets/images/no_image_found.png',
  });

  @override
  Widget build(BuildContext context) {
    return _buildImageView();
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: SvgPicture.asset(
            svgPath!,
            fit: fit,
          ),
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: Image.file(
            file!,
            fit: fit,
          ),
        ),
      );
    } else if (url != null && url!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: CachedNetworkImage(
            fit: fit,
            imageUrl: url!,
            placeholder: (context, url) => Container(
              height: 23,
              width: 23,
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: kSecondaryColor,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder,
              fit: fit,
            ),
          ),
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: Image.asset(
            imagePath!,
            fit: fit,
          ),
        ),
      );
    }
    return SizedBox();
  }
}
