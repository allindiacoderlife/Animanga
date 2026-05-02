import 'package:flutter/material.dart';
import 'package:animanga/features/manga/domain/models/manga_model.dart';
import 'package:go_router/go_router.dart';
import 'package:animanga/config/router/app_routes.dart';
import 'package:animanga/features/home/presentation/home_page.dart';
import 'package:animanga/features/manga/presentation/screens/search_screen.dart';
import 'package:animanga/features/manga/presentation/screens/manga_detail_screen.dart';
import 'package:animanga/features/home/widget/manga_list.dart';

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
      GoRoute(
        path: AppRoutes.search,
        name: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.mangaList,
        name: AppRoutes.mangaList,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MangaList(
            title: extra?['title'] ?? 'Trending Manga',
            initialManga: extra?['initialManga'] as List<MangaModel>?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.mangaDetail,
        name: AppRoutes.mangaDetail,
        pageBuilder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final extra = state.extra as Map<String, dynamic>?;
          final heroTag = extra?['heroTag'] as String?;
          final initialTitle = extra?['initialTitle'] as String?;
          final initialImageUrl = extra?['initialImageUrl'] as String?;

          return CustomTransitionPage(
            key: state.pageKey,
            child: MangaDetailScreen(
              mangaId: id,
              heroTag: heroTag,
              initialTitle: initialTitle,
              initialImageUrl: initialImageUrl,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                            reverseCurve: Curves.easeInCubic,
                          ),
                        ),
                    child: child,
                  );
                },
          );
        },
      ),
    ],
  );
}
