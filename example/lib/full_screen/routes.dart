import 'package:example/full_screen/screens/full_screen_dialog_customization_screen.dart';
import 'package:example/widget/home_template.dart';
import 'package:flutter/material.dart';

import 'screens/screens.dart';

enum FullScreenDialogRoutes {
  basicUsage(name: 'basic usage'),
  home(name: 'full screen dialog manager home'),
  customization(name: 'customization');

  final String name;

  const FullScreenDialogRoutes({
    required this.name,
  });

  Widget get screen {
    switch (this) {
      case FullScreenDialogRoutes.home:
        return HomeTemplate(
          title: 'Full Screen Dialog Manager',
          destinations: {
            for (var element in FullScreenDialogRoutes.values
                .where(
                  (element) => element != FullScreenDialogRoutes.home,
                )
                .toList())
              (element).name: () => (element).route
          },
        );
      case FullScreenDialogRoutes.basicUsage:
        return const FullScreenDialogManagerBasicUsageScreen();

      case FullScreenDialogRoutes.customization:
        return const FullScreenDialogCustomizationScreen();
    }
  }

  Route get route => _buildRoute(screen);

  Route _buildRoute(Widget child) => MaterialPageRoute(builder: (_) => child);
}
