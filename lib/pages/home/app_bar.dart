import 'package:basso_hoogerheide/models/repository/profile.dart';
import 'package:basso_hoogerheide/widgets/avatar_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class HomeAppBar extends ConsumerStatefulWidget {
  const HomeAppBar({
    super.key,
    required this.controller,
    required this.pageTitles,
  });

  final PageController controller;

  final List<String> pageTitles;

  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  static const double _tabWidth = 100;

  static const Duration _animationDuration = Duration(milliseconds: 250);

  static const Curve _animationCurve = Curves.easeInOutQuad;

  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
  }

  void _controllerListener() {
    final double page = widget.controller.page!;
    final int pageIndex = page.round();
    _scrollController.position.jumpTo(page * 100);
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
          ref.watch(appUserProvider).when(
                data: (data) => GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: AvatarCircle(
                    avatarUrl: data.avatarUrl,
                    initials: data.initials,
                  ),
                ),
                error: (_, __) => GestureDetector(
                  onTap: () {
                    ref.read(profileRepository).logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 40,
                    height: 40,
                    child: Text(
                      '!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                loading: () => Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor:
                      Theme.of(context).inputDecorationTheme.fillColor!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    width: 40,
                    height: 40,
                  ),
                ),
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
                controller: _scrollController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  ...List.generate(
                    widget.pageTitles.length,
                    (index) => Container(
                      alignment: Alignment.centerLeft,
                      width: _tabWidth,
                      child: GestureDetector(
                        onTap: () => widget.controller.animateToPage(
                          index,
                          duration: _animationDuration,
                          curve: _animationCurve,
                        ),
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
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
              Future.delayed(
                const Duration(milliseconds: 500),
                ref.read(profileRepository).logout,
              );
            },
            child: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
