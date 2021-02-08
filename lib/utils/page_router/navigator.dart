import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';

export 'routes.dart';

class PageRouter {
  static Future gotoWidget(
      Widget screen,
      BuildContext context, {
        bool clearStack = false,
        bool fullScreenDialog = false,
        AnimationType animationType = AnimationType.slide_right,
      }) =>
      !clearStack
          ? Navigator.of(context).push(
        PageRouteTransition(
          animationType: animationType,
          builder: (context) => screen,
          fullscreenDialog: fullScreenDialog,
        ),
      )
          : Navigator.of(context).pushAndRemoveUntil(
        PageRouteTransition(
          animationType: animationType,
          builder: (context) => screen,
          fullscreenDialog: fullScreenDialog,
        ),
            (_) => false,
      );

  static Future gotoNamed(String route, BuildContext context,
      {bool clearStack = false, dynamic args = Object}) =>
      !clearStack
          ? Navigator.of(context).pushNamed(route, arguments: args)
          : Navigator.of(context)
          .pushNamedAndRemoveUntil(route, (_) => false, arguments: args);

  static void goBack(BuildContext context, {bool rootNavigator = false}) {
    Navigator.of(context, rootNavigator: rootNavigator).pop();
  }
}