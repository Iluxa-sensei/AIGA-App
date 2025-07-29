import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:aiga/presentation/merchandise_store/merchandise_store.dart';
import '../../core/app_export.dart';
import './widgets/achievements_carousel_widget.dart';
import './widgets/leaderboard_preview_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/todays_schedule_widget.dart';
import './widgets/weekly_challenge_widget.dart';
import './widgets/welcome_header_widget.dart';

class AthleteDashboard extends StatefulWidget {
  const AthleteDashboard({super.key});

  @override
  State<AthleteDashboard> createState() => _AthleteDashboardState();
}

class _AthleteDashboardState extends State<AthleteDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock data for athlete dashboard
  final Map<String, dynamic> athleteData = {
    "name": "Демеу Илияс",
    "rank": "Воин",
    "currentXP": 1250,
    "nextLevelXP": 2000,
    "totalXP": 8750,
    "currentStreak": 12,
    "nextBeltProgress": 0.65,
  };

  final List<Map<String, dynamic>> todaysSchedule = [
    {
      "id": 1,
      "time": "18:00",
      "type": "Грэпплинг",
      "trainer": "Иван Смирнов",
      "location": "Зал А",
      "status": "upcoming",
      "duration": 90,
    },
    {
      "id": 2,
      "time": "20:00",
      "type": "Спарринг",
      "trainer": "Мария Козлова",
      "location": "Зал Б",
      "status": "upcoming",
      "duration": 60,
    },
  ];

  final List<Map<String, dynamic>> recentAchievements = [
    {
      "id": 1,
      "title": "Первая победа",
      "description": "Выиграли первый спарринг",
      "icon": "emoji_events",
      "xpReward": 100,
      "isNew": true,
      "earnedDate": "2025-07-20",
    },
    {
      "id": 2,
      "title": "Постоянство",
      "description": "10 дней подряд тренировок",
      "icon": "local_fire_department",
      "xpReward": 50,
      "isNew": false,
      "earnedDate": "2025-07-18",
    },
    {
      "id": 3,
      "title": "Техника",
      "description": "Освоили новый прием",
      "icon": "sports_martial_arts",
      "xpReward": 75,
      "isNew": false,
      "earnedDate": "2025-07-15",
    },
  ];

  final Map<String, dynamic> weeklyChallenge = {
    "id": 1,
    "title": "Мастер посещаемости",
    "description": "Посетите 5 тренировок на этой неделе",
    "currentProgress": 3,
    "targetProgress": 5,
    "xpReward": 200,
    "daysLeft": 4,
    "type": "attendance",
  };

  final List<Map<String, dynamic>> topAthletes = [
    {
      "id": 1,
      "name": "Дмитрий Волков",
      "rank": "Легенда",
      "xp": 15420,
      "streak": 45,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 2,
      "name": "Анна Соколова",
      "rank": "Гладиатор",
      "xp": 12850,
      "streak": 32,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 3,
      "name": "Михаил Орлов",
      "rank": "Воин",
      "xp": 9750,
      "streak": 28,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _currentIndex == 0
          ? _buildDashboardContent()
          : _buildPlaceholderContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton:
          _currentIndex == 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.secondary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: WelcomeHeaderWidget(
              athleteName: athleteData['name'] as String,
              currentRank: athleteData['rank'] as String,
              currentXP: athleteData['currentXP'] as int,
              nextLevelXP: athleteData['nextLevelXP'] as int,
            ),
          ),
          SliverToBoxAdapter(
            child: QuickStatsWidget(
              upcomingSessions: todaysSchedule.length,
              currentStreak: athleteData['currentStreak'] as int,
              totalXP: athleteData['totalXP'] as int,
              nextBeltProgress: athleteData['nextBeltProgress'] as double,
            ),
          ),
          SliverToBoxAdapter(
            child: TodaysScheduleWidget(
              todaysSchedule: todaysSchedule,
              onViewAll: () => _navigateToSchedule(),
              onSessionTap: (session) => _handleSessionTap(session),
              onQuickCheckIn: (session) => _handleQuickCheckIn(session),
            ),
          ),
          SliverToBoxAdapter(
            child: AchievementsCarouselWidget(
              recentAchievements: recentAchievements,
              onAchievementTap: (achievement) =>
                  _handleAchievementTap(achievement),
            ),
          ),
          SliverToBoxAdapter(
            child: WeeklyChallengeWidget(
              weeklyChallenge: weeklyChallenge,
              onChallengeTap: () => _handleChallengeTap(),
            ),
          ),
          SliverToBoxAdapter(
            child: LeaderboardPreviewWidget(
              topAthletes: topAthletes,
              onViewAll: () => _handleViewLeaderboard(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    final List<String> tabNames = [
      'Расписание',
      'Прогресс',
      'Магазин',
      'Профиль'
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            '${tabNames[_currentIndex - 1]} в разработке',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Скоро будет доступно!',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      selectedItemColor: AppTheme.lightTheme.colorScheme.secondary,
      unselectedItemColor:
          AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: 8,

      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'schedule',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Расписание',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'trending_up',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Прогресс',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'store',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Магазин',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentIndex == 4
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Профиль',
        ),
      ],
    );
  }
  void _onBottomNavTap(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MerchandiseStore(),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _handleBookTraining(),
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
      elevation: 4,
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onSecondary,
        size: 24,
      ),
      label: Text(
        'Записаться',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Данные обновлены',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _navigateToSchedule() {
    Navigator.pushNamed(context, '/training-schedule');
  }

  void _handleSessionTap(Map<String, dynamic> session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Детали тренировки',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSessionDetail('Время', session['time'] as String),
            _buildSessionDetail('Тип', session['type'] as String),
            _buildSessionDetail('Тренер', session['trainer'] as String),
            _buildSessionDetail('Место', session['location'] as String),
            _buildSessionDetail('Длительность', '${session['duration']} мин'),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleQuickCheckIn(session);
                    },
                    child: const Text('Отметиться'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleQuickCheckIn(Map<String, dynamic> session) {
    Navigator.pushNamed(context, '/qr-check-in');
  }

  void _handleAchievementTap(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: achievement['icon'] as String,
                color: AppTheme.successLight,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                achievement['title'] as String,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'stars',
                    color: AppTheme.warningLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Получено +${achievement['xpReward']} XP',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.warningLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  void _handleChallengeTap() {
    Navigator.pushNamed(context, '/progress-tracking');
  }

  void _handleViewLeaderboard() {
    Navigator.pushNamed(context, '/progress-tracking');
  }

  void _handleBookTraining() {
    Navigator.pushNamed(context, '/training-schedule');
  }
}
