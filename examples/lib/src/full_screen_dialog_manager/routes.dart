import 'package:examples/src/common/widgets/home_template.dart';
import 'package:examples/src/full_screen_dialog_manager/screens/full_screen_dialog_manager_customization_screen.dart';
import 'package:flutter/material.dart';

import 'screens/screens.dart';

enum FullScreenDialogManagerRoutes {
  basicUsage(name: 'basic usage'),
  home(name: 'full screen dialog manager home'),
  customization(name: 'customization');

  final String name;

  const FullScreenDialogManagerRoutes({
    required this.name,
  });

  Widget get screen {
    switch (this) {
      case FullScreenDialogManagerRoutes.home:
        return HomeTemplate(
          title: 'Full Screen Dialog Manager',
          destinations: {
            for (var element in FullScreenDialogManagerRoutes.values
                .where(
                  (element) => element != FullScreenDialogManagerRoutes.home,
                )
                .toList())
              (element).name: () => (element).route
          },
        );
      case FullScreenDialogManagerRoutes.basicUsage:
        return const FullScreenDialogManagerBasicUsageScreen();

      case FullScreenDialogManagerRoutes.customization:
        return const FullScreenDialogManagerCustomizationScreen();
    }
  }

  Route get route => _buildRoute(screen);

  Route _buildRoute(Widget child) => MaterialPageRoute(builder: (_) => child);
}
