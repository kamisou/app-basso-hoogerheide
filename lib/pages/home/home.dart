import 'package:basso_hoogerheide/pages/calendar/calendar.dart';
import 'package:basso_hoogerheide/pages/home/app_bar.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Curve _pageAnimationCurve = Curves.easeInOutQuad;

  static const Duration _pageAnimationDuration = Duration(milliseconds: 500);

  final List<HomePageBody> _pageBodies = [
    CalendarPage(title: 'Agenda', fabAction: () {}),
  ];

  final PageController _pageController = PageController();

  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageControllerListener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _pageControllerListener() {
    if (_pageController.hasClients) {
      final int pageIndex = _pageController.page?.round() ?? 0;
      if (pageIndex != _pageIndex) {
        setState(() => _pageIndex = pageIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              HomeAppBar(
                curve: _pageAnimationCurve,
                duration: _pageAnimationDuration,
                pageTitles: _pageBodies.map((e) => e.title).toList(),
                selectedPageIndex: _pageIndex,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: _pageBodies,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _pageBodies[_pageIndex].fabAction != null
            ? FloatingActionButton(
                // TODO: add event
                onPressed: _pageBodies[_pageIndex].fabAction,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
