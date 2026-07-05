import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  String? get _apiKey => dotenv.env['GROQ_API_KEY'];

  bool get hasApiKey {
    final key = _apiKey;
    return key != null && key.trim().isNotEmpty && key != 'your_groq_api_key_here';
  }

  /// Fast REST API chat completion to Groq LLM
  Future<String?> _chatCompletion({
    required List<Map<String, String>> messages,
    bool jsonMode = false,
    double temperature = 0.7,
    int maxTokens = 1536,
  }) async {
    final key = _apiKey;
    if (key == null || key.trim().isEmpty || key == 'your_groq_api_key_here') {
      return null;
    }

    try {
      final body = <String, dynamic>{
        'model': _model,
        'messages': messages,
        'temperature': temperature,
        'max_tokens': maxTokens,
      };

      if (jsonMode) {
        body['response_format'] = {'type': 'json_object'};
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $key',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] as String?;
      } else {
        debugPrint('Groq API error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Groq API request failed: $e');
      return null;
    }
  }

  // ==================== 1. AI Student Master Plan Generator ====================

  Future<Map<String, dynamic>> generateStudentMasterPlan({
    required String name,
    required int age,
    required String interPassOutYear,
    required String courseLevel,
    required String branch,
    required String subCourse,
    required String primaryInterest,
    required String careerGoal,
  }) async {
    final result = await _chatCompletion(
      jsonMode: true,
      temperature: 0.7,
      maxTokens: 2560,
      messages: [
        {
          'role': 'system',
          'content': '''You are an expert Indian higher education counselor. The student is pursuing a $courseLevel program. Generate a personalized academic & career plan for a student entering college (if B.Tech it is 4 years, if Degree it is 3 years, if Polytechnic it is 3 years).'''
        },
        {
          'role': 'user',
          'content': '''Student Profile:
- Name: $name
- Age: $age
- Intermediate/Class 10 Passed Out Year: $interPassOutYear
- Program / Course Type: $courseLevel
- Chosen Branch/Stream: $branch
- Sub-Course / Specialization: $subCourse
- Primary Interest: $primaryInterest
- Career Goal: $careerGoal

Generate JSON with these EXACT fields (if B.Tech, "fourYearTimeTable" must have 4 years; if Degree or Polytechnic, it must only have 3 years: Year 1, Year 2, and Year 3):
{
  "summaryHeadline": "High-impact single line summary for $name",
  "placementProbability": "Estimated placement probability % (e.g. 88%)",
  "expectedStartingSalary": "Real Indian LPA range (e.g. 7 - 14 LPA)",
  "topCareerRoles": ["4 specific job titles"],
  "hotSkillsToLearn": ["5 high-demand technical skills specific to $branch / $subCourse"],
  "suggestedYouTubeChannels": ["3 top YouTube channels for learning $branch / $subCourse"],
  "fourYearTimeTable": [
    {
      "year": "Year 1 (Sem 1 & 2)",
      "focus": "Core focus area",
      "actionItems": ["3 specific actionable milestones"],
      "skillTarget": "Key skill to master"
    },
    {
      "year": "Year 2 (Sem 3 & 4)",
      "focus": "Core focus area",
      "actionItems": ["3 specific actionable milestones"],
      "skillTarget": "Key skill to master"
    },
    {
      "year": "Year 3 (Sem 5 & 6)",
      "focus": "Core focus area",
      "actionItems": ["3 specific actionable milestones"],
      "skillTarget": "Key skill to master"
    }
  ],
  "mentorStrategicAdvice": "3 sentences of clear strategic advice"
}'''
        }
      ],
    );

    if (result != null) {
      try {
        return json.decode(result) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('JSON parse error for master plan: $e');
      }
    }
    return _getMockMasterPlan(name, courseLevel, branch, subCourse);
  }

  // ==================== 2. AI Career Reality Simulator ====================

  Future<Map<String, dynamic>> getCareerSimulation(String path, {String branch = ''}) async {
    final branchContext = branch.isNotEmpty ? ' (student branch: $branch)' : '';

    final result = await _chatCompletion(
      jsonMode: true,
      temperature: 0.7,
      maxTokens: 2560,
      messages: [
        {
          'role': 'system',
          'content': '''You are an Indian engineering career analyst. Generate UNIQUE, course-specific career simulation reports with real Indian salary ranges (LPA) and real industry workflows.'''
        },
        {
          'role': 'user',
          'content': '''Analyze target career path "$path"$branchContext.

Generate JSON with these EXACT fields:
{
  "title": "$path",
  "description": "2-3 sentence role overview with company hiring examples in India",
  "roadmap": [
    {"year": "Year 1", "focus": "Focus area", "milestones": ["3 milestones"]},
    {"year": "Year 2", "focus": "Focus area", "milestones": ["3 milestones"]},
    {"year": "Year 3", "focus": "Focus area", "milestones": ["3 milestones"]},
    {"year": "Year 4", "focus": "Focus area", "milestones": ["3 milestones"]}
  ],
  "skillsRequired": ["6 technical skills for THIS specific role"],
  "dayInLife": [
    {"time": "09:00 AM", "activity": "Activity 1"},
    {"time": "11:30 AM", "activity": "Activity 2"},
    {"time": "02:00 PM", "activity": "Activity 3"},
    {"time": "04:30 PM", "activity": "Activity 4"}
  ],
  "workCulture": {
    "teamStructure": "Team structure",
    "workingHours": "Working hours",
    "remotePossibility": "Remote work option"
  },
  "salaryGrowth": [
    {"position": "Entry Level", "yearsOfExp": "0-2 yrs", "avgSalary": "X-Y LPA"},
    {"position": "Senior Level", "yearsOfExp": "3-5 yrs", "avgSalary": "X-Y LPA"},
    {"position": "Lead / Architect", "yearsOfExp": "6-9 yrs", "avgSalary": "X-Y LPA"},
    {"position": "Director / Principal", "yearsOfExp": "10+ yrs", "avgSalary": "X-Y LPA"}
  ],
  "challenges": ["3 specific career challenges"],
  "futureRoles": ["4 realistic career progression titles"]
}'''
        }
      ],
    );

    if (result != null) {
      try {
        return json.decode(result) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('JSON parse error for career simulation: $e');
      }
    }
    return _getMockCareerSimulation(path);
  }

  // ==================== 3. Branch Comparison ====================

  Future<Map<String, dynamic>> getBranchComparison(String branchA, String branchB) async {
    final result = await _chatCompletion(
      jsonMode: true,
      temperature: 0.7,
      maxTokens: 2560,
      messages: [
        {
          'role': 'system',
          'content': 'Compare engineering branches factual, detailed comparisons using real data from NIRF rankings and Indian industry reports.'
        },
        {
          'role': 'user',
          'content': '''Compare B.Tech "$branchA" and "$branchB".

Generate JSON with these EXACT fields:
{
  "branchAInfo": {"title": "$branchA", "tagline": "Tagline A", "description": "Overview A"},
  "branchBInfo": {"title": "$branchB", "tagline": "Tagline B", "description": "Overview B"},
  "comparisonMatrix": [
    {"metric": "Difficulty Index", "valueA": "Val A", "valueB": "Val B"},
    {"metric": "Core Math/Science Focus", "valueA": "Val A", "valueB": "Val B"},
    {"metric": "Core Technical Subjects", "valueA": "Val A", "valueB": "Val B"},
    {"metric": "Current Industry Demand", "valueA": "Val A", "valueB": "Val B"},
    {"metric": "Private Sector Jobs", "valueA": "Val A", "valueB": "Val B"},
    {"metric": "Government Sector Jobs", "valueA": "Val A", "valueB": "Val B"},
    {"metric": "Average Entry Salary", "valueA": "Val A LPA", "valueB": "Val B LPA"}
  ],
  "academicJourneyComparison": {
    "branchA": ["Year 1: ...", "Year 2: ...", "Year 3: ...", "Year 4: ..."],
    "branchB": ["Year 1: ...", "Year 2: ...", "Year 3: ...", "Year 4: ..."]
  },
  "careerPathsComparison": {
    "branchA": ["4 career paths"],
    "branchB": ["4 career paths"]
  },
  "summaryVerdict": "Choosing advice"
}'''
        }
      ],
    );

    if (result != null) {
      try {
        return json.decode(result) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('JSON parse error for branch comparison: $e');
      }
    }
    return _getMockBranchComparison(branchA, branchB);
  }

  // ==================== 4. Skill Gap Analyzer ====================

  Future<Map<String, dynamic>> getSkillGapAnalysis(String targetRole, List<String> currentSkills) async {
    final result = await _chatCompletion(
      jsonMode: true,
      temperature: 0.7,
      maxTokens: 2048,
      messages: [
        {
          'role': 'system',
          'content': 'Conduct a skill gap analysis with actionable modules and project ideas.'
        },
        {
          'role': 'user',
          'content': '''Skill gap analysis for "$targetRole". Current skills: ${currentSkills.join(', ')}.

Generate JSON:
{
  "targetRole": "$targetRole",
  "statusPercent": 45,
  "acquiredSkills": ["validated skills"],
  "missingSkills": ["4-5 missing skills"],
  "learningPlan": [
    {
      "moduleName": "Module 1",
      "estimatedDuration": "X weeks",
      "topicsCovered": ["3 topics"],
      "projectIdea": "Project description",
      "practiceSchedule": "Schedule"
    }
  ],
  "advice": "Strategic advice"
}'''
        }
      ],
    );

    if (result != null) {
      try {
        return json.decode(result) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('JSON parse error: $e');
      }
    }
    return _getMockSkillGapAnalysis(targetRole, currentSkills);
  }

  // ==================== 5. AI Mentor Chat (Fast & Dynamic Topic Video Links) ====================

  Future<String> getMentorChatResponse(List<Map<String, String>> chatHistory, String newMessage) async {
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': '''You are "Futoria AI Mentor", an expert academic counselor and career guide for engineering students in India.

When the student asks about ANY topic (such as C programming, Python, Java, Mechanical CAD, VLSI, Civil Engineering, Electric Vehicles, AI, Data Science, Robotics, etc.):
1. Provide concise, clear, structured explanation with key concepts.
2. Recommend 2-3 top YouTube channels for learning that specific topic (e.g., freeCodeCamp, NPTEL, Gate Smashers, CodeWithHarry, Jenny's Lectures, MIT OpenCourseWare, Neso Academy).
3. Include working YouTube search links formatted in Markdown so the student can click directly to watch tutorials:
   Format: [Watch Topic Tutorial on YouTube](https://www.youtube.com/results?search_query=topic+tutorial)

Keep responses fast, direct, and encouraging! Adapt dynamically to whatever topic the student asks about.'''
      }
    ];

    // Add recent history (last 6 messages for maximum response speed)
    final recentHistory = chatHistory.length > 6 
        ? chatHistory.sublist(chatHistory.length - 6) 
        : chatHistory;

    for (final msg in recentHistory) {
      messages.add({
        'role': msg['role'] == 'user' ? 'user' : 'assistant',
        'content': msg['text'] ?? '',
      });
    }

    messages.add({'role': 'user', 'content': newMessage});

    final result = await _chatCompletion(
      messages: messages,
      jsonMode: false,
      temperature: 0.7,
      maxTokens: 1024, // Fast response < 1 sec
    );

    return result ?? _getMockMentorChatResponse(chatHistory, newMessage);
  }

  // ==================== MOCK FALLBACKS ====================

  Map<String, dynamic> _getMockMasterPlan(String name, String courseLevel, String branch, String subCourse) {
    final has4Years = courseLevel == 'B.Tech';
    return {
      "summaryHeadline": "Master Plan for $name in $branch ($subCourse)",
      "placementProbability": "88%",
      "expectedStartingSalary": "6 - 14 LPA",
      "topCareerRoles": ["$branch Specialist", "Systems Engineer", "Domain Architect", "R&D Engineer"],
      "hotSkillsToLearn": ["Core $branch Fundamentals", "Python/C++ Coding", "Cloud & Simulation Tools", "Project Portfolio Design", "Git Version Control"],
      "suggestedYouTubeChannels": ["freeCodeCamp", "Gate Smashers", "NPTEL Official"],
      "fourYearTimeTable": [
        {
          "year": "Year 1 (Sem 1 & 2)",
          "focus": "Foundations & Coding Basics",
          "actionItems": ["Master Python & C programming", "Learn basics of $branch", "Build 2 beginner GitHub projects"],
          "skillTarget": "Programming & Problem Solving"
        },
        {
          "year": "Year 2 (Sem 3 & 4)",
          "focus": "Core $branch Subjects & Data Structures",
          "actionItems": ["Master core department subjects", "Solve 100+ coding challenges", "Complete 1 mini hardware/software project"],
          "skillTarget": "Core Domain Engineering"
        },
        {
          "year": "Year 3 (Sem 5 & 6)",
          "focus": "Specialization in $subCourse & Internship",
          "actionItems": ["Master $subCourse tools", "Complete 8-week summer internship", "Build production capstone project"],
          "skillTarget": "$subCourse Expertise"
        },
        if (has4Years) {
          "year": "Year 4 (Sem 7 & 8)",
          "focus": "Campus Placements & Graduation",
          "actionItems": ["Crack written assessments & technical interviews", "Publish capstone project", "Secure high-LPA job offer"],
          "skillTarget": "Placement & Career Onboarding"
        }
      ],
      "mentorStrategicAdvice": "Focus on building practical hands-on projects rather than just studying theory. Master Git, maintain a clean portfolio, and stay consistent throughout your ${has4Years ? '4' : '3'} years!"
    };
  }

  Map<String, dynamic> _getMockCareerSimulation(String path) {
    final lower = path.toLowerCase();
    String title = path;
    String description = "Specializes in $path in the Indian engineering industry with strong growth potential.";
    List<String> skills = ["Core Engineering", "Problem Solving", "CAD/Coding", "System Architecture"];
    
    if (lower.contains('robot') || lower.contains('auto')) {
      title = "Robotics & Automation Engineer";
      description = "Designs, programs, and integrates autonomous robotic arms, industrial automation lines, and PLC control systems for manufacturing and warehouse units.";
      skills = ["ROS (Robot Operating System)", "Python/C++", "PLC Programming", "Control Systems", "Computer Vision"];
    } else if (lower.contains('data') || lower.contains('ai')) {
      title = "Data Scientist / AI Specialist";
      description = "Extracts insights from big data, trains neural networks, and deploys predictive machine learning models for top tech startups and MNCs.";
      skills = ["Python", "PyTorch/TensorFlow", "SQL & BigData", "Scikit-Learn", "Groq API", "MLOps"];
    } else if (lower.contains('chem')) {
      title = "Chemical Process Engineer";
      description = "Designs, optimizes, and operates chemical reactors, refineries, pharmaceutical plants, and process pipelines across India.";
      skills = ["Aspen Plus", "Process Control", "Mass & Heat Transfer", "Reaction Kinetics", "Safety Standards"];
    } else if (lower.contains('it') || lower.contains('information')) {
      title = "IT Systems & Cloud Engineer";
      description = "Architects enterprise cloud infrastructure, manages database clusters, and deploys web solutions for Fortune 500 enterprises.";
      skills = ["AWS/Azure", "Docker & Kubernetes", "Linux Systems", "Python/Java", "DevOps & CI/CD"];
    }

    return {
      "title": title,
      "description": description,
      "roadmap": [
        {"year": "Year 1", "focus": "Foundations", "milestones": ["Master programming/drawing basics", "Learn core math", "Build 2 beginner projects"]},
        {"year": "Year 2", "focus": "Core Domain", "milestones": ["Study departmental core subjects", "Learn simulation tools", "Join technical club"]},
        {"year": "Year 3", "focus": "Specialization & Internship", "milestones": ["Complete summer internship", "Master industry tools", "Build capstone project"]},
        {"year": "Year 4", "focus": "Placements", "milestones": ["Crack placement drives", "Deploy capstone", "Finalize career onboarding"]}
      ],
      "skillsRequired": skills,
      "dayInLife": [
        {"time": "09:30 AM", "activity": "Morning standup meeting and sprint task review"},
        {"time": "11:00 AM", "activity": "Core design, programming, or simulation session"},
        {"time": "02:00 PM", "activity": "Testing candidate models / components in lab"},
        {"time": "04:30 PM", "activity": "Code/Design review and documentation updates"}
      ],
      "workCulture": {
        "teamStructure": "4 Engineers, 1 Tech Lead, 1 Product Manager",
        "workingHours": "9:30 AM - 6:30 PM",
        "remotePossibility": "Hybrid / Flexible"
      },
      "salaryGrowth": [
        {"position": "Graduate Trainee", "yearsOfExp": "0-2 yrs", "avgSalary": "5 - 10 LPA"},
        {"position": "Senior Specialist", "yearsOfExp": "3-5 yrs", "avgSalary": "12 - 22 LPA"},
        {"position": "Lead Engineer", "yearsOfExp": "6-9 yrs", "avgSalary": "24 - 38 LPA"},
        {"position": "Director / Architect", "yearsOfExp": "10+ yrs", "avgSalary": "45 - 75+ LPA"}
      ],
      "challenges": [
        "Keeping pace with rapidly evolving technology standards",
        "Balancing theoretical precision with tight project deadlines",
        "Continuous skill upgrading required every 2 years"
      ],
      "futureRoles": ["Senior Specialist", "Principal Architect", "VP of Engineering", "Chief Technology Officer"]
    };
  }

  Map<String, dynamic> _getMockBranchComparison(String branchA, String branchB) {
    return {
      "branchAInfo": {
        "title": branchA,
        "tagline": "Explore $branchA engineering opportunities.",
        "description": "$branchA focuses on core technical domain knowledge and high-growth industry applications in India."
      },
      "branchBInfo": {
        "title": branchB,
        "tagline": "Discover $branchB engineering paths.",
        "description": "$branchB prepares students for specialized hardware, software, or manufacturing careers."
      },
      "comparisonMatrix": [
        {"metric": "Difficulty Index", "valueA": "Medium-High", "valueB": "Medium-High"},
        {"metric": "Core Math/Science Focus", "valueA": "Applied Sciences", "valueB": "Applied Mathematics"},
        {"metric": "Current Industry Demand", "valueA": "Very High", "valueB": "High"},
        {"metric": "Average Entry Salary", "valueA": "6 - 12 LPA", "valueB": "5 - 10 LPA"}
      ],
      "academicJourneyComparison": {
        "branchA": ["Year 1: Foundations", "Year 2: Core Engineering", "Year 3: Specialization", "Year 4: Placements"],
        "branchB": ["Year 1: Foundations", "Year 2: Core Engineering", "Year 3: Specialization", "Year 4: Placements"]
      },
      "careerPathsComparison": {
        "branchA": ["Domain Specialist", "Systems Engineer", "R&D Consultant", "Project Lead"],
        "branchB": ["Domain Specialist", "Systems Engineer", "R&D Consultant", "Project Lead"]
      },
      "summaryVerdict": "Both $branchA and $branchB offer strong career prospects. Choose based on whether you prefer software logic, hardware circuits, physical machinery, or data analytics!"
    };
  }

  Map<String, dynamic> _getMockSkillGapAnalysis(String targetRole, List<String> currentSkills) {
    return {
      "targetRole": targetRole,
      "statusPercent": 40,
      "acquiredSkills": currentSkills,
      "missingSkills": ["Advanced Technical Concepts", "Industry Design Tools", "System Architecture", "Cloud & Deployment"],
      "learningPlan": [
        {
          "moduleName": "Module 1: Domain Foundations",
          "estimatedDuration": "3 weeks",
          "topicsCovered": ["Core principles", "Standard workflows", "Tooling setup"],
          "projectIdea": "Build a hands-on functional prototype",
          "practiceSchedule": "2 hours daily"
        },
        {
          "moduleName": "Module 2: Advanced System Architecture",
          "estimatedDuration": "4 weeks",
          "topicsCovered": ["Optimization", "Scalability", "Security & Reliability"],
          "projectIdea": "Create an end-to-end industry capstone",
          "practiceSchedule": "3 sessions weekly"
        }
      ],
      "advice": "Focus on completing real-world projects and pushing code/designs to your GitHub portfolio to showcase your capabilities to recruiters."
    };
  }

  String _getMockMentorChatResponse(List<Map<String, String>> chatHistory, String newMessage) {
    final lower = newMessage.toLowerCase();

    if (lower.contains('c ') || lower.contains('c programming') || lower.contains('c language')) {
      return '''### 💻 C Programming Fundamentals
C is the foundation of computer science, operating systems, and embedded systems!

**Key Topics to Master:**
• Pointers & Memory Management (`malloc`, `free`)
• Structures & Unions
• File I/O operations
• Control Flow & Arrays

**Recommended YouTube Channels:**
1. **Jenny's Lectures CS IT** — Best for absolute beginners
2. **Neso Academy** — In-depth C programming lectures
3. **freeCodeCamp.org** — Full 4-hour C tutorial course

👉 [Watch C Programming Tutorials on YouTube](https://www.youtube.com/results?search_query=c+programming+full+course)''';
    }

    if (lower.contains('python')) {
      return '''### 🐍 Python Programming Roadmap
Python is the #1 language for Data Science, AI, Web Development, and Automation!

**Key Topics to Master:**
• Data Structures (Lists, Dicts, Sets, Tuples)
• Object-Oriented Programming (OOP)
• File Handling & APIs
• Scikit-Learn & PyTorch for AI

**Recommended YouTube Channels:**
1. **CodeWithHarry** — Complete Python Course in Hindi & English
2. **Corey Schafer** — In-depth Python OOP & Django
3. **freeCodeCamp.org** — Python for Beginners Full Course

👉 [Watch Python Tutorials on YouTube](https://www.youtube.com/results?search_query=python+programming+full+course)''';
    }

    if (lower.contains('mech') || lower.contains('cad') || lower.contains('solidworks')) {
      return '''### ⚙️ Mechanical Design & CAD Engineering
Mechanical engineering powers automotive, aerospace, robotics, and manufacturing industries!

**Key Topics to Master:**
• 2D/3D CAD Modeling (SolidWorks / AutoCAD / CATIA)
• Finite Element Analysis (ANSYS)
• Strength of Materials & GD&T

**Recommended YouTube Channels:**
1. **LearnEngineering / Lesics** — Animated mechanical concepts
2. **SolidWorks Tutorial by CAD CAM TUTORIAL** — Hands-on 3D modeling
3. **NPTEL IIT Courses** — Machine Design & Thermodynamics

👉 [Watch Mechanical CAD Tutorials on YouTube](https://www.youtube.com/results?search_query=solidworks+mechanical+design+tutorial)''';
    }

    return '''### 🚀 Career Guidance for $newMessage
To excel in this field, focus on building practical projects and mastering core fundamentals!

**Recommended Learning Strategy:**
1. Master core domain concepts through hands-on practice
2. Learn industry-standard software tools
3. Build 2-3 showcase projects for your resume

**Recommended YouTube Channels:**
• **freeCodeCamp** — Comprehensive tech & programming courses
• **Gate Smashers** — Simplified core engineering concepts
• **NPTEL Official** — Advanced IIT professor lectures

👉 [Watch Related Tutorials on YouTube](https://www.youtube.com/results?search_query=${Uri.encodeComponent(newMessage)}+tutorial)''';
  }
}
