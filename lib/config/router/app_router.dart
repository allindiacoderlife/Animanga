import 'package:go_router/go_router.dart';
import 'package:animanga/config/router/app_routes.dart';
import 'package:animanga/features/home/presentation/home_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.home,
        builder: (context, state) => HomePage(),
      ),
    ],
  );
}
