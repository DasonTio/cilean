import 'package:cilean/constants/config/size_config.dart';
import 'package:flutter/material.dart';

class LoginHeaderLayout extends StatefulWidget {
  const LoginHeaderLayout({Key? key, required this.controller})
      : super(key: key);
  final AnimationController controller;
  @override
  _LoginHeaderLayoutState createState() => _LoginHeaderLayoutState();
}

class _LoginHeaderLayoutState extends State<LoginHeaderLayout> {
  late final Animation<Offset> _offsetTitleAnimation;
  late final Animation<Offset> _offsetFirstHeadlineAnimation;
  late final Animation<Offset> _offsetSecondHeadlineAnimation;

  @override
  void initState() {
    super.initState();

    widget.controller.forward();

    _offsetTitleAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          0.1,
          0.6,
          curve: Curves.easeInOut,
        ),
        reverseCurve: const Interval(
          0.1,
          0.6,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _offsetFirstHeadlineAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          0.3,
          0.8,
          curve: Curves.easeInOut,
        ),
        reverseCurve: const Interval(
          0.3,
          0.8,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _offsetSecondHeadlineAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          0.5,
          1.0,
          curve: Curves.easeInOut,
        ),
        reverseCurve: const Interval(
          0.5,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return SizedBox(
      height: SizeConfig.blockHeight * 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.blockHeight * 4.5,
            child: ClipRRect(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: SlideTransition(
                      position: _offsetTitleAnimation,
                      child: Text(
                        "Let's sign you in.",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: SizeConfig.blockHeight * 1.4),
          SizedBox(
            height: SizeConfig.blockHeight * 4,
            child: ClipRRect(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: SlideTransition(
                      position: _offsetFirstHeadlineAnimation,
                      child: Text(
                        "Welcome back.",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 24,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.5),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.blockHeight * 4,
            child: ClipRRect(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: SlideTransition(
                      position: _offsetSecondHeadlineAnimation,
                      child: Text(
                        "You've been missed!",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 24,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.5),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
