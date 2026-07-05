import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _subCourseController = TextEditingController();
  
  bool _isEditing = false;
  String _courseLevel = 'B.Tech';
  String _branch = 'CSE';
  String _year = '1st Year';
  String _interYear = '2024';

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
    _loadProfileData();
  }

  void _loadProfileData() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    _nameController.text = appProvider.profile.displayName;
    _ageController.text = appProvider.profile.age > 0 ? appProvider.profile.age.toString() : '18';
    _subCourseController.text = appProvider.profile.subCourse;
    
    final level = appProvider.profile.courseLevel.isNotEmpty ? appProvider.profile.courseLevel : 'B.Tech';
    final branchList = level == 'B.Tech'
        ? _btechBranches
        : (level == 'Polytechnic' ? _polytechnicBranches : _degreeBranches);

    String matchingBranch = branchList.isNotEmpty ? branchList.first : 'CSE';
    for (var b in branchList) {
      if (b.toLowerCase() == appProvider.profile.branch.toLowerCase() ||
          appProvider.profile.branch.toLowerCase().contains(b.toLowerCase())) {
        matchingBranch = b;
        break;
      }
    }

    setState(() {
      _courseLevel = level;
      _branch = matchingBranch;
      _year = appProvider.profile.currentYear.isNotEmpty ? appProvider.profile.currentYear : '1st Year';
      _interYear = appProvider.profile.interPassOutYear.isNotEmpty ? appProvider.profile.interPassOutYear : '2024';
    });
  }

  void _saveProfile() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final level = _courseLevel;
    final subCourseMap = level == 'B.Tech'
        ? _btechSubCourses
        : (level == 'Polytechnic' ? _polytechnicSubCourses : _degreeSubCourses);
    
    final updatedProfile = appProvider.profile.copyWith(
      displayName: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? appProvider.profile.age,
      interPassOutYear: _interYear,
      courseLevel: _courseLevel,
      branch: _branch,
      subCourse: _subCourseController.text.trim().isNotEmpty 
          ? _subCourseController.text.trim() 
          : (subCourseMap[_branch]?.first ?? 'General'),
      currentYear: _year,
    );

    await appProvider.updateProfile(updatedProfile);

    setState(() {
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appProvider.translate('save_changes')),
          backgroundColor: const Color(0xFF16A34A),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final List<String> branchList = _courseLevel == 'B.Tech'
        ? _btechBranches
        : (_courseLevel == 'Polytechnic' ? _polytechnicBranches : _degreeBranches);

    final Map<String, List<String>> subCourseMap = _courseLevel == 'B.Tech'
        ? _btechSubCourses
        : (_courseLevel == 'Polytechnic' ? _polytechnicSubCourses : _degreeSubCourses);

    if (!branchList.contains(_branch)) {
      _branch = branchList.isNotEmpty ? branchList.first : 'CSE';
    }

    final subCourseList = subCourseMap[_branch] ?? subCourseMap[branchList.first]!;
    if (!subCourseList.contains(_subCourseController.text)) {
      _subCourseController.text = subCourseList.isNotEmpty ? subCourseList.first : 'General';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: Text(
              appProvider.translate('settings_title'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Text(
            appProvider.translate('settings_subtitle'),
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // PREFERENCES CARD (Dark/White theme & Language dropdown)
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.palette, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        appProvider.translate('app_theme') + ' & ' + appProvider.translate('language'),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Theme Toggle switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          appProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          appProvider.translate('dark_mode'),
                          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: appProvider.isDarkMode,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (val) {
                        appProvider.setDarkMode(val);
                      },
                    ),
                  ],
                ),
                Divider(height: 24, color: AppTheme.borderOverlay),

                // Language Selection dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.language, color: AppTheme.primaryColor, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          appProvider.translate('language'),
                          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 140),
                          child: DropdownButtonFormField<String>(
                            value: ['en', 'hi', 'te', 'ta'].contains(appProvider.languageCode) ? appProvider.languageCode : 'en',
                            dropdownColor: AppTheme.surfaceColor,
                            style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'en', child: Text('English')),
                              DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                              DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
                              DropdownMenuItem(value: 'ta', child: Text('தமிழ்')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                appProvider.setLanguage(val);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About FuturePath AI Card
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 22),
              ),
              title: Text(
                appProvider.translate('about_app'),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              subtitle: Text(
                'Information, key features, and app details',
                style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
              ),
              trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildAboutDialog(context),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Student Profile Card (Static View or Edit Mode)
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.badge, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        appProvider.translate('student_profile'),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!_isEditing) ...[
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          _loadProfileData();
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.edit, size: 14),
                        label: Text(appProvider.translate('edit_profile'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // STATIC READ-ONLY VIEW
                if (!_isEditing) ...[
                  _buildProfileTile(
                    icon: Icons.person,
                    title: appProvider.translate('student_name'),
                    value: appProvider.profile.displayName.isNotEmpty 
                        ? appProvider.profile.displayName 
                        : 'Not Set',
                  ),
                  Divider(height: 20, color: AppTheme.borderOverlay),
                  _buildProfileTile(
                    icon: Icons.school,
                    title: appProvider.translate('course_level'),
                    value: appProvider.profile.courseLevel.isNotEmpty 
                        ? appProvider.profile.courseLevel 
                        : 'B.Tech',
                  ),
                  Divider(height: 20, color: AppTheme.borderOverlay),
                  _buildProfileTile(
                    icon: Icons.class_,
                    title: appProvider.translate('branch'),
                    value: appProvider.profile.branch.isNotEmpty 
                        ? appProvider.profile.branch 
                        : 'Not Set',
                  ),
                  Divider(height: 20, color: AppTheme.borderOverlay),
                  _buildProfileTile(
                    icon: Icons.auto_awesome,
                    title: appProvider.translate('sub_course'),
                    value: appProvider.profile.subCourse.isNotEmpty 
                        ? appProvider.profile.subCourse 
                        : 'General',
                  ),
                  Divider(height: 20, color: AppTheme.borderOverlay),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProfileTile(
                          icon: Icons.event,
                          title: appProvider.translate('inter_year'),
                          value: appProvider.profile.interPassOutYear.isNotEmpty 
                              ? appProvider.profile.interPassOutYear 
                              : '2024',
                        ),
                      ),
                      Expanded(
                        child: _buildProfileTile(
                          icon: Icons.cake,
                          title: appProvider.translate('age'),
                          value: appProvider.profile.age > 0 
                              ? '${appProvider.profile.age}' 
                              : '18',
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 20, color: AppTheme.borderOverlay),
                  _buildProfileTile(
                    icon: Icons.work_outline,
                    title: appProvider.translate('target_role'),
                    value: appProvider.profile.targetRole.isNotEmpty 
                        ? appProvider.profile.targetRole 
                        : 'Engineering Specialist',
                  ),
                  Divider(height: 20, color: AppTheme.borderOverlay),
                  _buildProfileTile(
                    icon: Icons.calendar_today,
                    title: appProvider.translate('academic_year'),
                    value: appProvider.profile.currentYear.isNotEmpty 
                        ? appProvider.profile.currentYear 
                        : '1st Year',
                  ),
                ]
                // EDITABLE FORM MODE
                else ...[
                  TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      labelText: appProvider.translate('student_name'),
                      labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _courseLevels.contains(_courseLevel) ? _courseLevel : 'B.Tech',
                    isExpanded: true,
                    dropdownColor: AppTheme.surfaceColor,
                    style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      labelText: appProvider.translate('course_level'),
                      labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                    items: _courseLevels.map((lvl) {
                      return DropdownMenuItem(value: lvl, child: Text(lvl));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _courseLevel = val;
                          if (val == 'B.Tech') {
                            _branch = 'CSE';
                            _subCourseController.text = 'Artificial Intelligence & ML';
                          } else if (val == 'Polytechnic') {
                            _branch = 'Computer Engg';
                            _subCourseController.text = 'Hardware & Networking';
                          } else {
                            _branch = 'BCA';
                            _subCourseController.text = 'Software Development';
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                          decoration: InputDecoration(
                            labelText: appProvider.translate('age'),
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: ['2022', '2023', '2024', '2025', '2026'].contains(_interYear) ? _interYear : '2024',
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceColor,
                          style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                          decoration: InputDecoration(
                            labelText: appProvider.translate('inter_year'),
                            labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: branchList.contains(_branch) ? _branch : branchList.first,
                    isExpanded: true,
                    dropdownColor: AppTheme.surfaceColor,
                    style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      labelText: appProvider.translate('branch'),
                      labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                    items: branchList.map((b) {
                      return DropdownMenuItem(value: b, child: Text(b, overflow: TextOverflow.ellipsis));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _branch = val;
                          final list = subCourseMap[val] ?? [];
                          if (list.isNotEmpty) {
                            _subCourseController.text = list.first;
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: subCourseList.contains(_subCourseController.text)
                        ? _subCourseController.text
                        : (subCourseList.first),
                    isExpanded: true,
                    dropdownColor: AppTheme.surfaceColor,
                    style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      labelText: appProvider.translate('sub_course'),
                      labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                    items: subCourseList.map((sc) {
                      return DropdownMenuItem(value: sc, child: Text(sc, overflow: TextOverflow.ellipsis));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _subCourseController.text = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: (_courseLevel == 'B.Tech' 
                            ? ['1st Year', '2nd Year', '3rd Year', '4th Year']
                            : ['1st Year', '2nd Year', '3rd Year']).contains(_year) 
                        ? _year 
                        : '1st Year',
                    isExpanded: true,
                    dropdownColor: AppTheme.surfaceColor,
                    style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      labelText: appProvider.translate('academic_year'),
                      labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.borderOverlay)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                    items: (_courseLevel == 'B.Tech'
                            ? ['1st Year', '2nd Year', '3rd Year', '4th Year']
                            : ['1st Year', '2nd Year', '3rd Year']).map((y) {
                      return DropdownMenuItem(value: y, child: Text(y));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _year = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: Text(appProvider.translate('cancel')),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: appProvider.isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: appProvider.isLoading
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save, size: 16),
                        label: Text(appProvider.translate('save_changes'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Account Credentials Info Card
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        appProvider.translate('account_security'),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildProfileTile(
                  icon: Icons.email,
                  title: appProvider.translate('account_email'),
                  value: appProvider.profile.email.isNotEmpty ? appProvider.profile.email : (appProvider.currentUser?.email ?? 'Logged In'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      appProvider.logout();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.logout, size: 16),
                    label: Text(appProvider.translate('sign_out'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(Icons.rocket_launch, color: AppTheme.primaryColor, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Futoria',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Futoria is a premium personal career mentor designed specifically for higher education students in India. Whether you are pursuing a B.Tech, polytechnic diploma, or standard undergraduate degree, Futoria builds a customized multi-year milestone roadmap tailored to your specific stream, age, and placement goals.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'Key Features Built:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
            const SizedBox(height: 8),
            _buildAboutBullet('🤖 Conversational AI Mentorship (Groq Llama 3)'),
            _buildAboutBullet('📅 Stream-specific 3 & 4 Year Timeline Milestones'),
            _buildAboutBullet('📈 Career Simulator & Reality Analyzer'),
            _buildAboutBullet('📝 Verified Top-Company Interview reviews'),
            _buildAboutBullet('🌎 English, Hindi, Telugu, and Tamil localization'),
            const SizedBox(height: 16),
            Text(
              'Designed to guide students step-by-step from their first day of college directly to their dream job offer.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildAboutBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
