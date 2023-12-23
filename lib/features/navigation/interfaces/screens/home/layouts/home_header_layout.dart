import 'package:cilean/constants/config/size_config.dart';
import 'package:flutter/material.dart';

class HomeHeaderLayout extends StatefulWidget {
  const HomeHeaderLayout({Key? key}) : super(key: key);

  @override
  _HomeHeaderLayoutState createState() => _HomeHeaderLayoutState();
}

class _HomeHeaderLayoutState extends State<HomeHeaderLayout> {
  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Container(
      height: SizeConfig.blockHeight * 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dason Tiovino',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Healthy town healthy life',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          ),
        ],
      ),
    );
  }
}
