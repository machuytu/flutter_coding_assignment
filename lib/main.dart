import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/domain/usecases/get_home_data_usecase.dart';
import 'features/home/data/repositories/api_repository_impl.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'shared/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) {
            final apiRepository = ApiRepositoryImpl();
            final getHomeDataUseCase = GetHomeDataUseCase(apiRepository);
            return HomeBloc(getHomeDataUseCase: getHomeDataUseCase);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Coding Assignment',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        // Localization configuration
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
        ],

        home: const HomeScreen(),
      ),
    );
  }
}
