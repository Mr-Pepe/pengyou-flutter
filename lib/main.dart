import 'package:flutter/material.dart';
import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/repositories/strokeOrderRepoitory.dart';
import 'package:pengyou/ui/homeView.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/values/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = AppPreferences();

  await preferences.init();

  runApp(PengyouApp(preferences));
}

class PengyouApp extends StatelessWidget {
  PengyouApp(this.preferences);

  final AppPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Independent services that do not rely on any other service
        Provider<DBProvider>(
          create: (_) => DBProvider.db,
        ),

        ChangeNotifierProvider<AppPreferences>(
          create: (_) => preferences,
        ),

        // Dependent services that rely on other services
        ProxyProvider<DBProvider, EntryRepository>(
          update: (context, dbProvider, entryRepository) =>
              EntryRepository(db: dbProvider),
        ),

        ProxyProvider<DBProvider, StrokeOrderRepository>(
          update: (context, dbProvider, strokeOrderRepository) =>
              StrokeOrderRepository(db: dbProvider),
        ),
      ],
      child: Consumer<AppPreferences>(builder: (context, prefs, child) {
        return MaterialApp(
          title: AppStrings.applicationName,
          theme: AppTheme(isDark: prefs.themeIsDark).themeData,
          darkTheme: AppTheme(isDark: true).themeData,
          home: HomeView(),
        );
      }),
    );
  }
}
