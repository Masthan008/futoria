import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String _profileKey = 'futurepath_user_profile';
  static const String _apiKeyKey = 'futurepath_gemini_api_key';

  // Load User Profile from SharedPreferences
  Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_profileKey);
    if (jsonStr != null) {
      try {
        return UserProfile.fromJson(jsonStr);
      } catch (e) {
        // Corrupted cache fallback
        return UserProfile.empty();
      }
    }
    return UserProfile.empty();
  }

  // Save User Profile
  Future<bool> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_profileKey, profile.toJson());
  }

  // Clear Profile (Reset App)
  Future<bool> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_profileKey);
  }

  // Save Gemini API Key
  Future<bool> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_apiKeyKey, apiKey);
  }

  // Load Gemini API Key
  Future<String?> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }
}
