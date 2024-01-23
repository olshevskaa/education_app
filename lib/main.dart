import 'package:educational_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:educational_app/core/common/app/providers/user_provider.dart';
import 'package:educational_app/core/res/app_colors.dart';
import 'package:educational_app/core/res/fonts.dart';
import 'package:educational_app/core/services/injection_container.dart';
import 'package:educational_app/core/services/router.dart';
import 'package:educational_app/firebase_options.dart';
import 'package:educational_app/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => DashboardController()),
          ChangeNotifierProvider(create: (_) => CourseOfTheDayNotifier()),
        ],
        child: MaterialApp(
          title: 'Educational App',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: Fonts.poppins,
            appBarTheme: const AppBarTheme(
              color: Colors.transparent,
            ),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: AppColors.primaryColour,
            ),
          ),
          onGenerateRoute: generateRoute,
        ),
    );
  }
}
