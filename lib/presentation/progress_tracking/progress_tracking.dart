import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_grid_widget.dart';
import './widgets/attendance_chart_widget.dart';
import './widgets/belt_progression_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/progress_photos_widget.dart';
import './widgets/rank_progress_widget.dart';
import './widgets/tournament_timeline_widget.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for progress tracking
  final Map<String, dynamic> _userData = {
    "currentRank": "Воин",
    "currentXP": 1250,
    "nextLevelXP": 2000,
    "totalTrainingHours": 156,
    "attendanceStreak": 12,
    "monthlyXP": 450,
    "nextBeltExam": "Доступен",
  };

  final List<Map<String, dynamic>> _attendanceData = [
    {"day": "Понедельник", "sessions": 2},
    {"day": "Вторник", "sessions": 1},
    {"day": "Среда", "sessions": 3},
    {"day": "Четверг", "sessions": 2},
    {"day": "Пятница", "sessions": 1},
    {"day": "Суббота", "sessions": 4},
    {"day": "Воскресенье", "sessions": 0},
  ];

  final List<Map<String, dynamic>> _beltData = [
    {"name": "Белый", "color": 0xFFFFFFFF, "earned": true},
    {"name": "Синий", "color": 0xFF2196F3, "earned": true},
    {"name": "Фиолетовый", "color": 0xFF9C27B0, "earned": true},
    {"name": "Коричневый", "color": 0xFF795548, "earned": false},
    {"name": "Черный", "color": 0xFF000000, "earned": false},
    {
      "name": "requirements",
      "requirements":
          "80 часов тренировок, сдача экзамена, участие в 2 турнирах"
    },
  ];

  final List<Map<String, dynamic>> _tournaments = [
    {
      "name": "Чемпионат Алматы по грэпплингу",
      "date": "15 июня 2024",
      "result": "Победа",
      "xp": 100,
    },
    {
      "name": "Открытый турнир AIGA",
      "date": "22 мая 2024",
      "result": "2 место",
      "xp": 75,
    },
    {
      "name": "Региональные соревнования",
      "date": "10 апреля 2024",
      "result": "Участие",
      "xp": 25,
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {"name": "Первая победа", "icon": "emoji_events", "earned": true},
    {"name": "100 тренировок", "icon": "fitness_center", "earned": true},
    {"name": "Месяц без пропусков", "icon": "calendar_today", "earned": true},
    {"name": "Наставник", "icon": "school", "earned": false},
    {"name": "Турнирный боец", "icon": "sports_martial_arts", "earned": true},
    {"name": "Железная воля", "icon": "psychology", "earned": false},
    {"name": "Командный игрок", "icon": "group", "earned": true},
    {"name": "Мастер техники", "icon": "star", "earned": false},
  ];

  final List<Map<String, dynamic>> _progressPhotos = [
    {
      "url":
          "https://images.pexels.com/photos/4761663/pexels-photo-4761663.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "date": "1 января 2024",
      "description": "Начало пути",
    },
    {
      "url":
          "https://images.pexels.com/photos/4761792/pexels-photo-4761792.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "date": "1 марта 2024",
      "description": "Через 2 месяца",
    },
    {
      "url":
          "https://images.pexels.com/photos/4761665/pexels-photo-4761665.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "date": "1 июня 2024",
      "description": "Полгода тренировок",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onMetricTap(String metricType) {
    Navigator.pushNamed(context, '/athlete-dashboard');
  }

  void _onAchievementTap(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: achievement['icon'] as String,
              color: achievement['earned'] as bool
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : Colors.grey,
              size: 8.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                achievement['name'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          achievement['earned'] as bool
              ? 'Поздравляем! Вы получили это достижение.'
              : 'Продолжайте тренироваться, чтобы получить это достижение.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _addProgressPhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Добавить фото прогресса',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(
                  'Камера',
                  'camera_alt',
                  () => _takePhoto(),
                ),
                _buildPhotoOption(
                  'Галерея',
                  'photo_library',
                  () => _selectFromGallery(),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption(String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.primaryColor,
                size: 8.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _takePhoto() {
    Navigator.pop(context);
    // Real camera implementation would go here
    print('Taking photo with camera');
  }

  void _selectFromGallery() {
    Navigator.pop(context);
    // Real gallery selection would go here
    print('Selecting photo from gallery');
  }

  void _exportProgressReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Экспорт отчета',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Создать PDF отчет с вашим прогрессом?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generatePDFReport();
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _generatePDFReport() {
    // Real PDF generation would go here
    print('Generating PDF progress report');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Отчет создан и сохранен'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressPercentage =
        ((_userData['currentXP'] as int) / (_userData['nextLevelXP'] as int)) *
            100;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Прогресс',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _exportProgressReport,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.tabBarTheme.labelColor,
          unselectedLabelColor:
              AppTheme.lightTheme.tabBarTheme.unselectedLabelColor,
          indicatorColor: AppTheme.lightTheme.tabBarTheme.indicatorColor,
          labelStyle: AppTheme.lightTheme.tabBarTheme.labelStyle,
          unselectedLabelStyle:
              AppTheme.lightTheme.tabBarTheme.unselectedLabelStyle,
          tabs: const [
            Tab(text: 'Обзор'),
            Tab(text: 'Пояса'),
            Tab(text: 'Турниры'),
            Tab(text: 'Достижения'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.colorScheme.secondary,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(progressPercentage),
            _buildBeltsTab(),
            _buildTournamentsTab(),
            _buildAchievementsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(double progressPercentage) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          RankProgressWidget(
            currentRank: _userData['currentRank'] as String,
            currentXP: _userData['currentXP'] as int,
            nextLevelXP: _userData['nextLevelXP'] as int,
            progressPercentage: progressPercentage,
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: MetricsCardWidget(
                  title: 'Часы тренировок',
                  value: '${_userData['totalTrainingHours']}',
                  subtitle: 'Всего за год',
                  iconName: 'schedule',
                  onTap: () => _onMetricTap('training_hours'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: MetricsCardWidget(
                  title: 'Серия посещений',
                  value: '${_userData['attendanceStreak']}',
                  subtitle: 'Дней подряд',
                  iconName: 'local_fire_department',
                  cardColor:
                      AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                  onTap: () => _onMetricTap('attendance_streak'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: MetricsCardWidget(
                  title: 'XP за месяц',
                  value: '${_userData['monthlyXP']}',
                  subtitle: 'Опыт получен',
                  iconName: 'trending_up',
                  onTap: () => _onMetricTap('monthly_xp'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: MetricsCardWidget(
                  title: 'Экзамен на пояс',
                  value: _userData['nextBeltExam'] as String,
                  subtitle: 'Статус',
                  iconName: 'school',
                  cardColor:
                      AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                  onTap: () => _onMetricTap('belt_exam'),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          AttendanceChartWidget(attendanceData: _attendanceData),
          SizedBox(height: 3.h),
          ProgressPhotosWidget(
            photos: _progressPhotos,
            onAddPhoto: _addProgressPhoto,
          ),
        ],
      ),
    );
  }

  Widget _buildBeltsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          BeltProgressionWidget(
            beltData: _beltData,
            currentBeltIndex: 2, // Currently at Purple belt
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'История поясов',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildBeltHistoryItem(
                    'Белый пояс', '15 января 2022', 'Начало пути'),
                _buildBeltHistoryItem(
                    'Синий пояс', '20 августа 2022', '8 месяцев тренировок'),
                _buildBeltHistoryItem('Фиолетовый пояс', '10 марта 2024',
                    '1.5 года упорной работы'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeltHistoryItem(String belt, String date, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  belt,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          TournamentTimelineWidget(tournaments: _tournaments),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Статистика турниров',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child:
                          _buildStatItem('Участий', '3', 'sports_martial_arts'),
                    ),
                    Expanded(
                      child: _buildStatItem('Побед', '1', 'emoji_events'),
                    ),
                    Expanded(
                      child:
                          _buildStatItem('Призовых мест', '2', 'military_tech'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.primaryColor,
          size: 8.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AchievementGridWidget(
            achievements: _achievements,
            onAchievementTap: _onAchievementTap,
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Прогресс достижений',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                LinearProgressIndicator(
                  value:
                      (_achievements.where((a) => a['earned'] as bool).length /
                          _achievements.length),
                  backgroundColor: AppTheme.lightTheme.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${_achievements.where((a) => a['earned'] as bool).length} из ${_achievements.length} достижений получено',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
