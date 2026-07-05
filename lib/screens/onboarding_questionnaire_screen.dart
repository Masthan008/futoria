import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class OnboardingQuestionnaireScreen extends StatefulWidget {
  const OnboardingQuestionnaireScreen({super.key});

  @override
  State<OnboardingQuestionnaireScreen> createState() => _OnboardingQuestionnaireScreenState();
}

class _OnboardingQuestionnaireScreenState extends State<OnboardingQuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers & Form State
  final TextEditingController _nameController = TextEditingController();
  int _age = 18;
  String _interYear = '2024';
  String _selectedCourseLevel = 'B.Tech';
  String _selectedBranch = 'CSE';
  String _selectedSubCourse = 'Artificial Intelligence & ML';
  String _primaryInterest = 'Software Coding & Logic';
  String _careerGoal = 'High LPA Product Company Placement';

  double _codingScore = 4.0;
  double _electronicsScore = 3.0;
  double _machinesScore = 2.0;

  final List<String> _courseLevels = ['B.Tech', 'Polytechnic', 'Degree'];

  static const List<String> _btechBranches = [
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

  static const Map<String, List<String>> _btechSubCourses = {
    'CSE': ['Artificial Intelligence & ML', 'Data Science & Big Data', 'Cybersecurity', 'Cloud & DevOps', 'Full-Stack Software Engineering'],
    'ECE': ['VLSI & Chip Design', 'Embedded Systems & IoT', '5G Telecom & Signal Processing', 'Robotics & Automation'],
    'Electrical': ['Electric Vehicle Powertrains', 'Smart Grid & Renewable Energy', 'Power Electronics & Drives', 'Control & Automation'],
    'Mechanical': ['Automotive & EV Design', 'CAD/CAM & Robotics', 'Thermal & Energy Systems', 'Aerospace Engineering'],
    'Civil': ['Structural & Earthquake Engg', 'Construction Project Mgmt', 'Transportation & Highways', 'Environmental & Water Resources'],
    'Information Technology (IT)': ['Cloud Solutions & DevOps', 'Cybersecurity & Networks', 'Web & Mobile Systems', 'Enterprise Software'],
    'Data Science & AI': ['Machine Learning Engineering', 'Deep Learning & NLP', 'Big Data Analytics', 'Computer Vision'],
    'Robotics & Automation': ['Industrial Robotics', 'Autonomous Systems & Drones', 'Mechatronics & Control', 'Embedded ROS'],
    'Chemical Engineering': ['Petrochemical & Refining', 'Pharmaceutical & Process Design', 'Renewable Energy & Polymers', 'Process Automation'],
  };

  static const List<String> _polytechnicBranches = [
    'Mechanical Engg',
    'Civil Engg',
    'Electrical Engg',
    'Computer Engg',
    'Electronics Engg',
    'Automobile Engg',
    'Chemical Engg',
  ];

  static const Map<String, List<String>> _polytechnicSubCourses = {
    'Mechanical Engg': ['CAD Drafting', 'CNC Machining', 'Maintenance Engineering', 'HVAC Systems'],
    'Civil Engg': ['Surveying & Estimation', 'Concrete Technology', 'Site Supervision', 'Drafting & AutoCad'],
    'Electrical Engg': ['Electrical Installation', 'Motor Rewinding', 'Power Systems Maintenance', 'Electrical Safety'],
    'Computer Engg': ['Hardware & Networking', 'Web Development Basics', 'IT Support', 'Database Operations'],
    'Electronics Engg': ['Consumer Electronics Repair', 'PCB Design & Soldering', 'Microcontroller Programming', 'Instrumentation'],
    'Automobile Engg': ['Vehicle Diagnostics', 'Engine Tuning & Overhauling', 'EV Maintenance', 'Auto Body Repair'],
    'Chemical Engg': ['Process Control Operations', 'Plant Safety & Operations', 'Polymer Testing', 'Process Instrumentation'],
  };

  static const List<String> _degreeBranches = [
    'BCA',
    'BSc (Computer Science)',
    'BBA',
    'BCom',
    'BSc (Biotechnology)',
  ];

  static const Map<String, List<String>> _degreeSubCourses = {
    'BCA': ['Software Development', 'Web & Mobile Applications', 'Database Systems', 'Network Administration'],
    'BSc (Computer Science)': ['Data Science & Analytics', 'Computer Graphics & UI', 'Information Security', 'Software Engineering'],
    'BBA': ['Marketing & Management', 'Human Resource Mgmt', 'Finance & Entrepreneurship', 'Digital Marketing'],
    'BCom': ['Finance & Accounting', 'Taxation & Auditing', 'E-Commerce & Banking', 'Investment Portfolio'],
    'BSc (Biotechnology)': ['Genetics & Tissue Culture', 'Bioinformatics & Research', 'Clinical Research & Trials', 'Agricultural Biotech'],
  };

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    _nameController.text = appProvider.profile.displayName.isNotEmpty && appProvider.profile.displayName != 'Future Path Finder'
        ? appProvider.profile.displayName
        : '';
  }

  Future<void> _submitAssessment() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your student name')),
      );
      return;
    }

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.completeStudentOnboarding(
      name: _nameController.text.trim(),
      age: _age,
      interPassOutYear: _interYear,
      courseLevel: _selectedCourseLevel,
      branch: _selectedBranch,
      subCourse: _selectedSubCourse,
      primaryInterest: _primaryInterest,
      careerGoal: _careerGoal,
      codingScore: _codingScore,
      electronicsScore: _electronicsScore,
      machinesScore: _machinesScore,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final List<String> branchList = _selectedCourseLevel == 'B.Tech'
        ? _btechBranches
        : (_selectedCourseLevel == 'Polytechnic' ? _polytechnicBranches : _degreeBranches);

    final Map<String, List<String>> subCourseMap = _selectedCourseLevel == 'B.Tech'
        ? _btechSubCourses
        : (_selectedCourseLevel == 'Polytechnic' ? _polytechnicSubCourses : _degreeSubCourses);

    if (!branchList.contains(_selectedBranch)) {
      _selectedBranch = branchList.first;
    }

    final subCourseList = subCourseMap[_selectedBranch] ?? subCourseMap[branchList.first]!;
    if (!subCourseList.contains(_selectedSubCourse)) {
      _selectedSubCourse = subCourseList.first;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.school, color: AppTheme.primaryColor, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Student Career Assessment',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                ),
                                Text(
                                  'Step ${_currentStep + 1} of 3: Configure your ${_selectedCourseLevel == 'B.Tech' ? '4-year' : '3-year'} path',
                                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress Bar
                      LinearProgressIndicator(
                        value: (_currentStep + 1) / 3,
                        backgroundColor: AppTheme.borderOverlay,
                        color: AppTheme.primaryColor,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      const SizedBox(height: 24),

                      // Step 1: Personal Details
                      if (_currentStep == 0) ...[
                        const Text('Student Basic Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Full Student Name *',
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                            prefixIcon: Icon(Icons.person, size: 18, color: AppTheme.textSecondary),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _courseLevels.contains(_selectedCourseLevel) ? _selectedCourseLevel : 'B.Tech',
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceColor,
                          decoration: InputDecoration(
                            labelText: 'Course / Education Level *',
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                            prefixIcon: Icon(Icons.school, size: 18, color: AppTheme.primaryColor),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                          ),
                          items: _courseLevels.map((lvl) {
                            return DropdownMenuItem(value: lvl, child: Text(lvl));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedCourseLevel = val;
                                // Reset selected branch and subcourse to defaults of that course type
                                if (val == 'B.Tech') {
                                  _selectedBranch = 'CSE';
                                  _selectedSubCourse = 'Artificial Intelligence & ML';
                                } else if (val == 'Polytechnic') {
                                  _selectedBranch = 'Computer Engg';
                                  _selectedSubCourse = 'Hardware & Networking';
                                } else {
                                  _selectedBranch = 'BCA';
                                  _selectedSubCourse = 'Software Development';
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: List.generate(15, (i) => 15 + i).contains(_age) ? _age : 18,
                                isExpanded: true,
                                dropdownColor: AppTheme.surfaceColor,
                                decoration: InputDecoration(
                                  labelText: 'Age',
                                  labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                  border: const OutlineInputBorder(),
                                ),
                                items: List.generate(15, (i) => 15 + i).map((a) {
                                  return DropdownMenuItem(value: a, child: Text('$a years'));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _age = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: ['2022', '2023', '2024', '2025', '2026'].contains(_interYear) ? _interYear : '2024',
                                isExpanded: true,
                                dropdownColor: AppTheme.surfaceColor,
                                decoration: InputDecoration(
                                  labelText: 'Inter Pass Year',
                                  labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                  border: const OutlineInputBorder(),
                                ),
                                items: ['2022', '2023', '2024', '2025', '2026'].map((y) {
                                  return DropdownMenuItem(value: y, child: Text(y));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _interYear = val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Step 2: Course & Specialization
                      if (_currentStep == 1) ...[
                        Text(
                          _selectedCourseLevel == 'B.Tech'
                              ? 'Choose Your Engineering Branch & Sub-Course'
                              : 'Choose Your Stream & Specialization',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: branchList.contains(_selectedBranch) ? _selectedBranch : branchList.first,
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceColor,
                          decoration: InputDecoration(
                            labelText: _selectedCourseLevel == 'B.Tech' ? 'Main Branch / Department *' : 'Main Stream / Program *',
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                            prefixIcon: Icon(Icons.account_tree, size: 18, color: AppTheme.primaryColor),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                          ),
                          items: branchList.map((b) {
                            return DropdownMenuItem(value: b, child: Text(b, overflow: TextOverflow.ellipsis));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedBranch = val;
                                _selectedSubCourse = (subCourseMap[val] ?? ['General']).first;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: subCourseList.contains(_selectedSubCourse) ? _selectedSubCourse : subCourseList.first,
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceColor,
                          decoration: InputDecoration(
                            labelText: 'Sub-Course / Specialization *',
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                            prefixIcon: Icon(Icons.stars, size: 18, color: AppTheme.secondaryColor),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                          ),
                          items: subCourseList.map((sc) {
                            return DropdownMenuItem(value: sc, child: Text(sc, overflow: TextOverflow.ellipsis));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedSubCourse = val);
                          },
                        ),
                      ],

                      // Step 3: Assessment Preferences
                      if (_currentStep == 2) ...[
                        const Text('Career Goals & Interest Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _primaryInterest,
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceColor,
                          decoration: InputDecoration(
                            labelText: 'Primary Work Preference',
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            'Software Coding & Logic',
                            'Chips, Circuitry & Microcontrollers',
                            'Motors, Heavy Machines & Robotics',
                            'Infrastructure, Buildings & Surveying',
                            'Data Analytics, AI & Machine Learning',
                          ].map((pi) {
                            return DropdownMenuItem(value: pi, child: Text(pi, overflow: TextOverflow.ellipsis));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _primaryInterest = val);
                          },
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _careerGoal,
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceColor,
                          decoration: InputDecoration(
                            labelText: 'Target Career Goal',
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            'High LPA Product Company Placement',
                            'Core Hardware / Tech MNC',
                            'Government Sector / PSUs / GATE',
                            'Higher Education MS in US/Europe',
                            'Tech Entrepreneur / Startup Founder',
                          ].map((cg) {
                            return DropdownMenuItem(value: cg, child: Text(cg, overflow: TextOverflow.ellipsis));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _careerGoal = val);
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Coding Interest: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Slider(
                                value: _codingScore,
                                min: 1.0,
                                max: 5.0,
                                divisions: 4,
                                activeColor: AppTheme.primaryColor,
                                label: 'Level ${_codingScore.toInt()}',
                                onChanged: (val) => setState(() => _codingScore = val),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Navigation Buttons
                      Row(
                        children: [
                          if (_currentStep > 0) ...[
                            OutlinedButton.icon(
                              onPressed: appProvider.isLoading ? null : () => setState(() => _currentStep--),
                              icon: const Icon(Icons.arrow_back, size: 16),
                              label: const Text('Back'),
                            ),
                            const SizedBox(width: 12),
                          ],
                          
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: appProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_currentStep < 2) {
                                        setState(() => _currentStep++);
                                      } else {
                                        try {
                                          await _submitAssessment();
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error generating plan: $e')),
                                            );
                                          }
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: appProvider.isLoading 
                                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Icon(_currentStep == 2 ? Icons.rocket_launch : Icons.arrow_forward, size: 16),
                              label: Text(
                                appProvider.isLoading 
                                    ? 'Generating Plan...' 
                                    : (_currentStep == 2 ? 'Generate 4-Year Plan' : 'Next Step'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
