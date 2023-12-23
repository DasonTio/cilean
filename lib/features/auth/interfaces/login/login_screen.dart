import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/features/auth/interfaces/login/login_content_layout.dart';
import 'package:cilean/features/auth/interfaces/login/login_header_layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    required this.headerController,
    required this.contentController,
  }) : super(key: key);

  final AnimationController headerController;
  final AnimationController contentController;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 6,
                vertical: SizeConfig.blockHeight * 6,
              ),
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight - SizeConfig.blockHeight * 4,
              // height: SizeConfig.screenHeight - SizeConfig.blockHeight * 15,
              child: Column(
                children: [
                  LoginHeaderLayout(controller: widget.headerController),
                  LoginContentLayout(controller: widget.contentController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
