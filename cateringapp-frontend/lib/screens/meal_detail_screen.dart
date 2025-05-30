import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealDetailScreen extends StatefulWidget {
  final String id;

  const MealDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFavorite = false;
  bool _isLoading = true;
  Map<String, dynamic> _mealData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchMealDetail();
  }

  Future<void> _fetchMealDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-cateringapp-pbm.vercel.app/api/meals/${widget.id}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _mealData = data['data'];
          _isLoading = false;
        });
      } else {
        print('Failed to fetch meal detail');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching meal detail: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleBackPress() {
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildInfoSection(),
                  _buildTabs(),
                  _buildTabContent(),
                  _buildBottomButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Image.network(
            _mealData['imgURL'] ?? '',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _handleBackPress,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _mealData['mealName'] ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Tambahkan elemen waktu di bawah nama makanan, berdasarkan data servingTime dari API
          if ((_mealData['servingTime'] ?? '').toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.timer,
                    size: 18,
                    color: Color(0xFF98D8AA),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _mealData['servingTime'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF98D8AA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(Icons.star,
                  "${_mealData['rating'] ?? '0.0'} Rating", Colors.amber),
              _buildInfoChip(Icons.local_fire_department,
                  "${_mealData['calories'] ?? '0'} Kcal", Colors.orange),
              _buildInfoChip(Icons.timer,
                  "${_mealData['servingTime'] ?? '5 Min'} ", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: const Color(0xFF98D8AA),
      unselectedLabelColor: Colors.grey,
      indicatorColor: const Color(0xFF98D8AA),
      tabs: const [
        Tab(text: 'Description'),
        Tab(text: 'Ingredients'),
        Tab(text: 'Reviews'),
      ],
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: _tabController.index == 0
          ? _getDescriptionTabHeight()
          : _tabController.index == 1
              ? _getIngredientsTabHeight()
              : _getReviewsTabHeight(),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(),
          _buildIngredientsTab(),
          _buildReviewsTab(),
        ],
      ),
    );
  }

  double _getDescriptionTabHeight() {
    final description = _mealData['description'] ?? 'No description available';
    final textSpan = TextSpan(
      text: description,
      style: TextStyle(
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64);

    return textPainter.height + 120; // Add padding and container heights
  }

  double _getIngredientsTabHeight() {
    final ingredients =
        _mealData['ingredient'] ?? 'No ingredients information available';
    final textSpan = TextSpan(
      text: ingredients,
      style: TextStyle(
        color: Colors.grey[800],
        height: 1.5,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64);

    return textPainter.height + 180; // Add padding and other widget heights
  }

  double _getReviewsTabHeight() {
    return 100; // Minimum height for reviews tab
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 200,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _mealData['description'] ?? 'No description available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients & Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _mealData['ingredient'] ?? 'No ingredients information available',
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF98D8AA).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      size: 16,
                      color: Color(0xFF98D8AA),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _mealData['servingTime'] ?? '15-20 Min',
                      style: const TextStyle(
                        color: Color(0xFF98D8AA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_mealData['calories'] ?? '0'} Kcal',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Add reviews list here
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     spreadRadius: 1,
        //     blurRadius: 5,
        //     offset: const Offset(0, -3),
        //   ),
        // ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Add to meal logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to your meal'),
              backgroundColor: Color(0xFF98D8AA),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF98D8AA),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Add to my meal',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
