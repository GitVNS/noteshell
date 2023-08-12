import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NotesScreenAppBar extends StatelessWidget {
  const NotesScreenAppBar({super.key, required this.onTrashButtonTap});

  final VoidCallback onTrashButtonTap;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 120,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Noteshell",
                  style: textTheme.displayMedium,
                ),
                Text(
                  "Your notes on our cloud ☁",
                  textAlign: TextAlign.left,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: onTrashButtonTap,
              splashFactory: InkSparkle.splashFactory,
              splashColor: Colors.white54,
              borderRadius: BorderRadius.circular(100),
              child: Ink(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColors.onPrimaryColor, width: 1.5),
                ),
                padding: const EdgeInsets.all(4),
                child: const Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.onPrimaryColor,
                    radius: 30,
                    child: Icon(Icons.delete, color: AppColors.primaryColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
