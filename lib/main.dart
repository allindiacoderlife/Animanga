import 'package:animanga/config/router/app_router.dart';
import 'package:animanga/core/utils/size_config.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    // const MainApp() //! For production
    DevicePreview(
      enabled: !kReleaseMode, //! Disable in production
      builder: (context) => const MainApp(), //! For Development
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizeConfiguration(
      builder: (context) {
        return MaterialApp.router(
          title: "Animanga",
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
