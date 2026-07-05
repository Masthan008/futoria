import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class GapAnalyzerScreen extends StatefulWidget {
  const GapAnalyzerScreen({super.key});

  @override
  State<GapAnalyzerScreen> createState() => _GapAnalyzerScreenState();
}

class _GapAnalyzerScreenState extends State<GapAnalyzerScreen> {
  final TextEditingController _skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.skillGapAnalysis == null) {
        appProvider.loadSkillGapAnalysis();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final data = appProvider.skillGapAnalysis;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: Text(
              appProvider.translate('skill_gap'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Text(
            'Measure your current skills against industry expectations and formulate a transition path.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Skill Input & Checklist Panel
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your Current Skill Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Chip(
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.15),
                      label: Text('Goal: ${appProvider.profile.targetRole}', style: TextStyle(color: AppTheme.secondaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Add Skill Field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _skillController,
                        style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Add a skill (e.g. Java, Git, React)',
                          hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                        ),
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            appProvider.addSkill(val.trim());
                            _skillController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.add, size: 16, color: AppTheme.primaryColor),
                      onPressed: () {
                        final val = _skillController.text;
                        if (val.trim().isNotEmpty) {
                          appProvider.addSkill(val.trim());
                          _skillController.clear();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Skill Chips List
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: appProvider.profile.currentSkills.map((skill) {
                    return InputChip(
                      backgroundColor: const Color(0xFFE5E7EB),
                      label: Text(skill, style: TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
                      deleteIconColor: AppTheme.errorColor,
                      side: BorderSide(color: AppTheme.borderOverlay, width: 0.5),
                      onDeleted: () {
                        appProvider.removeSkill(skill);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Run Analysis Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: appProvider.isLoading
                        ? null
                        : () {
                            appProvider.loadSkillGapAnalysis();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.query_stats, size: 14),
                    label: const Text('Analyze Skill Gap', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (appProvider.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    const SizedBox(height: 16),
                    Text('Computing skill gap & customized study schedules...', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            )
          else if (data != null) ...[
            // Score indicator
            GlassCard(
              gradientColors: [AppTheme.accentColor.withOpacity(0.08), AppTheme.primaryColor.withOpacity(0.02)],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Role Readiness Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${data['statusPercent']}% Ready', style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (data['statusPercent'] as int).toDouble() / 100,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['advice'] ?? '',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Missing Skills
            if (data['missingSkills'] != null && (data['missingSkills'] as List).isNotEmpty) ...[
              const Text('Missing Core Capabilities to Develop', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: (data['missingSkills'] as List).map((skill) {
                  return Chip(
                    backgroundColor: AppTheme.warningColor.withOpacity(0.1),
                    side: BorderSide(color: AppTheme.warningColor, width: 0.5),
                    label: Text(
                      skill as String,
                      style: TextStyle(color: AppTheme.warningColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Actionable Learning Plan
            if (data['learningPlan'] != null) ...[
              const Text('Recommended Step-by-Step Transition Plan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (data['learningPlan'] as List).length,
                itemBuilder: (context, i) {
                  final module = data['learningPlan'][i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ExpansionTile(
                      collapsedBackgroundColor: AppTheme.surfaceColor,
                      backgroundColor: AppTheme.surfaceColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppTheme.borderOverlay, width: 0.5),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppTheme.borderOverlay, width: 0.5),
                      ),
                      title: Text(
                        module['moduleName'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppTheme.textPrimary),
                      ),
                      subtitle: Text(
                        'Duration: ${module['estimatedDuration']}',
                        style: TextStyle(color: AppTheme.secondaryColor, fontSize: 11),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Topics
                              Text('Topics to Learn:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.textPrimary)),
                              const SizedBox(height: 6),
                              ...((module['topicsCovered'] as List? ?? []).map((t) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.circle, size: 8, color: AppTheme.secondaryColor),
                                      const SizedBox(width: 8),
                                      Text(t as String, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                    ],
                                  ),
                                );
                              })),
                              Divider(color: AppTheme.borderOverlay, height: 20),

                              // Project Idea
                              Text('Practical Portfolio Project Idea:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.accentColor)),
                              const SizedBox(height: 6),
                              Text(
                                module['projectIdea'] ?? '',
                                style: TextStyle(color: AppTheme.textPrimary, fontSize: 12.5, height: 1.4),
                              ),
                              Divider(color: AppTheme.borderOverlay, height: 20),

                              // Practice Schedule
                              Text('Weekly Practice Schedule:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.warningColor)),
                              const SizedBox(height: 4),
                              Text(
                                module['practiceSchedule'] ?? '',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ],
        ],
      ),
    );
  }
}
