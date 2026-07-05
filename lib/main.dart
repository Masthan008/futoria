import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_questionnaire_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables (.env)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Could not load .env file: $e");
  }

  // Initialize Firebase using the generated options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider()..init(),
      child: const FuturePathApp(),
    ),
  );
}

class FuturePathApp extends StatelessWidget {
  const FuturePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    Widget homeWidget;
    if (appProvider.isLoading && !appProvider.initComplete) {
      // Show a splash/loading screen while initializing
      homeWidget = Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.rocket_launch, size: 56, color: Color(0xFF16A34A)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Futoria',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'AI-Powered Career & Academic Mentor',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Color(0xFF16A34A)),
            ],
          ),
        ),
      );
    } else if (!appProvider.isOnboarded) {
      homeWidget = const WelcomeScreen();
    } else if (appProvider.currentUser == null) {
      homeWidget = const LoginScreen();
    } else if (!appProvider.profile.questionnaireCompleted) {
      homeWidget = const OnboardingQuestionnaireScreen();
    } else {
      homeWidget = const DashboardScreen();
    }

    return MaterialApp(
      title: 'Futoria',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: homeWidget,
    );
  }
}
