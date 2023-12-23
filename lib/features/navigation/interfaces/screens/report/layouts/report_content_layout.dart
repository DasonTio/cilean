import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/data/models/report_model.dart';
import 'package:cilean/data/repository/report_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportContentLayout extends StatefulWidget {
  const ReportContentLayout({Key? key}) : super(key: key);

  @override
  _ReportContentLayoutState createState() => _ReportContentLayoutState();
}

class _ReportContentLayoutState extends State<ReportContentLayout> {
  final ReportRepository _repository = ReportRepository();

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.blockHeight * 80,
      child: StreamBuilder<List<ReportModel>>(
        stream: _repository
            .fetchSingleUserReports(FirebaseAuth.instance.currentUser!.email!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ReportModel> listData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Report',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Expanded(
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        ReportModel data = listData[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                const TextSpan(
                                  text: 'Report ',
                                ),
                                TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: data.verified!
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  text: data.verified!
                                      ? "Verified"
                                      : "Not Verified",
                                )
                              ],
                            ),
                          ),
                          subtitle: Text(
                            'Lat: ${data.location?.latitude ?? 0} | Lng: ${data.location?.longitude ?? 0}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Icon(Icons.gps_fixed),
                        );
                      }),
                ),
              ],
            );
          }
          return Container(
            alignment: Alignment.center,
            child: Text(
              "No trash reported yet",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }
}
