import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class CareerSimulatorScreen extends StatefulWidget {
  const CareerSimulatorScreen({super.key});

  @override
  State<CareerSimulatorScreen> createState() => _CareerSimulatorScreenState();
}

class _CareerSimulatorScreenState extends State<CareerSimulatorScreen> {
  final TextEditingController _careerController = TextEditingController(text: 'AI Engineer');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.careerSimulation == null) {
        appProvider.loadCareerSimulation(_careerController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final data = appProvider.careerSimulation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: Text(
              appProvider.translate('career_simulator_title'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Text(
            appProvider.translate('career_simulator_subtitle'),
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Simulation Config Input
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _careerController,
                        style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Enter Target Career Path (e.g. AI Engineer, Mechanical Design)',
                          labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.borderOverlay),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: appProvider.isLoading
                          ? null
                          : () {
                              appProvider.loadCareerSimulation(_careerController.text);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_circle_fill, size: 14),
                      label: Text(
                        appProvider.translate('simulate'), 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  appProvider.translate('quick_suggestions'), 
                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    'AI Engineer',
                    'VLSI Chip Designer',
                    'Mechanical Design Engineer',
                    'Structural Civil Engineer',
                    'Embedded IoT Specialist',
                  ].map((role) {
                    return ActionChip(
                      label: Text(role, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.08),
                      side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.2)),
                      onPressed: () {
                        _careerController.text = role;
                        appProvider.loadCareerSimulation(role);
                      },
                    );
                  }).toList(),
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
                    Text('AI is formulating your reality simulation roadmap...', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            )
          else if (data != null) ...[
            // Main Simulation Insights
            Text(
              data['title'] ?? 'Simulation Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              data['description'] ?? '',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5),
            ),
            const SizedBox(height: 24),

            // Responsive Layout (Roadmap + Details)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                
                final roadmapWidget = GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.alt_route, color: AppTheme.primaryColor, size: 16),
                          const SizedBox(width: 10),
                          Text(
                            appProvider.translate('learning_roadmap'), 
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (data['roadmap'] != null)
                        ...(data['roadmap'] as List).map((node) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.15),
                                      child: Text(
                                        (node['year'] as String).replaceAll('Year ', ''),
                                        style: TextStyle(color: AppTheme.secondaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 60,
                                      color: AppTheme.borderOverlay,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        node['focus'] ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                      ),
                                      const SizedBox(height: 6),
                                      if (node['milestones'] != null)
                                        ...(node['milestones'] as List).map((milestone) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 4.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle, size: 8, color: AppTheme.accentColor),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    milestone as String,
                                                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                );

                final detailsWidget = Column(
                  children: [
                    // Work Culture
                    if (data['workCulture'] != null)
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.business, color: AppTheme.secondaryColor, size: 16),
                                const SizedBox(width: 10),
                                Text(
                                  appProvider.translate('work_culture'), 
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildCultureRow('Team Structure', data['workCulture']['teamStructure'] ?? ''),
                            _buildCultureRow('Shift Schedule', data['workCulture']['workingHours'] ?? ''),
                            _buildCultureRow('Remote Options', data['workCulture']['remotePossibility'] ?? ''),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Day in a life
                    if (data['dayInLife'] != null)
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: AppTheme.accentColor, size: 16),
                                const SizedBox(width: 10),
                                Text(
                                  appProvider.translate('daily_activities'), 
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...(data['dayInLife'] as List).map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  children: [
                                    Text(
                                      item['time'] ?? '',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor, fontSize: 12),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item['activity'] ?? '',
                                        style: TextStyle(color: AppTheme.textPrimary, fontSize: 12.5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                  ],
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: roadmapWidget),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: detailsWidget),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      roadmapWidget,
                      const SizedBox(height: 16),
                      detailsWidget,
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24),

            // Salary Growth Chart Container
            if (data['salaryGrowth'] != null) ...[
              Text(
                appProvider.translate('salary_growth'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 220,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (_) => AppTheme.surfaceColor,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final list = data['salaryGrowth'] as List;
                                  final idx = spot.x.toInt();
                                  final pos = idx >= 0 && idx < list.length ? list[idx]['position'] : '';
                                  return LineTooltipItem(
                                    '$pos\n${spot.y.toStringAsFixed(1)} LPA',
                                    TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(color: AppTheme.borderOverlay.withOpacity(0.4), strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final list = data['salaryGrowth'] as List;
                                  int index = value.toInt();
                                  if (index >= 0 && index < list.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        list[index]['yearsOfExp'] ?? '',
                                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: (data['salaryGrowth'] as List).asMap().entries.map((entry) {
                                double salary = 5.0; // default minimum
                                final match = RegExp(r'(\d+)').firstMatch(entry.value['avgSalary'] ?? '');
                                if (match != null) {
                                  salary = double.parse(match.group(0)!);
                                }
                                return FlSpot(entry.key.toDouble(), salary);
                              }).toList(),
                              isCurved: true,
                              gradient: AppTheme.primaryGradient,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: AppTheme.primaryColor,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor.withOpacity(0.3),
                                    AppTheme.primaryColor.withOpacity(0.01),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Legend
                    ...(data['salaryGrowth'] as List).map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry['position'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                            ),
                            Text(
                              entry['avgSalary'] ?? '',
                              style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Career Challenges
            if (data['challenges'] != null) ...[
              Text(
                appProvider.translate('challenges'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: (data['challenges'] as List).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning, color: AppTheme.warningColor, size: 13),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item as String,
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ]
        ],
      ),
    );
  }

  Widget _buildCultureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}
