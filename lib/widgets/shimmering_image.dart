import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringImage extends StatelessWidget {
  const ShimmeringImage({
    super.key,
    required this.errorBuilder,
    this.url,
    this.width,
    this.height,
    this.imageFit = BoxFit.cover,
  });

  final String? url;

  final BoxFit? imageFit;

  final WidgetBuilder errorBuilder;

  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return url?.isNotEmpty ?? false
        ? Image.network(
            url!,
            fit: imageFit,
            height: height,
            width: width,
            errorBuilder: (context, _, __) => errorBuilder(context),
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame != null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor:
                    Theme.of(context).inputDecorationTheme.fillColor!,
                child: Container(
                  width: width ?? double.infinity,
                  height: height ?? double.infinity,
                  color: Theme.of(context).colorScheme.surface,
                ),
              );
            },
          )
        : errorBuilder(context);
  }
}
