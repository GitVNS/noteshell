import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class StyledFabButton extends StatelessWidget {
  const StyledFabButton(
      {super.key,
      required this.onPressed,
      required this.tooltip,
      required this.iconData});

  final VoidCallback onPressed;
  final String tooltip;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      backgroundColor: AppColors.onPrimaryColor,
      foregroundColor: AppColors.primaryColor,
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(iconData),
    );
  }
}
