import 'package:educational_app/core/res/app_colors.dart';
import 'package:flutter/material.dart';

class PopupItem extends StatelessWidget {
  const PopupItem({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Icon(
          icon,
          color: AppColors.neutralTextColour,
        ),
      ],
    );
  }
}
