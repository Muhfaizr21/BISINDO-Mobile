import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/learn/presentation/bloc/learn_bloc.dart';
import 'features/navigation/pages/main_nav_page.dart';
import 'features/translate/presentation/bloc/translate_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize dependency injection
  sl.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TranslateBloc>(
          create: (_) => sl.createTranslateBloc(),
        ),
        BlocProvider<LearnBloc>(
          create: (_) => sl.createLearnBloc(),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => sl.createHistoryBloc(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavPage(),
      ),
    );
  }
}
