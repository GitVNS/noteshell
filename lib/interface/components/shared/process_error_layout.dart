import 'package:flutter/material.dart';
import 'package:noteshell/interface/components/shared/gradient_background.dart';

class ProcessErrorLayout extends StatelessWidget {
  const ProcessErrorLayout({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GradientBackground(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              "Something Went Wrong",
              style: textTheme.bodyLarge!.copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
