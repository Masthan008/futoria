import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final List<Map<String, dynamic>> slides = [
      {
        'icon': Icons.smart_toy,
        'tag': 'POWERED BY GROQ AI',
        'title': appProvider.translate('ai_mentor'),
        'description': 'Real-time academic counselor for CSE, ECE, Electrical, Civil & Mechanical. Discover your true interest before choosing your college branch.',
        'bgGradient': [const Color(0xFFE6F4EA), const Color(0xFFF9FAFB)],
      },
      {
        'icon': Icons.electric_bolt,
        'tag': 'REALITY SIMULATOR',
        'title': appProvider.translate('career_simulator'),
        'description': 'Simulate day-in-the-life tasks, explore 10-year Indian LPA salary progression models, and experience actual workplaces virtually.',
        'bgGradient': [const Color(0xFFD1E7DD), const Color(0xFFF9FAFB)],
      },
      {
        'icon': Icons.event_available,
        'tag': 'SEMESTER PLANNER',
        'title': appProvider.translate('semester_planner'),
        'description': 'Semester-by-semester roadmaps tailored for your branch. Track certifications, DSA problems, and summer industrial internships.',
        'bgGradient': [const Color(0xFFE2F0D9), const Color(0xFFF9FAFB)],
      },
      {
        'icon': Icons.play_circle_fill,
        'tag': 'INSTANT PLAYBACK',
        'title': appProvider.translate('learning_hub'),
        'description': 'Ask the AI Mentor about any course (Python, VLSI, EV, Structural) and instantly play verified video tutorials directly from YouTube.',
        'bgGradient': [const Color(0xFFD8F3DC), const Color(0xFFF9FAFB)],
      },
      {
        'icon': Icons.rocket_launch,
        'tag': 'GET STARTED',
        'title': 'Build Your Engineering Future',
        'description': 'Join thousands of intermediate and engineering students making informed career choices backed by real-time intelligence.',
        'bgGradient': [const Color(0xFFC8E6C9), const Color(0xFFF9FAFB)],
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: PageView.builder(
        controller: _pageController,
        itemCount: slides.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, i) {
          final slide = slides[i];
          final gradientColors = [
            AppTheme.isDarkMode 
                ? (i == 0 
                    ? const Color(0xFF022C22) 
                    : (i == 1 
                        ? const Color(0xFF064E3B) 
                        : (i == 2 
                            ? const Color(0xFF14532D) 
                            : const Color(0xFF0F172A))))
                : (slide['bgGradient'] as List<Color>)[0],
            AppTheme.backgroundColor,
          ];

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Header Bar (Logo and Skip button)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 28,
                                height: 28,
                                fit: BoxFit.cover,
                                 errorBuilder: (_, __, ___) => Icon(Icons.rocket_launch, color: AppTheme.primaryColor, size: 22),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              appProvider.translate('app_title'),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary),
                            ),
                          ],
                        ),
                        if (_currentPage < slides.length - 1)
                          TextButton(
                            onPressed: () {
                              _pageController.animateToPage(
                                slides.length - 1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              appProvider.translate('skip'),
                              style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),

                    // Category Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        slide['tag'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Animated Icon Frame with Scale animation
                    AnimatedScale(
                      scale: _currentPage == i ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.surfaceColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(AppTheme.isDarkMode ? 0.08 : 0.18),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          slide['icon'] as IconData,
                          size: 72,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Slidable Title
                    Text(
                      slide['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Description text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        slide['description'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(slides.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentPage == index ? AppTheme.primaryColor : AppTheme.textMuted.withOpacity(0.4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),

                    // Control Buttons (Next / Get Started)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == slides.length - 1) {
                            appProvider.completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _currentPage == slides.length - 1 
                              ? appProvider.translate('next') 
                              : appProvider.translate('next'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
