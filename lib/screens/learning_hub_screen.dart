import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _launchVideo(String videoId) async {
    final youtubeBrowserUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    
    try {
      if (await canLaunchUrl(youtubeBrowserUrl)) {
        await launchUrl(youtubeBrowserUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $youtubeBrowserUrl';
      }
    } catch (e) {
      debugPrint('URL launch failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: Text(
              appProvider.translate('smart_learning_hub'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Text(
            appProvider.translate('learning_hub_subtitle'),
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Search Card
          GlassCard(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search for courses (e.g. Flutter, Digital Circuits, Calculus)',
                      hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                    ),
                    onSubmitted: (val) async {
                      if (val.trim().isNotEmpty) {
                        appProvider.updateProfile(appProvider.profile.copyWith(targetRole: val.trim()));
                        _searchController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.search, size: 16, color: AppTheme.primaryColor),
                  onPressed: () {
                    final val = _searchController.text;
                    if (val.trim().isNotEmpty) {
                      appProvider.updateProfile(appProvider.profile.copyWith(targetRole: val.trim()));
                      _searchController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Video Recommendations list
          Text(
            appProvider.translate('curated_playlists'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: appProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                : appProvider.youtubeRecommendations.isEmpty
                    ? Center(child: Text('No recommendations found. Try a different topic.', style: TextStyle(color: AppTheme.textSecondary)))
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.45,
                        ),
                        itemCount: appProvider.youtubeRecommendations.length,
                        itemBuilder: (context, i) {
                          final video = appProvider.youtubeRecommendations[i];
                          return Card(
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: AppTheme.borderOverlay, width: 0.5),
                            ),
                            color: AppTheme.surfaceColor,
                            child: InkWell(
                              onTap: () => _launchVideo(video.id),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Thumbnail
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          video.thumbnailUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, _, __) {
                                            return Container(
                                              color: const Color(0xFFF3F4F6),
                                              child: Center(
                                                child: Icon(Icons.video_library, color: AppTheme.errorColor, size: 40),
                                              ),
                                            );
                                          },
                                        ),
                                        // Play Overlay button
                                        Container(
                                          color: Colors.black.withOpacity(0.3),
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: AppTheme.errorColor,
                                              child: const Icon(Icons.play_arrow, size: 12, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        // Duration
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              video.duration,
                                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Video Meta Details
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            video.title,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                video.channelTitle,
                                                style: TextStyle(color: AppTheme.secondaryColor, fontSize: 11, fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                video.viewCount,
                                                style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
