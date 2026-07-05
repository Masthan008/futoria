import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class BranchSimulatorScreen extends StatefulWidget {
  const BranchSimulatorScreen({super.key});

  @override
  State<BranchSimulatorScreen> createState() => _BranchSimulatorScreenState();
}

class _BranchSimulatorScreenState extends State<BranchSimulatorScreen> {
  String _branchA = 'CSE';
  String _branchB = 'ECE';

  static const List<String> _branches = [
    'CSE',
    'ECE',
    'Electrical',
    'Mechanical',
    'Civil',
    'Information Technology (IT)',
    'Data Science & AI',
    'Robotics & Automation',
    'Chemical Engineering',
  ];

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final data = appProvider.branchComparison;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: Text(
              appProvider.translate('branch_analyzer'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Text(
            appProvider.translate('branch_analyzer_subtitle'),
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Pickers Card
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _branches.contains(_branchA) ? _branchA : 'CSE',
                        dropdownColor: AppTheme.surfaceColor,
                        style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: appProvider.translate('branch_a'),
                          border: const OutlineInputBorder(),
                        ),
                        items: _branches.map((b) {
                          return DropdownMenuItem(value: b, child: Text(b, overflow: TextOverflow.ellipsis));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _branchA = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _branches.contains(_branchB) ? _branchB : 'ECE',
                        dropdownColor: AppTheme.surfaceColor,
                        style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: appProvider.translate('branch_b'),
                          border: const OutlineInputBorder(),
                        ),
                        items: _branches.map((b) {
                          return DropdownMenuItem(value: b, child: Text(b, overflow: TextOverflow.ellipsis));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _branchB = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: appProvider.isLoading
                        ? null
                        : () {
                            if (_branchA == _branchB) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select two different branches to compare.'),
                                  backgroundColor: Colors.amber,
                                ),
                              );
                              return;
                            }
                            appProvider.loadBranchComparison(_branchA, _branchB);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      appProvider.translate('analyze_diff'), 
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    Text('Analyzing core syllabus differences & market reports...', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            )
          else if (data != null) ...[
            // Branch Headers Compare Card
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    gradientColors: [AppTheme.primaryColor.withOpacity(0.12), AppTheme.primaryColor.withOpacity(0.02)],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['branchAInfo']?['title'] ?? _branchA,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data['branchAInfo']?['tagline'] ?? '',
                          style: TextStyle(color: AppTheme.secondaryColor, fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    gradientColors: [AppTheme.accentColor.withOpacity(0.12), AppTheme.accentColor.withOpacity(0.02)],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['branchBInfo']?['title'] ?? _branchB,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data['branchBInfo']?['tagline'] ?? '',
                          style: TextStyle(color: AppTheme.accentColor, fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Verdict Callout
            if (data['summaryVerdict'] != null) ...[
              Text(
                appProvider.translate('summary_verdict'), 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GlassCard(
                padding: const EdgeInsets.all(16),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info, color: AppTheme.primaryColor, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        data['summaryVerdict'],
                        style: TextStyle(height: 1.5, fontSize: 13, color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Comparison Metrics Matrix Table
            if (data['comparisonMatrix'] != null) ...[
              Text(
                appProvider.translate('comparison_matrix'), 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                  },
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: AppTheme.borderOverlay, width: 0.5),
                  ),
                  children: [
                    // Table Header
                    TableRow(
                      decoration: BoxDecoration(
                        color: AppTheme.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
                      ),
                      children: [
                        const Padding(padding: EdgeInsets.all(12.0), child: Text('Metric', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5))),
                        Padding(padding: const EdgeInsets.all(12.0), child: Text(appProvider.translate('branch_a'), style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor, fontSize: 12.5))),
                        Padding(padding: const EdgeInsets.all(12.0), child: Text(appProvider.translate('branch_b'), style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentColor, fontSize: 12.5))),
                      ],
                    ),
                    // Table Rows
                    ...(data['comparisonMatrix'] as List).map((row) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(row['metric'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(row['valueA'] ?? '', style: TextStyle(color: AppTheme.textPrimary, fontSize: 11.5)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(row['valueB'] ?? '', style: TextStyle(color: AppTheme.textPrimary, fontSize: 11.5)),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Academic Journey comparison
            if (data['academicJourneyComparison'] != null) ...[
              Text(
                appProvider.translate('academic_journey_compare'), 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_branchA Curriculum', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor, fontSize: 13)),
                          const SizedBox(height: 10),
                          ...((data['academicJourneyComparison']['branchA'] ?? []) as List).map((step) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('• $step', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_branchB Curriculum', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentColor, fontSize: 13)),
                          const SizedBox(height: 10),
                          ...((data['academicJourneyComparison']['branchB'] ?? []) as List).map((step) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('• $step', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ]
          ],
        ],
      ),
    );
  }
}
