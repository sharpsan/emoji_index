
import 'package:auto_route/auto_route.dart';
import 'package:emoji_index/pages/emojis_page/emojis_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: EmojisPage, initial: true),
  ],
)
class AppRouter extends _$AppRouter{}
