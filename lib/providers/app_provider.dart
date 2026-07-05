import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../services/groq_service.dart';
import '../services/storage_service.dart';
import '../services/youtube_service.dart';
import '../services/translation_service.dart';
import '../theme/app_theme.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final GroqService _groqService = GroqService();
  final YouTubeService _youtubeService = YouTubeService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfile _profile = UserProfile.empty();
  bool _isLoading = false;
  int _activePageIndex = 0;
  String? _geminiApiKey;
  bool _hasApiKey = false;
  
  // Theme & Language Settings
  bool _isDarkMode = false;
  String _languageCode = 'en';
  
  // Auth & Onboarding State
  User? _currentUser;
  bool _isOnboarded = false;
  bool _initComplete = false;
  StreamSubscription<User?>? _authSubscription;

  // Cached dynamic AI responses
  Map<String, dynamic>? _careerSimulationCache;
  Map<String, dynamic>? _branchComparisonCache;
  Map<String, dynamic>? _skillGapAnalysisCache;
  List<Map<String, String>> _mentorChatHistory = [];
  List<YouTubeVideo> _youtubeRecommendations = [];

  // Getters
  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;
  int get activePageIndex => _activePageIndex;
  String? get geminiApiKey => _geminiApiKey;
  bool get hasApiKey => _hasApiKey;
  Map<String, dynamic>? get careerSimulation => _careerSimulationCache;
  Map<String, dynamic>? get branchComparison => _branchComparisonCache;
  Map<String, dynamic>? get skillGapAnalysis => _skillGapAnalysisCache;
  List<Map<String, String>> get mentorChatHistory => _mentorChatHistory;
  List<YouTubeVideo> get youtubeRecommendations => _youtubeRecommendations;
  
  User? get currentUser => _currentUser;
  bool get isOnboarded => _isOnboarded;
  bool get initComplete => _initComplete;
  
  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;

  // Theme & Language Setters
  Future<void> setDarkMode(bool val) async {
    _isDarkMode = val;
    AppTheme.isDarkMode = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('futurepath_dark_mode', val);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _languageCode = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('futurepath_language', lang);
    _resetChatHistoryForCurrentUser();
    notifyListeners();
  }

  String translate(String key) {
    return TranslationService.translate(key, _languageCode);
  }

  // Initialization
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    // Check onboarding status, theme, and language preferences
    final prefs = await SharedPreferences.getInstance();
    _isOnboarded = prefs.getBool('futurepath_onboarded') ?? false;
    _isDarkMode = prefs.getBool('futurepath_dark_mode') ?? false;
    AppTheme.isDarkMode = _isDarkMode;
    _languageCode = prefs.getString('futurepath_language') ?? 'en';

    _geminiApiKey = await _storageService.loadApiKey();
    _hasApiKey = _geminiApiKey != null && _geminiApiKey!.trim().isNotEmpty;
    
    // Seed chat history if empty
    if (_mentorChatHistory.isEmpty) {
      _mentorChatHistory.add({
        'role': 'model',
        'text': 'Hello! I am your Futoria AI Mentor. I help students select the right branch, plan their college years, map trending skills, and explore daily job roles. Tell me: What are you studying currently, or what branch are you planning to choose? Also, let me know if you prefer coding, hardware design, or working with mechanical systems!'
      });
    }

    // Set current user synchronously before stream subscription to avoid null flash
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      await _syncProfileFromFirestore();
    }

    // Subscribe to Auth State Changes for future updates
    _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((User? user) async {
      _currentUser = user;
      if (user != null) {
        await _syncProfileFromFirestore();
      } else {
        _profile = UserProfile.empty();
      }
      try {
        await refreshYouTubeRecommendations();
      } catch (e) {
        debugPrint('YouTube refresh error: $e');
      }
      notifyListeners();
    });

    _initComplete = true;
    _isLoading = false;
    notifyListeners();
  }

  // Complete Onboarding
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('futurepath_onboarded', true);
    _isOnboarded = true;
    notifyListeners();
  }

  void _resetChatHistoryForCurrentUser() {
    _mentorChatHistory.clear();
    final studentName = _profile.displayName.isNotEmpty && _profile.displayName != 'Future Path Finder'
        ? _profile.displayName
        : 'Student';
    _mentorChatHistory.add({
      'role': 'model',
      'text': 'Hello $studentName! I am your Futoria AI Mentor. I am here to guide your academic journey in ${_profile.branch}. Ask me about any topic, course, syllabus, or request video tutorials (e.g. C programming, Python, VLSI, EV, Structural Engg) and I will provide instant answers and video links!'
    });
  }

  // Sync Profile from Firestore
  Future<void> _syncProfileFromFirestore() async {
    if (_currentUser == null) return;
    try {
      final doc = await _firestore.collection('users').doc(_currentUser!.uid).get();
      if (doc.exists && doc.data() != null) {
        _profile = UserProfile.fromMap(doc.data()!);
      } else {
        // Create document in Firestore with current data or empty default
        _profile = _profile.copyWith(
          uid: _currentUser!.uid,
          email: _currentUser!.email ?? _profile.email,
        );
        await _firestore.collection('users').doc(_currentUser!.uid).set(_profile.toMap());
      }
      _resetChatHistoryForCurrentUser();
    } catch (e) {
      debugPrint('Firestore sync error: $e');
    }
  }

  // Complete Student Assessment & Master Plan Onboarding
  Future<void> completeStudentOnboarding({
    required String name,
    required int age,
    required String interPassOutYear,
    required String courseLevel,
    required String branch,
    required String subCourse,
    required String primaryInterest,
    required String careerGoal,
    required double codingScore,
    required double electronicsScore,
    required double machinesScore,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Generate master plan from Groq AI
      final masterPlan = await _groqService.generateStudentMasterPlan(
        name: name,
        age: age,
        interPassOutYear: interPassOutYear,
        courseLevel: courseLevel,
        branch: branch,
        subCourse: subCourse,
        primaryInterest: primaryInterest,
        careerGoal: careerGoal,
      );

      // 2. Update profile
      _profile = _profile.copyWith(
        displayName: name,
        age: age,
        interPassOutYear: interPassOutYear,
        courseLevel: courseLevel,
        branch: branch,
        subCourse: subCourse,
        targetRole: (masterPlan['topCareerRoles'] as List?)?.first ?? '$branch Specialist',
        questionnaireCompleted: true,
        assessmentResult: masterPlan,
        interests: {
          'coding': codingScore,
          'electronics': electronicsScore,
          'machines': machinesScore,
          'primaryInterest': primaryInterest,
          'careerGoal': careerGoal,
        },
      );

      // 3. Save to Firestore
      if (_currentUser != null) {
        await _firestore.collection('users').doc(_currentUser!.uid).set(_profile.toMap(), SetOptions(merge: true));
        await _firestore.collection('assessments').doc(_currentUser!.uid).set(masterPlan, SetOptions(merge: true));
      }

      // 4. Update recommendations
      await refreshYouTubeRecommendations(customQuery: '$branch $subCourse tutorial');
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Auth Operations
  Future<void> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signupWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      // google_sign_in v7.x API - Initialize with Web Client ID (serverClientId) for Android
      final googleSignIn = GoogleSignIn.instance;
      try {
        await googleSignIn.initialize(
          serverClientId: '1072707207855-7cd1bdfflp3tc17127n4sakblb9hg3uc.apps.googleusercontent.com',
        );
      } catch (e) {
        debugPrint('GoogleSignIn initialize: $e');
      }
      
      // First try lightweight (silent) auth, then fall back to interactive
      GoogleSignInAccount? account;
      try {
        final silentFuture = googleSignIn.attemptLightweightAuthentication();
        if (silentFuture != null) {
          account = await silentFuture;
        }
      } catch (e) {
        debugPrint('Lightweight auth failed: $e');
      }
      
      // If silent auth didn't work, do interactive sign-in
      account ??= await googleSignIn.authenticate();
      
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw Exception('No ID token received from Google Sign-In');
      }
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseException catch (e) {
      debugPrint('Firebase Auth error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Google Sign-In failed: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        debugPrint('Google Sign-Out error: $e');
      }
      await _auth.signOut();
      _activePageIndex = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Navigation
  void setPageIndex(int index) {
    _activePageIndex = index;
    notifyListeners();
  }

  // Manage API Key
  Future<void> updateApiKey(String key) async {
    await _storageService.saveApiKey(key);
    _geminiApiKey = key;
    _hasApiKey = key.trim().isNotEmpty;
    notifyListeners();
  }

  // Manage Profile
  Future<void> updateProfile(UserProfile updated) async {
    _profile = updated;
    await _storageService.saveProfile(_profile);
    if (_currentUser != null) {
      try {
        await _firestore.collection('users').doc(_currentUser!.uid).set(_profile.toMap());
      } catch (e) {
        debugPrint("Firestore write error: $e");
      }
    }
    await refreshYouTubeRecommendations();
    notifyListeners();
  }

  Future<void> addSkill(String skill) async {
    if (!_profile.currentSkills.contains(skill)) {
      final updatedSkills = List<String>.from(_profile.currentSkills)..add(skill);
      await updateProfile(_profile.copyWith(currentSkills: updatedSkills));
    }
  }

  Future<void> removeSkill(String skill) async {
    if (_profile.currentSkills.contains(skill)) {
      final updatedSkills = List<String>.from(_profile.currentSkills)..remove(skill);
      await updateProfile(_profile.copyWith(currentSkills: updatedSkills));
    }
  }

  Future<void> toggleTask(String taskId) async {
    final updatedTasks = List<String>.from(_profile.completedTasks);
    if (updatedTasks.contains(taskId)) {
      updatedTasks.remove(taskId);
    } else {
      updatedTasks.add(taskId);
    }
    await updateProfile(_profile.copyWith(completedTasks: updatedTasks));
  }

  Future<void> resetProfile() async {
    _isLoading = true;
    notifyListeners();
    await _storageService.clearProfile();
    _profile = UserProfile.empty();
    _mentorChatHistory = [
      {
        'role': 'model',
        'text': 'Hello! I am your Futoria AI Mentor. I help students select the right branch, plan their college years, map trending skills, and explore daily job roles. Tell me: What are you studying currently, or what branch are you planning to choose? Also, let me know if you prefer coding, hardware design, or working with mechanical systems!'
      }
    ];
    _careerSimulationCache = null;
    _branchComparisonCache = null;
    _skillGapAnalysisCache = null;
    if (_currentUser != null) {
      try {
        await _firestore.collection('users').doc(_currentUser!.uid).delete();
      } catch (_) {}
    }
    await refreshYouTubeRecommendations();
    _isLoading = false;
    notifyListeners();
  }

  // YouTube Loader
  Future<void> refreshYouTubeRecommendations({String? customQuery}) async {
    String searchTopic = customQuery ?? _profile.targetRole;
    if (searchTopic.trim().isEmpty) {
      searchTopic = _profile.branch.isNotEmpty ? '${_profile.branch} Engineering Courses' : 'Engineering Tutorials';
    }
    if (customQuery == null && _profile.currentSkills.isNotEmpty) {
      // Focus on the first missing skill if available
      if (_skillGapAnalysisCache != null && 
          _skillGapAnalysisCache!['missingSkills'] != null &&
          (_skillGapAnalysisCache!['missingSkills'] as List).isNotEmpty) {
        searchTopic = (_skillGapAnalysisCache!['missingSkills'] as List).first;
      }
    }
    _youtubeRecommendations = await _youtubeService.searchVideos(searchTopic);
    notifyListeners();
  }

  // Career Simulation Action
  Future<void> loadCareerSimulation(String path) async {
    _isLoading = true;
    notifyListeners();

    try {
      _careerSimulationCache = await _groqService.getCareerSimulation(path, branch: _profile.branch);
      await refreshYouTubeRecommendations(customQuery: path);
    } catch (e) {
      debugPrint("Groq simulation error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Branch Comparison Action
  Future<void> loadBranchComparison(String branchA, String branchB) async {
    _isLoading = true;
    notifyListeners();

    try {
      _branchComparisonCache = await _groqService.getBranchComparison(branchA, branchB);
    } catch (e) {
      debugPrint("Groq branch comparison error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Skill Gap Analysis Action
  Future<void> loadSkillGapAnalysis() async {
    _isLoading = true;
    notifyListeners();

    try {
      _skillGapAnalysisCache = await _groqService.getSkillGapAnalysis(
        _profile.targetRole,
        _profile.currentSkills,
      );
      await refreshYouTubeRecommendations();
    } catch (e) {
      debugPrint("Groq skill gap error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Chat Mentor Action
  Future<void> sendMentorMessage(String text) async {
    if (text.trim().isEmpty) return;

    _mentorChatHistory.add({'role': 'user', 'text': text});
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _groqService.getMentorChatResponse(
        _mentorChatHistory,
        text,
      );
      _mentorChatHistory.add({'role': 'model', 'text': response});

      // Update YouTube recommendations in real-time based on student's chat prompt
      await refreshYouTubeRecommendations(customQuery: text);
    } catch (e) {
      _mentorChatHistory.add({
        'role': 'model',
        'text': 'Sorry, I couldn\'t process that message. Please try again.'
      });
    }

    _isLoading = false;
    notifyListeners();
  }
}
