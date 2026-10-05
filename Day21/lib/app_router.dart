import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/dio_screen.dart';
import 'screens/freezed_screen.dart';
import 'screens/getx_screen.dart';
import 'screens/hive_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/router_screen.dart';
import 'screens/utilities_screen.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<GetXRoute>(
      path: 'getx',
    ),
    TypedGoRoute<FreezedRoute>(
      path: 'freezed',
    ),
    TypedGoRoute<DioRoute>(
      path: 'dio',
    ),
    TypedGoRoute<HiveRoute>(
      path: 'hive',
    ),
    TypedGoRoute<UtilitiesRoute>(
      path: 'utilities',
    ),
    TypedGoRoute<RouterExampleRoute>(
      path: 'router',
    ),
    TypedGoRoute<ProductDetailsRoute>(
      path: 'product/:id',
    ),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return const HomeScreen();
  }
}

class GetXRoute extends GoRouteData with $GetXRoute {
  const GetXRoute();

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return const GetXScreen();
  }
}

class FreezedRoute extends GoRouteData with $FreezedRoute {
  const FreezedRoute();

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return const FreezedScreen();
  }
}

class DioRoute extends GoRouteData with $DioRoute {
  const DioRoute();

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return const DioScreen();
  }
}

class HiveRoute extends GoRouteData with $HiveRoute {
  const HiveRoute();

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return const HiveScreen();
  }
}

class UtilitiesRoute extends GoRouteData with $UtilitiesRoute {
  const UtilitiesRoute();

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return const UtilitiesScreen();
  }
}

class RouterExampleRoute extends GoRouteData
    with $RouterExampleRoute {
  const RouterExampleRoute();

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return const RouterScreen();
  }
}

class ProductDetailsRoute extends GoRouteData
    with $ProductDetailsRoute {
  const ProductDetailsRoute({
    required this.id,
  });

  final String id;

  @override
  Widget build(
      BuildContext context,
      GoRouterState state,
      ) {
    return ProductDetailsScreen(id: id);
  }
}

final GoRouter appRouter = GoRouter(
  routes: $appRoutes,
);