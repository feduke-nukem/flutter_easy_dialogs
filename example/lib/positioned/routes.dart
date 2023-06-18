import 'package:example/widget/home_template.dart';
import 'package:flutter/material.dart';

import 'screens/positioned_dialog_basic_usage.dart';
import 'screens/positioned_dialog_customization_screen.dart';

enum PositionedDialogRoutes {
  basicUsage(name: 'basic usage'),
  home(name: 'positioned dialog manager home'),
  customization(name: 'customization');

  final String name;

  const PositionedDialogRoutes({required this.name});

  Widget get screen {
    switch (this) {
      case PositionedDialogRoutes.home:
        return HomeTemplate(
          title: 'Positioned Dialog Manager',
          destinations: {
            for (var element in PositionedDialogRoutes.values
                .where(
                  (element) => element != PositionedDialogRoutes.home,
                )
                .toList())
              (element).name: () => (element).route
          },
        );
      case PositionedDialogRoutes.basicUsage:
        return const PositionedDialogManagerBasicUsageScreen();

      case PositionedDialogRoutes.customization:
        return const PositionedDialogManagerCustomizationScreen();
    }
  }

  Route get route => _buildRoute(screen);

  Route _buildRoute(Widget child) => MaterialPageRoute(builder: (_) => child);
}
