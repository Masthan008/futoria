import 'dart:convert';

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final int age;
  final String interPassOutYear;
  final String courseLevel;
  final String targetRole;
  final String branch;
  final String subCourse;
  final String currentYear;
  final List<String> currentSkills;
  final List<String> completedTasks;
  final Map<String, dynamic> interests;
  final bool questionnaireCompleted;
  final Map<String, dynamic> assessmentResult;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.age = 18,
    this.interPassOutYear = '2024',
    this.courseLevel = 'B.Tech',
    required this.targetRole,
    required this.branch,
    this.subCourse = 'General Engineering',
    required this.currentYear,
    required this.currentSkills,
    required this.completedTasks,
    required this.interests,
    this.questionnaireCompleted = false,
    this.assessmentResult = const {},
  });

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    int? age,
    String? interPassOutYear,
    String? courseLevel,
    String? targetRole,
    String? branch,
    String? subCourse,
    String? currentYear,
    List<String>? currentSkills,
    List<String>? completedTasks,
    Map<String, dynamic>? interests,
    bool? questionnaireCompleted,
    Map<String, dynamic>? assessmentResult,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      interPassOutYear: interPassOutYear ?? this.interPassOutYear,
      courseLevel: courseLevel ?? this.courseLevel,
      targetRole: targetRole ?? this.targetRole,
      branch: branch ?? this.branch,
      subCourse: subCourse ?? this.subCourse,
      currentYear: currentYear ?? this.currentYear,
      currentSkills: currentSkills ?? this.currentSkills,
      completedTasks: completedTasks ?? this.completedTasks,
      interests: interests ?? this.interests,
      questionnaireCompleted: questionnaireCompleted ?? this.questionnaireCompleted,
      assessmentResult: assessmentResult ?? this.assessmentResult,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'age': age,
      'interPassOutYear': interPassOutYear,
      'courseLevel': courseLevel,
      'targetRole': targetRole,
      'branch': branch,
      'subCourse': subCourse,
      'currentYear': currentYear,
      'currentSkills': currentSkills,
      'completedTasks': completedTasks,
      'interests': interests,
      'questionnaireCompleted': questionnaireCompleted,
      'assessmentResult': assessmentResult,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      age: map['age'] is int ? map['age'] : int.tryParse('${map['age']}') ?? 18,
      interPassOutYear: '${map['interPassOutYear'] ?? '2024'}',
      courseLevel: map['courseLevel'] ?? 'B.Tech',
      targetRole: map['targetRole'] ?? 'Software Engineer',
      branch: map['branch'] ?? 'CSE',
      subCourse: map['subCourse'] ?? 'General Engineering',
      currentYear: map['currentYear'] ?? '1st Year',
      currentSkills: List<String>.from(map['currentSkills'] ?? []),
      completedTasks: List<String>.from(map['completedTasks'] ?? []),
      interests: Map<String, dynamic>.from(map['interests'] ?? {}),
      questionnaireCompleted: map['questionnaireCompleted'] ?? false,
      assessmentResult: Map<String, dynamic>.from(map['assessmentResult'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));

  factory UserProfile.empty() {
    return UserProfile(
      uid: 'demo_user',
      email: 'demo@futoria.ai',
      displayName: 'Futoria Student',
      age: 18,
      interPassOutYear: '2024',
      courseLevel: 'B.Tech',
      targetRole: 'AI Engineer',
      branch: 'CSE',
      subCourse: 'Artificial Intelligence & ML',
      currentYear: '1st Year',
      currentSkills: ['Python', 'Problem Solving'],
      completedTasks: [],
      interests: {
        'coding': 5.0,
        'electronics': 2.0,
        'machines': 1.0,
        'creativity': 4.0,
      },
      questionnaireCompleted: false,
      assessmentResult: {},
    );
  }
}
