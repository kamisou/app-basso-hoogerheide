import 'package:basso_hoogerheide/pages/home/app_bar.dart';
import 'package:basso_hoogerheide/pages/home/calendar/calendar.dart';
import 'package:basso_hoogerheide/pages/home/contacts/contacts.dart';
import 'package:basso_hoogerheide/pages/home/folders/folders.dart';
import 'package:basso_hoogerheide/pages/home/models/models.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<HomePageBody> _pageBodies = [
    const CalendarPage(),
    const ContactsPage(),
    const FoldersPage(),
    const ModelsPage(),
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
                controller: _pageController,
                pageTitles: _pageBodies.map((e) => e.title).toList(),
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
                onPressed: _pageBodies[_pageIndex].fabAction,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
