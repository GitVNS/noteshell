import 'package:flutter/material.dart';
import 'package:noteshell/interface/components/shared/gradient_background.dart';

class ProcessCompleteLayout extends StatelessWidget {
  const ProcessCompleteLayout({super.key, required this.title});

  final String title;

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
            const Icon(Icons.done, size: 50),
            const SizedBox(height: 16),
            Text(
              title,
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
