import 'package:cilean/constants/config/size_config.dart';
import 'package:flutter/material.dart';

class CHomeContentCard extends StatelessWidget {
  const CHomeContentCard({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Container(
      width: (SizeConfig.screenWidth -
              SizeConfig.blockWidth * 12 -
              SizeConfig.blockWidth * 8) /
          2,
      height: SizeConfig.blockHeight * 20,
      padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.08),
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      child: child,
    );
  }
}
