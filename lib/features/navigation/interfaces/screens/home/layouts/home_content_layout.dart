import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/data/models/report_model.dart';
import 'package:cilean/data/repository/report_repository.dart';
import 'package:cilean/features/navigation/interfaces/screens/home/components/c_home_content_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeContentLayout extends StatefulWidget {
  const HomeContentLayout({Key? key}) : super(key: key);

  @override
  _HomeContentLayoutState createState() => _HomeContentLayoutState();
}

class _HomeContentLayoutState extends State<HomeContentLayout> {
  final _reportRepository = ReportRepository();
  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockHeight * 35,
      ),
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.blockHeight * 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CHomeContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(SizeConfig.blockWidth),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.4),
                        ),
                      ),
                      child: Icon(
                        Icons.group,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.4),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 2),
                    StreamBuilder<List<List<ReportModel>>>(
                        stream: _reportRepository.fetchAllReports(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${snapshot.data!.length.toString()} /-",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'persons',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.4),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.blockWidth * 4),
              CHomeContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(SizeConfig.blockWidth),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.4),
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.4),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 2),
                    StreamBuilder<List<ReportModel>>(
                        stream: _reportRepository.fetchSingleUserReports(
                            FirebaseAuth.instance.currentUser!.email!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${snapshot.data!.length.toString()} /-",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'all-time',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.4),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
