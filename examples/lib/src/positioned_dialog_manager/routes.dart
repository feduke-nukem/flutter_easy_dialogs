import 'package:examples/src/common/widgets/home_template.dart';
import 'package:flutter/material.dart';

import 'screens/positioned_dialog_manager_basic_usage.dart';
import 'screens/positioned_dialog_manager_customization_screen.dart';

enum PositionedDialogManagerRoutes {
  basicUsage(name: 'basic usage'),
  home(name: 'positioned dialog manager home'),
  customization(name: 'customization');

  final String name;

  const PositionedDialogManagerRoutes({required this.name});

  Widget get screen {
    switch (this) {
      case PositionedDialogManagerRoutes.home:
        return HomeTemplate(
          title: 'Positioned Dialog Manager',
          destinations: {
            for (var element in PositionedDialogManagerRoutes.values
                .where(
                  (element) => element != PositionedDialogManagerRoutes.home,
                )
                .toList())
              (element).name: () => (element).route
          },
        );
      case PositionedDialogManagerRoutes.basicUsage:
        return const PositionedDialogManagerBasicUsageScreen();

      case PositionedDialogManagerRoutes.customization:
        return const PositionedDialogManagerCustomizationScreen();
    }
  }

  Route get route => _buildRoute(screen);

  Route _buildRoute(Widget child) => MaterialPageRoute(builder: (_) => child);
}
