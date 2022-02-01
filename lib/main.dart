import 'package:e1547/client/client.dart';
import 'package:e1547/follow/data/updater.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final Settings settings = await initializeSettings();
  final PackageInfo packageInfo = await initializePackageInfo();
  initializeHttpCache();
  runApp(
    AppConfigProvider(
      packageInfo: packageInfo,
      settings: settings,
      child: App(),
    ),
  );
}

class AppConfigProvider extends StatelessWidget {
  final PackageInfo packageInfo;
  final Settings settings;
  final Widget child;

  const AppConfigProvider({
    Key? key,
    required this.packageInfo,
    required this.settings,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: packageInfo),
        Provider.value(value: settings)
      ],
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with ProviderCreatorMixin {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NavigationController>(
          create: (context) =>
              NavigationController(destinations: topLevelDestinations),
        ),
        ProxyProvider2<Settings, AppInfo, Client>(
          update: guard2(
              create: (BuildContext context, value, value2) => Client(
                    settings: value,
                    appInfo: value2,
                  )),
        ),
        ProxyProvider2<Settings, Client, FollowUpdater>(
          update: guard2(
            create: (context, value, value2) => FollowUpdater(value, value2),
            dispose: (context, value) => value.dispose,
          ),
          dispose: (context, value) => value.dispose,
        ),
      ],
      builder: (context, child) {
        final navigationController = Provider.of<NavigationController>(context);
        return StartupActions(
          child: ExcludeSemantics(
            child: ValueListenableBuilder<AppTheme>(
              valueListenable: Provider.of<Settings>(context).theme,
              builder: (context, value, child) =>
                  AnnotatedRegion<SystemUiOverlayStyle>(
                value: defaultUIStyle(appThemeMap[value]!),
                child: MaterialApp(
                  title: Provider.of<AppInfo>(context).appName,
                  theme: appThemeMap[value],
                  routes: navigationController.routes,
                  navigatorObservers: [navigationController.routeObserver],
                  scrollBehavior: DesktopScrollBehaviour(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
