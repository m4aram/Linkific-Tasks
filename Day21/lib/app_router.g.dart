// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $getXRoute,
      $freezedRoute,
      $dioRoute,
      $hiveRoute,
      $utilitiesRoute,
      $routerExampleRoute,
      $productDetailsRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      hasOverriddenOnExit: false,
      factory: $HomeRoute._fromState,
    );

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location(
        '/',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $getXRoute => GoRouteData.$route(
      path: '/getx',
      hasOverriddenOnExit: false,
      factory: $GetXRoute._fromState,
    );

mixin $GetXRoute on GoRouteData {
  static GetXRoute _fromState(GoRouterState state) => const GetXRoute();

  @override
  String get location => GoRouteData.$location(
        '/getx',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $freezedRoute => GoRouteData.$route(
      path: '/freezed',
      hasOverriddenOnExit: false,
      factory: $FreezedRoute._fromState,
    );

mixin $FreezedRoute on GoRouteData {
  static FreezedRoute _fromState(GoRouterState state) => const FreezedRoute();

  @override
  String get location => GoRouteData.$location(
        '/freezed',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $dioRoute => GoRouteData.$route(
      path: '/dio',
      hasOverriddenOnExit: false,
      factory: $DioRoute._fromState,
    );

mixin $DioRoute on GoRouteData {
  static DioRoute _fromState(GoRouterState state) => const DioRoute();

  @override
  String get location => GoRouteData.$location(
        '/dio',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $hiveRoute => GoRouteData.$route(
      path: '/hive',
      hasOverriddenOnExit: false,
      factory: $HiveRoute._fromState,
    );

mixin $HiveRoute on GoRouteData {
  static HiveRoute _fromState(GoRouterState state) => const HiveRoute();

  @override
  String get location => GoRouteData.$location(
        '/hive',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $utilitiesRoute => GoRouteData.$route(
      path: '/utilities',
      hasOverriddenOnExit: false,
      factory: $UtilitiesRoute._fromState,
    );

mixin $UtilitiesRoute on GoRouteData {
  static UtilitiesRoute _fromState(GoRouterState state) =>
      const UtilitiesRoute();

  @override
  String get location => GoRouteData.$location(
        '/utilities',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $routerExampleRoute => GoRouteData.$route(
      path: '/router',
      hasOverriddenOnExit: false,
      factory: $RouterExampleRoute._fromState,
    );

mixin $RouterExampleRoute on GoRouteData {
  static RouterExampleRoute _fromState(GoRouterState state) =>
      const RouterExampleRoute();

  @override
  String get location => GoRouteData.$location(
        '/router',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $productDetailsRoute => GoRouteData.$route(
      path: '/details/:id',
      hasOverriddenOnExit: false,
      factory: $ProductDetailsRoute._fromState,
    );

mixin $ProductDetailsRoute on GoRouteData {
  static ProductDetailsRoute _fromState(GoRouterState state) =>
      ProductDetailsRoute(
        id: state.pathParameters['id']!,
      );

  ProductDetailsRoute get _self => this as ProductDetailsRoute;

  @override
  String get location => GoRouteData.$location(
        '/details/${Uri.encodeComponent(_self.id)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
