import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.initials,
    this.avatarUrl,
    this.radius = 40,
  });

  final String? avatarUrl;

  final String initials;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        type: MaterialType.circle,
        child: Stack(
          alignment: Alignment.center,
          children: [
            avatarUrl?.isNotEmpty ?? false
                ? Image.network(
                    avatarUrl!,
                    height: radius,
                    width: radius,
                    errorBuilder: (_, __, ___) => Text(
                      initials,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
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
                : Text(
                    initials,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ],
        ),
      ),
    );
  }
}
