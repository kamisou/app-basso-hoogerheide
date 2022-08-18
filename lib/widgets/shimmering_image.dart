import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringImage extends StatelessWidget {
  const ShimmeringImage({
    super.key,
    this.url,
    this.imageFit,
    required this.errorBuilder,
  });

  final String? url;

  final BoxFit? imageFit;

  final WidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return url?.isNotEmpty ?? false
        ? Image.network(
            url!,
            fit: imageFit,
            errorBuilder: (context, _, __) => errorBuilder(context),
            loadingBuilder: (_, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor:
                    Theme.of(context).inputDecorationTheme.fillColor!,
                child: child,
              );
            },
          )
        : errorBuilder(context);
  }
}
