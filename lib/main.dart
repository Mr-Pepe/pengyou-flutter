import 'package:flutter/material.dart';
import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/ui/homeView.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/values/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(PengyouApp());

class PengyouApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme(isDark: false);

    return MultiProvider(
      providers: [
        // Independent services that do not rely on any other service
        Provider<DBProvider>(
          create: (_) => DBProvider.db,
        ),

        // Dependent services that rely on other services
        ProxyProvider<DBProvider, EntryRepository>(
          update: (context, dbProvider, entryRepository) =>
              EntryRepository(db: dbProvider),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.applicationName,
        theme: AppTheme(isDark: false).themeData,
        darkTheme: AppTheme(isDark: true).themeData,
        home: HomeView(),
      ),
    );
  }
}
