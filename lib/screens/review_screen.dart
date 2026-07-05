import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<dynamic> _companies = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCompany = 'All';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Technical', 'Managerial', 'HR'];

  @override
  void initState() {
    super.initState();
    _loadReviewData();
  }

  Future<void> _loadReviewData() async {
    final bundle = DefaultAssetBundle.of(context);
    try {
      final jsonString = await bundle.loadString('assets/review.json');
      final data = json.decode(jsonString);
      if (mounted) {
        setState(() {
          _companies = data['interview_data'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading assets/review.json: $e');
      try {
        final jsonStringFallback = await bundle.loadString('review.json');
        final dataFallback = json.decode(jsonStringFallback);
        if (mounted) {
          setState(() {
            _companies = dataFallback['interview_data'] ?? [];
            _isLoading = false;
          });
        }
      } catch (e2) {
        debugPrint('Error loading fallback review.json: $e2');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    // Get list of unique companies
    final companyNames = ['All'] + _companies.map((c) => c['company'] as String).toList();

    // Filter questions
    final filteredQuestions = [];
    for (var companyObj in _companies) {
      final compName = companyObj['company'] as String;
      final batch = companyObj['batch'] ?? '';
      
      if (_selectedCompany != 'All' && compName != _selectedCompany) {
        continue;
      }

      final questionsList = companyObj['questions'] as List<dynamic>? ?? [];
      for (var q in questionsList) {
        final category = q['category'] as String? ?? '';
        final subCategory = q['sub_category'] as String? ?? '';
        final questionText = q['question'] as String? ?? '';
        final answerText = q['answer'] as String? ?? '';

        if (_selectedCategory != 'All' && category != _selectedCategory) {
          continue;
        }

        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final matchesQuery = compName.toLowerCase().contains(query) ||
              category.toLowerCase().contains(query) ||
              subCategory.toLowerCase().contains(query) ||
              questionText.toLowerCase().contains(query) ||
              answerText.toLowerCase().contains(query);
          if (!matchesQuery) continue;
        }

        filteredQuestions.add({
          'company': compName,
          'batch': batch,
          'id': q['id'] ?? '',
          'category': category,
          'sub_category': subCategory,
          'question': questionText,
          'answer': answerText,
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  appProvider.translate('interview_reviews'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Text(
                'Access real company interview questions and curated preparations.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),

        // Search Bar & Category filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Column(
              children: [
                // Search Input
                TextField(
                  style: TextStyle(fontSize: 13.5, color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: appProvider.translate('company_search') + ' or topics...',
                    hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary, size: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                ),
                const Divider(height: 12, thickness: 0.5),
                // Category Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          label: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 11.5, 
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCategory = cat);
                          },
                          selectedColor: AppTheme.primaryColor,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : AppTheme.borderOverlay,
                              width: 0.8,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Horizontal Company selection chips
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: companyNames.length,
            itemBuilder: (context, i) {
              final name = companyNames[i];
              final isSelected = _selectedCompany == name;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                child: ActionChip(
                  backgroundColor: isSelected 
                      ? AppTheme.primaryColor 
                      : (AppTheme.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB)),
                  label: Text(
                    name,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  side: BorderSide(color: AppTheme.borderOverlay, width: 0.5),
                  onPressed: () {
                    setState(() {
                      _selectedCompany = name;
                    });
                  },
                ),
              );
            },
          ),
        ),

        // Questions List
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
              : filteredQuestions.isEmpty
                  ? Center(
                      child: Text(
                        appProvider.translate('no_reviews_found'),
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredQuestions.length,
                      itemBuilder: (context, index) {
                        final q = filteredQuestions[index];
                        final category = q['category'] ?? '';
                        Color categoryColor = Colors.purple;
                        if (category == 'Managerial') categoryColor = Colors.teal;
                        if (category == 'HR') categoryColor = Colors.orange;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ExpansionCard(
                            company: q['company'] ?? '',
                            batch: 'Batch ${q['batch']}',
                            category: category,
                            categoryColor: categoryColor,
                            subCategory: q['sub_category'] ?? '',
                            question: q['question'] ?? '',
                            answer: q['answer'] ?? '',
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class ExpansionCard extends StatefulWidget {
  final String company;
  final String batch;
  final String category;
  final Color categoryColor;
  final String subCategory;
  final String question;
  final String answer;

  const ExpansionCard({
    super.key,
    required this.company,
    required this.batch,
    required this.category,
    required this.categoryColor,
    required this.subCategory,
    required this.question,
    required this.answer,
  });

  @override
  State<ExpansionCard> createState() => _ExpansionCardState();
}

class _ExpansionCardState extends State<ExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company name and badge tags
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.company,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (widget.batch.isNotEmpty && widget.batch != 'Batch ' && widget.batch != 'Batch null') ...[
                        const SizedBox(width: 8),
                        Text(
                          widget.batch,
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.category,
                      style: TextStyle(
                        color: widget.categoryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              // Sub-category and question
              Text(
                widget.subCategory.toUpperCase(),
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ],
              ),

              // Answer text panel
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(height: 1, thickness: 0.5),
                    const SizedBox(height: 10),
                    Text(
                      'Suggested Answer:',
                      style: TextStyle(
                        fontSize: 11.5, 
                        fontWeight: FontWeight.bold, 
                        color: AppTheme.isDarkMode ? AppTheme.accentColor : AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.answer,
                      style: TextStyle(
                        fontSize: 13, 
                        color: AppTheme.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
                crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
