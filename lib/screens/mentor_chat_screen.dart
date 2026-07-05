import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class MentorChatScreen extends StatefulWidget {
  const MentorChatScreen({super.key});

  @override
  State<MentorChatScreen> createState() => _MentorChatScreenState();
}

class _MentorChatScreenState extends State<MentorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<TapGestureRecognizer> _gestureRecognizers = [];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    for (var recognizer in _gestureRecognizers) {
      recognizer.dispose();
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Could not launch URL $urlString: $e');
    }
  }

  Widget _buildFormattedMessageText(String text, bool isUser) {
    final RegExp linkRegExp = RegExp(
      r'\[([^\]]+)\]\((https?://[^\s\)]+)\)|(https?://[^\s\)]+)',
      caseSensitive: false,
    );

    final List<InlineSpan> spans = [];
    int start = 0;

    for (final match in linkRegExp.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(
            color: isUser ? Colors.white : AppTheme.textPrimary,
            fontSize: 13.5,
            height: 1.4,
          ),
        ));
      }

      final String label = match.group(1) ?? match.group(3) ?? 'Watch Tutorial';
      final String url = match.group(2) ?? match.group(3) ?? '';

      final recognizer = TapGestureRecognizer()..onTap = () => _launchUrl(url);
      _gestureRecognizers.add(recognizer);

      spans.add(
        TextSpan(
          text: ' 🔗 $label ',
          style: TextStyle(
            color: isUser 
                ? Colors.yellowAccent 
                : (AppTheme.isDarkMode ? AppTheme.accentColor : const Color(0xFF15803D)),
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            fontSize: 13.5,
            height: 1.4,
          ),
          recognizer: recognizer,
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(
          color: isUser ? Colors.white : AppTheme.textPrimary,
          fontSize: 13.5,
          height: 1.4,
        ),
      ));
    }

    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final onboardingChips = [
      {'label': '💻 Recommend C/Python Tutorials', 'val': 'Recommend C programming and Python tutorials with video links.'},
      {'label': '🔌 Electronics & VLSI Courses', 'val': 'Recommend VLSI, microcontrollers, and embedded systems course links.'},
      {'label': '⚙️ Mechanical CAD & Robotics', 'val': 'Recommend SolidWorks, CAD, and Robotics learning channels with links.'},
      {'label': '🏗️ Civil Engineering & CAD', 'val': 'Recommend Civil CAD, surveying, and structural design tutorials with links.'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Info with App Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.smart_toy, color: AppTheme.primaryColor, size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                            child: const Text(
                              'AI Career Mentor',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          Text(
                            'Real-time guidance for ${appProvider.profile.branch} (${appProvider.profile.subCourse})',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 18, color: AppTheme.textSecondary),
                onPressed: () {
                  appProvider.resetProfile();
                },
                tooltip: 'Reset Chat',
              )
            ],
          ),
          const SizedBox(height: 14),

          // Main Chat Area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderOverlay, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Chat Messages List
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: appProvider.mentorChatHistory.length,
                      itemBuilder: (context, index) {
                        final chat = appProvider.mentorChatHistory[index];
                        final isUser = chat['role'] == 'user';
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isUser) ...[
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: AppTheme.primaryColor.withOpacity(0.18),
                                    child: Icon(Icons.smart_toy, size: 13, color: AppTheme.primaryColor),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUser 
                                          ? AppTheme.primaryColor 
                                          : (AppTheme.isDarkMode ? const Color(0xFF334155) : const Color(0xFFF3F4F6)),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                                        bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                                      ),
                                      border: isUser 
                                          ? null 
                                          : Border.all(color: AppTheme.borderOverlay, width: 0.5),
                                    ),
                                    child: _buildFormattedMessageText(chat['text'] ?? '', isUser),
                                  ),
                                ),
                                if (isUser) ...[
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                                    child: Icon(Icons.person, size: 13, color: AppTheme.secondaryColor),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  if (appProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
                        ),
                      ),
                    ),

                  // Quick Suggestion Chips
                  if (appProvider.mentorChatHistory.length < 6)
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      color: AppTheme.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: onboardingChips.length,
                        itemBuilder: (context, i) {
                          final chip = onboardingChips[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                            child: ActionChip(
                              backgroundColor: AppTheme.isDarkMode ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                              label: Text(
                                chip['label']!,
                                style: TextStyle(fontSize: 11, color: AppTheme.textPrimary),
                              ),
                              side: BorderSide(color: AppTheme.borderOverlay, width: 0.5),
                              onPressed: () {
                                appProvider.sendMentorMessage(chip['val']!);
                                _scrollToBottom();
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  // Input Box Bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: AppTheme.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Ask mentor or request course links for any topic...',
                              hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              filled: true,
                              fillColor: AppTheme.isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFE5E7EB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                appProvider.sendMentorMessage(val);
                                _messageController.clear();
                                _scrollToBottom();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final val = _messageController.text;
                            if (val.trim().isNotEmpty) {
                              appProvider.sendMentorMessage(val);
                              _messageController.clear();
                              _scrollToBottom();
                            }
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.primaryColor,
                            child: const Icon(Icons.send, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
