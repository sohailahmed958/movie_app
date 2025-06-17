import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/widgets/app_loading_widget.dart';

import '../constants/app_constants.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double borderRadius;

  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Defensive check: If imageUrl is null or empty, display error widget immediately
    if (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute) {
      return errorWidget ?? const Icon(Icons.broken_image, color: Colors.grey, size: 48);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? const AppLoadingWidget(),
        errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error, color: Colors.red, size: 48),
        fadeInDuration: AppConstants.animationDuration,
        fadeOutDuration: AppConstants.animationDuration,
        // Fix: Only convert to int if width/height are non-null and finite.
        // If they are infinity (from Expanded), pass null, and CachedNetworkImage will handle it.
        memCacheHeight: (height != null && height!.isFinite) ? height!.toInt() : null,
        memCacheWidth: (width != null && width!.isFinite) ? width!.toInt() : null,
      ),
    );
  }
}



/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/widgets/app_loading_widget.dart';

import '../constants/app_constants.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double borderRadius;

  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius = 0, // Default to no border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? const Icon(Icons.broken_image, color: Colors.grey, size: 48); // Show broken image icon if URL is empty
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? const AppLoadingWidget(), // Use AppLoadingWidget as default placeholder
        errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error, color: Colors.red, size: 48), // Default error icon
        fadeInDuration: AppConstants.animationDuration, // Fade in animation
        fadeOutDuration: AppConstants.animationDuration, // Fade out animation
        // Optimize memory cache for better performance
        memCacheHeight: height != null ? height?.toInt() : null,
        memCacheWidth: width != null ? width?.toInt() : null,
      ),
    );
  }
}
*/



/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/widgets/app_loading_widget.dart';

import '../constants/app_constants.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double borderRadius;

  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? const AppLoadingWidget(),
        errorWidget:
            (context, url, error) => errorWidget ?? const Icon(Icons.error),
        fadeInDuration: AppConstants.animationDuration,
        fadeOutDuration: AppConstants.animationDuration,
        memCacheHeight: height?.toInt(),
        memCacheWidth: width?.toInt(),
      ),
    );
  }
}
*/