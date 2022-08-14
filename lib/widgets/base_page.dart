import 'package:basso_hoogerheide/pages/calendar/calendar.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final PageController _pageController = PageController();

  int _pageIndex = 0;

  final List<BasePageBody> _pageBodies = [
    CalendarPage(title: 'Agenda', fabAction: () {}),
  ];

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
              Container(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox(width: 40)),
                    GestureDetector(
                      // TODO: leave app
                      onTap: () {},
                      child: const Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
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
