import 'package:example/screens/custom_agent_manager.dart';
import 'package:example/screens/home_screen.dart';
import 'package:example/screens/modal_banner_screen.dart';
import 'package:example/screens/positioned_dialogs_screen.dart';
import 'package:flutter/material.dart';

class EasyRouter {
  static const initialRoute = '/';
  static const positionedDialogsRoute = '/positioned';
  static const modalBannerRoute = '/modal-banner';
  static const customAgentRoute = '/custom-agent';

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
          const ModalBannerScreen(),
        );
      case customAgentRoute:
        return _buildRoute(
          const CustomAgentDialogsScreen(),
        );
      default:
        return null;
    }
  }

  static _buildRoute(Widget child) => MaterialPageRoute(builder: (_) => child);
}
