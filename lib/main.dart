import "package:aim_test/res/colors.dart";
import "package:aim_test/res/dimens.dart";
import "package:flutter/material.dart";
import "package:easy_localization/easy_localization.dart";
import "package:responsive_framework/responsive_framework.dart";
import "ui/leaderboard_page.dart";

final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale("en"), Locale("id")],
      path: "assets/string",
      fallbackLocale: const Locale("id"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ayo Indonesia Maju",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      scaffoldMessengerKey: messengerKey,
      locale: context.locale,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: "4K"),
        ],
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: ColorResources.primary,
        scaffoldBackgroundColor: ColorResources.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        disabledColor: ColorResources.disable,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorResources.primary,
          iconTheme: IconThemeData(color: ColorResources.textInverse),
          actionsIconTheme: IconThemeData(color: ColorResources.textInverse),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: Dimens.fontLarge,
            fontFamily: "SF-Pro-Bold",
            color: ColorResources.textInverse,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ColorResources.primaryDark,
          foregroundColor: ColorResources.textInverse,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: ColorResources.background,
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontSize: Dimens.fontSmall, fontFamily: "SF-Pro", color: ColorResources.text),
          bodyMedium: TextStyle(fontSize: Dimens.fontDefault, fontFamily: "SF-Pro", color: ColorResources.text),
          bodyLarge: TextStyle(fontSize: Dimens.fontLarge, fontFamily: "SF-Pro-Light", color: ColorResources.text),
          headlineSmall:
              TextStyle(fontSize: Dimens.headlineSmall, fontFamily: "SF-Pro-Bold", color: ColorResources.text),
          headlineMedium:
              TextStyle(fontSize: Dimens.headlineMedium, fontFamily: "SF-Pro-Bold", color: ColorResources.text),
          headlineLarge:
              TextStyle(fontSize: Dimens.headlineLarge, fontFamily: "SF-Pro-Bold", color: ColorResources.text),
          labelMedium: TextStyle(fontSize: Dimens.fontDefault, fontFamily: "SF-Pro", color: ColorResources.text),
          labelLarge: TextStyle(fontSize: Dimens.fontDefault, fontFamily: "SF-Pro", color: ColorResources.text),
        ),
        popupMenuTheme: const PopupMenuThemeData(color: ColorResources.background),
        fontFamily: "SF-Pro",
        dialogTheme: const DialogThemeData(
          backgroundColor: ColorResources.background,
          surfaceTintColor: Colors.transparent,
        ),
        iconTheme: const IconThemeData(color: ColorResources.icon),
        listTileTheme: const ListTileThemeData(
          dense: true,
          contentPadding: EdgeInsets.zero,
          iconColor: ColorResources.icon,
          textColor: ColorResources.text,
          titleTextStyle: TextStyle(fontSize: Dimens.fontDefault, fontFamily: "SF-Pro"),
          subtitleTextStyle: TextStyle(fontSize: Dimens.fontSmall, fontFamily: "SF-Pro"),
          leadingAndTrailingTextStyle: TextStyle(fontSize: Dimens.fontDefault, fontFamily: "SF-Pro"),
        ),
      ),
      home: const LeaderboardPage(),
    );
  }
}
