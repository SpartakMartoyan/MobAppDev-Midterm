import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'bloc/homework_bloc.dart';
import 'repository/homework_repository.dart';
import 'pages/home_page.dart';
import 'pages/add_homework_page.dart';

class SettingsProvider extends ChangeNotifier {
  bool _dark = false;
  bool get dark => _dark;

  void toggleTheme() {
    _dark = !_dark;
    notifyListeners();
  }
}

void main() {
  final repository = HomeworkRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: RepositoryProvider.value(
        value: repository,
        child: BlocProvider(
          create: (_) => HomeworkBloc(repository: repository),
          child: const MyApp(),
        ),
      ),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _routerDelegate = HomeworkRouterDelegate();
  final _routeParser = HomeworkRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp.router(
          title: 'Homework Tracker',
          theme: ThemeData(primarySwatch: Colors.indigo),
          darkTheme: ThemeData.dark(),
          themeMode: settings.dark ? ThemeMode.dark : ThemeMode.light,
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeParser,
        );
      },
    );
  }
}


enum HomeworkPageConfig { home, add }


class HomeworkRouteInformationParser extends RouteInformationParser<HomeworkPageConfig> {
  @override
  Future<HomeworkPageConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '/');
    if (uri.pathSegments.isEmpty) return HomeworkPageConfig.home;
    if (uri.pathSegments.first == 'add') return HomeworkPageConfig.add;
    return HomeworkPageConfig.home;
  }

  @override
  RouteInformation? restoreRouteInformation(HomeworkPageConfig configuration) {
    switch (configuration) {
      case HomeworkPageConfig.home:
        return const RouteInformation(location: '/');
      case HomeworkPageConfig.add:
        return const RouteInformation(location: '/add');
    }
  }
}


class HomeworkRouterDelegate extends RouterDelegate<HomeworkPageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<HomeworkPageConfig> {
  HomeworkPageConfig _current = HomeworkPageConfig.home;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  HomeworkPageConfig get currentConfiguration => _current;

  void _goTo(HomeworkPageConfig page) {
    _current = page;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('HomePage'),
          child: HomePage(onAddPressed: () => _goTo(HomeworkPageConfig.add)),
        ),
        if (_current == HomeworkPageConfig.add)
          MaterialPage(
            key: const ValueKey('AddHomeworkPage'),
            child: AddHomeworkPage(onSaveComplete: () => _goTo(HomeworkPageConfig.home)),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        _current = HomeworkPageConfig.home;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(HomeworkPageConfig configuration) async {
    _current = configuration;
  }
}
