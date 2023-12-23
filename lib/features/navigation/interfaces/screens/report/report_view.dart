import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/features/navigation/interfaces/screens/report/layouts/report_camera_layout.dart';
import 'package:cilean/features/navigation/interfaces/screens/report/layouts/report_content_layout.dart';
import 'package:camera/camera.dart';
import 'package:cilean/data/repository/report_repository.dart';
import 'package:flutter/material.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final ReportRepository _repository = ReportRepository();

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
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 8,
                vertical: SizeConfig.blockHeight * 2,
              ),
              child: Column(
                children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    height:
                        SizeConfig.screenHeight - SizeConfig.blockHeight * 12,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await availableCameras().then(
                              (value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ReportCameraLayout(cameras: value),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              SizeConfig.blockWidth * 50,
                              SizeConfig.blockWidth * 50,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            shape: const CircleBorder(),
                          ),
                          child: Text(
                            "REPORT",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 8),
                  ReportContentLayout(),
                  SizedBox(height: SizeConfig.blockHeight * 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
