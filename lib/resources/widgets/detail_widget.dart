import 'package:flutter/material.dart';

import '../constants/colors.dart';

class DetailWidget extends StatelessWidget {
  const DetailWidget({super.key, required this.title, this.icon});
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.secondryText,
        ),
        const SizedBox(width: 3),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: AppColors.secondryText),
        ),
      ],
    );
  }
}
