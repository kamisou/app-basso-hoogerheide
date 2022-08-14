import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    super.key,
    required this.curve,
    required this.duration,
    required this.pageTitles,
    required this.selectedPageIndex,
  });

  final Curve curve;

  final Duration duration;

  final List<String> pageTitles;

  final int selectedPageIndex;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final PageController _pageController = PageController();

  @override
  void didUpdateWidget(covariant HomeAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPageIndex != oldWidget.selectedPageIndex) {
      _pageController.animateToPage(
        widget.selectedPageIndex,
        duration: widget.duration,
        curve: widget.curve,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              type: MaterialType.circle,
              child: InkWell(
                // TODO: go to profile
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Center(
                  child: Text(
                    'JM',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            child: ListView.builder(
              controller: _pageController,
              itemCount: widget.pageTitles.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.pageTitles[index],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: index == widget.selectedPageIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
          GestureDetector(
            // TODO: leave app
            onTap: () {},
            child: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
