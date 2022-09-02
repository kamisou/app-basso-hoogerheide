import 'package:flutter/material.dart';

class ProfileOption extends StatefulWidget {
  const ProfileOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bodyBuilder,
    this.headerPadding,
  });

  final Widget title;

  final Widget subtitle;

  final Widget Function(BuildContext, VoidCallback) bodyBuilder;

  final EdgeInsets? headerPadding;

  @override
  State<ProfileOption> createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<ProfileOption> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Card(
            shape: const RoundedRectangleBorder(),
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: widget.headerPadding ?? EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.title,
                    widget.subtitle,
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: _expanded
                ? widget.bodyBuilder(
                    context, () => setState(() => _expanded = false))
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
