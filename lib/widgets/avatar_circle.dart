import 'package:flutter/material.dart';

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
        type: MaterialType.circle,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              initials,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (avatarUrl?.isNotEmpty ?? false)
              Image.network(
                avatarUrl!,
                height: radius,
                width: radius,
              ),
          ],
        ),
      ),
    );
  }
}
