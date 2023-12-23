import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/features/auth/bloc/auth_bloc.dart';
import 'package:cilean/features/auth/interfaces/login/login_screen.dart';
import 'package:cilean/features/auth/interfaces/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  late final AnimationController _loginHeaderController;
  late final AnimationController _loginContentController;

  late final AnimationController _registerHeaderController;
  late final AnimationController _registerContentController;

  @override
  void initState() {
    super.initState();

    _loginHeaderController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ));
    _loginContentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _registerHeaderController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ));

    _registerContentController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1200,
        ));
  }

  @override
  void dispose() {
    _loginHeaderController.dispose();
    _loginContentController.dispose();
    _registerHeaderController.dispose();
    _registerContentController.dispose();

    super.dispose();
  }

  void _onPageSlideEvent(DragUpdateDetails details) {
    if (details.delta.dx < -2 && _pageIndex + 1 < 2) {
      _loginHeaderController.reverse();
      _loginContentController.reverse().then((value) {
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          _pageController.jumpToPage(_pageIndex + 1);
          _pageIndex = _pageIndex + 1;
        });
      });
    }
    if (details.delta.dx > 2 && _pageIndex - 1 >= 0) {
      _registerHeaderController.reverse();
      _registerContentController.reverse().then((value) {
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          _pageController.jumpToPage(_pageIndex - 1);
          _pageIndex = _pageIndex - 1;
        });
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(),
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onPanUpdate: _onPageSlideEvent,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          LoginScreen(
                            headerController: _loginHeaderController,
                            contentController: _loginContentController,
                          ),
                          RegisterScreen(
                            headerController: _registerHeaderController,
                            contentController: _registerContentController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
