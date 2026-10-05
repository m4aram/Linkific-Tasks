import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_router.dart';
import 'controllers/app_controller.dart';
import 'services/hive_service.dart';

final hiveService = HiveService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await hiveService.init();

  Get.put(
    AppController(),
    permanent: true,
  );

  runApp(const PackageExplorerApp());
}

class PackageExplorerApp extends StatelessWidget {
  const PackageExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Package Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
    );
  }
}