import 'package:basso_hoogerheide/widgets/shimmering_image.dart';
import 'package:flutter/material.dart';

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.initials,
    this.avatarUrl,
    this.backgroundColor,
    this.style,
    this.radius = 40,
  });

  final String? avatarUrl;

  final String initials;

  final double radius;

  final Color? backgroundColor;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: Material(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        type: MaterialType.circle,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: radius,
              width: radius,
              child: ShimmeringImage(
                url: avatarUrl,
                height: radius,
                width: radius,
                errorBuilder: (context) => Text(
                  initials,
                  style: style ??
                      Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
