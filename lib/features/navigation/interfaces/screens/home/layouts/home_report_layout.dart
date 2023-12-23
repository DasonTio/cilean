import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/data/models/report_model.dart';
import 'package:cilean/data/repository/report_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeReportLayout extends StatefulWidget {
  const HomeReportLayout({Key? key}) : super(key: key);

  @override
  _HomeReportLayoutState createState() => _HomeReportLayoutState();
}

class _HomeReportLayoutState extends State<HomeReportLayout> {
  final ReportRepository _reportRepository = ReportRepository();

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Container(
      height: SizeConfig.blockHeight * 15,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockWidth * 5,
        vertical: SizeConfig.blockHeight,
      ),
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.blockHeight * 1.5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Trash Report',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: SizeConfig.blockHeight * 0.5),
              SizedBox(
                width: SizeConfig.blockWidth * 45,
                child: Text(
                  'Percentage reported trash this month.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          StreamBuilder<List<ReportModel>>(
              stream: _reportRepository.fetchSingleUserReportsCurrentMonth(
                FirebaseAuth.instance.currentUser!.email!,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      SizedBox(
                        width: SizeConfig.blockHeight * 10,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onSecondary,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.1),
                            value: snapshot.data!.length / 10,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          width: SizeConfig.blockHeight * 10,
                          height: SizeConfig.blockHeight * 10,
                          alignment: Alignment.center,
                          child: Text(
                            "${(snapshot.data!.length / 10 * 100).toStringAsFixed(0)}%",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSecondary,
                );
              }),
        ],
      ),
    );
  }
}
