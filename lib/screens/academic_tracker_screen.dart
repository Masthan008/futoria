import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AcademicTrackerScreen extends StatefulWidget {
  const AcademicTrackerScreen({super.key});

  @override
  State<AcademicTrackerScreen> createState() => _AcademicTrackerScreenState();
}

class _AcademicTrackerScreenState extends State<AcademicTrackerScreen> {
  String _universityType = 'JNTU Affiliated (R22)';
  String _semester = 'Semester 1';

  final List<String> _universities = [
    'JNTU Affiliated (R22)',
    'Autonomous Colleges (R24)',
    'Deemed Universities (e.g. GITAM)',
    'Osmania University (OU)'
  ];

  // Syllabus mock databases for realistic presentation
  final Map<String, List<Map<String, dynamic>>> _syllabusDB = {
    'CSE': [
      {
        'subject': 'Mathematics - I (Calculus & Linear Algebra)',
        'credits': 4,
        'chapters': ['Matrices', 'Eigenvalues & Eigenvectors', 'Mean Value Theorems', 'Multivariable Calculus'],
        'importance': 'High (Essential for ML and Neural Networks)',
        'guide': 'Focus heavily on Eigenvalues and Diagonalization. They form the core of PCA (Principal Component Analysis) in AI algorithms.',
        'questions': ['Find the Rank of a 3x3 Matrix.', 'State and prove Cayley-Hamilton Theorem.', 'Evaluate double integrals for area.']
      },
      {
        'subject': 'Programming for Problem Solving using C',
        'credits': 3,
        'chapters': ['Introduction to Components', 'Arrays & Strings', 'Functions & Pointers', 'Structures & Unions'],
        'importance': 'Extremely High (Coding Foundation)',
        'guide': 'Pointers and memory allocation are highly asked in interview screenings. Practice tracing code outputs.',
        'questions': ['Explain call-by-value vs call-by-reference.', 'Write a C program to reverse a linked list.', 'Difference between structure and union.']
      },
      {
        'subject': 'Engineering Chemistry',
        'credits': 3,
        'chapters': ['Electrochemistry', 'Corrosion & its Control', 'Spectroscopic Techniques', 'Water Technology'],
        'importance': 'Medium (General Science)',
        'guide': 'Understand water hardness calculation using EDTA method. Electrochemistry equations are key.',
        'questions': ['Explain the EDTA method to find water hardness.', 'Write notes on Galvanic corrosion.', 'Derive Nernst Equation.']
      }
    ],
    'ECE': [
      {
        'subject': 'Linear Alternating Circuits',
        'credits': 4,
        'chapters': ['Sinusoids & Phasors', 'Nodal & Mesh Analysis', 'Resonance', 'Two-Port Networks'],
        'importance': 'High (Core Circuitry)',
        'guide': 'Understand phasor analysis and resonance conditions. Master Kirchoff\'s laws for complex circuits.',
        'questions': ['Derive frequency for Series Resonance.', 'Find Z parameters of a T-network.', 'State Maximum Power Transfer Theorem.']
      },
      {
        'subject': 'Electronic Devices & Circuits',
        'credits': 3,
        'chapters': ['Diode characteristics', 'BJT Biasing', 'FET & MOSFET', 'Special purpose diodes'],
        'importance': 'Extremely High (Semiconductor base)',
        'guide': 'MOSFET operation is the single most important topic for VLSI careers. Draw clean circuit diagrams.',
        'questions': ['Explain working of P-N Junction Diode.', 'Compare BJT, JFET, and MOSFET.', 'Draw and explain a Full-Wave Rectifier.']
      }
    ]
  };

  void _showSubjectDetail(BuildContext context, Map<String, dynamic> subject) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subject['subject'] ?? '',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                    ),
                    Chip(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                      label: Text('${subject['credits']} Credits', style: TextStyle(color: AppTheme.primaryColor, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Importance: ${subject['importance']}',
                  style: TextStyle(color: AppTheme.accentColor, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Divider(color: AppTheme.borderOverlay, height: 24),
                const Text('Syllabus Chapters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                ...((subject['chapters'] as List? ?? []).map((ch) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.secondaryColor, size: 12),
                        const SizedBox(width: 8),
                        Text(ch as String, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5)),
                      ],
                    ),
                  );
                })),
                Divider(color: AppTheme.borderOverlay, height: 24),
                Text('AI Exam Preparation Guide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.warningColor)),
                const SizedBox(height: 8),
                Text(
                  subject['guide'] ?? '',
                  style: TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Text('Most Frequently Asked Questions (Previous Papers)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 8),
                ...((subject['questions'] as List? ?? []).map((q) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q.', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12.5)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(q as String, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5)),
                        ),
                      ],
                    ),
                  );
                })),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final branch = appProvider.profile.branch;

    final currentYear = appProvider.profile.currentYear;
    final List<String> semesters;
    if (currentYear == '2nd Year') {
      semesters = ['Semester 3', 'Semester 4'];
    } else if (currentYear == '3rd Year') {
      semesters = ['Semester 5', 'Semester 6'];
    } else if (currentYear == '4th Year' && (appProvider.profile.courseLevel.isEmpty || appProvider.profile.courseLevel == 'B.Tech')) {
      semesters = ['Semester 7', 'Semester 8'];
    } else {
      semesters = ['Semester 1', 'Semester 2'];
    }

    if (!semesters.contains(_semester)) {
      _semester = semesters.isNotEmpty ? semesters.first : 'Semester 1';
    }

    // Filter syllabus based on student's branch (fall back to CSE if branch not in DB)
    final subjects = _syllabusDB[branch.toUpperCase()] ?? _syllabusDB['CSE']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: Text(
              appProvider.translate('academic_regulation_tracker'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Text(
            appProvider.translate('academic_regulation_subtitle'),
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Filters Card
          GlassCard(
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _universities.contains(_universityType) ? _universityType : _universities.first,
                    dropdownColor: AppTheme.surfaceColor,
                    style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'University / Regulation Schema',
                      labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                    ),
                    items: _universities.map((uni) {
                      return DropdownMenuItem(value: uni, child: Text(uni, style: const TextStyle(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _universityType = val;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: semesters.contains(_semester) ? _semester : semesters.first,
                    dropdownColor: AppTheme.surfaceColor,
                    style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                    ),
                    items: semesters.map((sem) {
                      return DropdownMenuItem(value: sem, child: Text(sem, style: const TextStyle(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _semester = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Syllabus List
          Text(
            'Syllabus & Course Details - $branch ($_universityType)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            itemBuilder: (context, i) {
              final sub = subjects[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sub['subject'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text('${sub['credits']} Credits', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                const SizedBox(width: 12),
                                Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.textMuted)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    sub['importance'] ?? '',
                                    style: TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => _showSubjectDetail(context, sub),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor, width: 0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          appProvider.translate('view_guide'), 
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Academic Resource Downloads Panel
          Text(
            appProvider.translate('resources_downloads'), 
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildResourceCard(
                  context,
                  title: appProvider.translate('question_papers'),
                  desc: 'All mid-term & end-term papers.',
                  icon: Icons.assignment,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildResourceCard(
                  context,
                  title: appProvider.translate('lab_manuals'),
                  desc: 'Structured execution manuals.',
                  icon: Icons.code,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, {required String title, required String desc, required IconData icon, required Color color}) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PDF / ZIP files', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              Icon(Icons.download, size: 11, color: color),
            ],
          )
        ],
      ),
    );
  }
}
