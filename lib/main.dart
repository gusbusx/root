import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!hasShownError) {
      hasShownError = true;

      Future.delayed(Duration(seconds: 5), () {
        hasShownError = false;
      });

      return CustomErrorWidget(errorDetails: details);
    }
    return SizedBox.shrink();
  };

  // Keep the installed mobile app portrait-only, but don't try to lock
  // orientation in a browser. This keeps Flutter Web compatible.
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'root',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // Keep text scaling predictable and force the web demo to use a
          // phone-sized viewport on wide desktop browsers.
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);

            final bool constrainWebDemo =
                kIsWeb && mediaQuery.size.width > 430;

            final double appWidth =
                constrainWebDemo ? 430.0 : mediaQuery.size.width;
            final double appHeight =
                kIsWeb && mediaQuery.size.height > 900
                    ? 900.0
                    : mediaQuery.size.height;

            final app = MediaQuery(
              data: mediaQuery.copyWith(
                size: Size(appWidth, appHeight),
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            );

            if (!constrainWebDemo) {
              return app;
            }

            return ColoredBox(
              color: const Color(0xFFF2F2F2),
              child: Center(
                child: SizedBox(
                  width: appWidth,
                  height: appHeight,
                  child: app,
                ),
              ),
            );
          },
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.initial,
        );
      },
    );
  }
}
