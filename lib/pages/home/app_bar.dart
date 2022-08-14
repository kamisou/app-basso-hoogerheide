import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    super.key,
    required this.controller,
    required this.pageTitles,
  });

  final PageController controller;

  final List<String> pageTitles;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  static const double _titleTabExtent = 120;

  final PageController _pageController = PageController();

  int _index = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    if (widget.controller.hasClients) {
      final int index = widget.controller.page!.round();
      if (index != _index) {
        setState(() => _index = index);
      }
      _pageController.jumpTo(widget.controller.page! * _titleTabExtent);
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
              itemExtent: _titleTabExtent,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.pageTitles[index],
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: index == _index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  ),
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
