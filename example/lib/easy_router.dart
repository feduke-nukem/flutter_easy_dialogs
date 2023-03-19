import 'package:example/screens/custom_manager_screen.dart';
import 'package:example/screens/home_screen.dart';
import 'package:example/screens/positioned_dialog_customization_screen.dart';
import 'package:example/screens/positioned_dialogs_screen.dart';
import 'package:flutter/material.dart';

import 'screens/full_screen_dialog_screen.dart';

class EasyRouter {
  static const initialRoute = '/';
  static const positionedDialogsRoute = '/positioned';
  static const modalBannerRoute = '/full-screen';
  static const customAgentRoute = '/custom-agent';
  static const positionedDialogCustomization = '/positioned-customization';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return _buildRoute(
          const HomeScreen(),
        );
      case positionedDialogsRoute:
        return _buildRoute(
          const PositionedDialogsScreen(),
        );
      case modalBannerRoute:
        return _buildRoute(
          const FullScreenDialogScreen(),
        );
      case customAgentRoute:
        return _buildRoute(
          const CustomManagerDialogsScreen(),
        );

      case positionedDialogCustomization:
        return _buildRoute(const PositionedDialogCustomizationScreen());
      default:
        return null;
    }
  }

  static _buildRoute(Widget child) => MaterialPageRoute(builder: (_) => child);
}
