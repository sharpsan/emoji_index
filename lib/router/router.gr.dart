// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    EmojisRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmojisPage());
    }
  };

  @override
  List<RouteConfig> get routes => [RouteConfig(EmojisRoute.name, path: '/')];
}

/// generated route for [EmojisPage]
class EmojisRoute extends PageRouteInfo<void> {
  const EmojisRoute() : super(name, path: '/');

  static const String name = 'EmojisRoute';
}
