import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/features/navigation/interfaces/screens/home/layouts/home_content_layout.dart';
import 'package:cilean/features/navigation/interfaces/screens/home/layouts/home_header_layout.dart';
import 'package:cilean/features/navigation/interfaces/screens/home/layouts/home_map_layout.dart';
import 'package:cilean/features/navigation/interfaces/screens/home/layouts/home_report_layout.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 8,
                vertical: SizeConfig.blockHeight * 2,
              ),
              child: const Column(
                children: [
                  HomeHeaderLayout(),
                  HomeMapLayout(),
                  HomeReportLayout(),
                  HomeContentLayout(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
