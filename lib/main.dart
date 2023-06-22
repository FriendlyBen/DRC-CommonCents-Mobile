import 'package:commoncents/components/appbar.dart';
import 'package:commoncents/components/chart.dart';
import 'package:commoncents/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:commoncents/cubit/navbar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:commoncents/pages/homepage.dart';
import 'package:commoncents/pages/newspage.dart';
import 'package:commoncents/pages/simulationpage.dart';
import 'package:commoncents/pages/forumpage.dart';
import 'package:commoncents/pages/profilepage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primaryColor: const Color(0xFF3366FF),
      primaryColorLight: const Color(0xFF6699FF),
      primaryColorDark: const Color(0xFF0033FF),
      scaffoldBackgroundColor: Colors.white,
      textTheme:
          GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).copyWith(
        // Set the font for headings
        displayLarge: const TextStyle(
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
        // Set the font for small text in buttons
        displaySmall: const TextStyle(
          fontFamily: 'Raleway',
          fontSize: 12,
          color: Colors.black,
        ),
        // Set the font for numbers
        bodyMedium : const TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );

    return MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavBarCubit>(
            create: (context) => BottomNavBarCubit(),
          ),
        ],
        child: MaterialApp(
          theme: theme,
          home: BlocBuilder<BottomNavBarCubit, int>(
            builder: (context, selectedIndex) {
              List<String> barTitle = [
                "CommonCents",
                "Trading News",
                "Trading Simulation",
                "Forum",
                "User Profile"
              ];
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  title: barTitle[selectedIndex],
                ),
                body: _getPage(selectedIndex),
                bottomNavigationBar: const BottomNavBar(),
              );
            },
          ),
        ));
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return NewsPage();
      case 2:
        return CandleStickChart();
      case 3:
        return const ForumPage();
      case 4:
        return const ProfilePage();
      default:
        return Container(color: Colors.red);
    }
  }
}
