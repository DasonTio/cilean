import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/features/navigation/interfaces/screens/home/home_view.dart';
import 'package:cilean/features/navigation/interfaces/screens/map/map_view.dart';
import 'package:cilean/features/navigation/interfaces/screens/profile/profile_view.dart';
import 'package:cilean/features/navigation/interfaces/screens/report/report_view.dart';
import 'package:flutter/material.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isTapped = false;

  void _handleNavigationPageChange(int index) {
    if (_isTapped == true && index != _currentPage) return;
    setState(() {
      _currentPage = index;
      _isTapped = false;
    });
  }

  void _handleNavigationTap(int index) {
    if (index == _currentPage) return;
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300 * (_currentPage - index).abs()),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isTapped = true;
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Scaffold(
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            PageView(
              onPageChanged: _handleNavigationPageChange,
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              children: const [
                HomeView(),
                MapView(),
                ReportView(),
                ProfileView(),
              ],
            ),
            Positioned(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockHeight * 18,
              top: SizeConfig.blockHeight * 80.5,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockWidth * 8,
                  vertical: SizeConfig.blockHeight * 4,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BottomNavigationBar(
                    currentIndex: _currentPage,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Theme.of(context).colorScheme.background,
                    unselectedItemColor: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.4),
                    onTap: _handleNavigationTap,
                    items: [
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: SizeConfig.blockHeight * 5,
                          child: const Icon(Icons.widgets_outlined),
                        ),
                        activeIcon: const Icon(Icons.widgets_rounded),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: SizeConfig.blockHeight * 5,
                          child: const Icon(Icons.map_outlined),
                        ),
                        activeIcon: const Icon(Icons.map_rounded),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: SizeConfig.blockHeight * 5,
                          child: const Icon(Icons.info_outline_rounded),
                        ),
                        activeIcon: const Icon(Icons.info_rounded),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: SizeConfig.blockHeight * 5,
                          child: const Icon(Icons.person_outline),
                        ),
                        activeIcon: const Icon(Icons.person_rounded),
                        label: '',
                      ),
                    ],
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
