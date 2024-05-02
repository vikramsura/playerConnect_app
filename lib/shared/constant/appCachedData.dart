import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player_connect/shared/constant/api_utils.dart';
import 'package:player_connect/shared/constant/font_size.dart';

class AppCachesImages {
  static Widget cachedImages(images) {
    return Container(
      height: AppFontSize.font60,
      width: AppFontSize.font60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppFontSize.font30)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppFontSize.font30),
        child: CachedNetworkImage(
            imageUrl: AppApiUtils.imageUrl + images,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
            fit: BoxFit.cover),
      ),
    );
  }
}
