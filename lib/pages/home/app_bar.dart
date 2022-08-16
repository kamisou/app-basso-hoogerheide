import 'package:basso_hoogerheide/widgets/avatar_circle.dart';
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
  static const double _tabWidth = 100;

  final ScrollController _controller = ScrollController();

  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_controllerListener);
    _controller.dispose();
  }

  void _controllerListener() {
    final double page = widget.controller.page!;
    final int pageIndex = page.round();
    _controller.position.jumpTo(page * 100);
    if (_pageIndex != pageIndex) {
      setState(() => _pageIndex = pageIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 32),
      child: Row(
        children: [
          const AvatarCircle(
            avatarUrl: '',
            initials: 'JM',
          ),
          const SizedBox(width: 50),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0x00FFFFFF),
                ],
                begin: Alignment(-.5, 0),
              ).createShader(bounds),
              child: ListView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  ...List.generate(
                    widget.pageTitles.length,
                    (index) => Container(
                      alignment: Alignment.centerLeft,
                      width: _tabWidth,
                      child: Text(
                        widget.pageTitles[index],
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: index == _pageIndex
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          GestureDetector(
            // TODO: sair do app
            onTap: () {},
            child: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
