import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementsCarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentAchievements;
  final Function(Map<String, dynamic>) onAchievementTap;

  const AchievementsCarouselWidget({
    super.key,
    required this.recentAchievements,
    required this.onAchievementTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Недавние достижения',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          recentAchievements.isEmpty
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'emoji_events',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Пока нет достижений',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Продолжайте тренироваться!',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 16.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: recentAchievements.length,
                    separatorBuilder: (context, index) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      final achievement = recentAchievements[index];
                      return _buildAchievementCard(achievement);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final bool isNew = (achievement['isNew'] as bool? ?? false);

    return GestureDetector(
      onTap: () => onAchievementTap(achievement),
      child: Container(
        width: 60.w,
        height:18.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: isNew
              ? Border.all(
                  color: AppTheme.successLight.withValues(alpha: 0.3),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.successLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: achievement['icon'] as String,
                    color: AppTheme.successLight,
                    size: 24,
                  ),
                ),
                const Spacer(),
                if (isNew)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'НОВОЕ',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              achievement['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Text(
              achievement['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h), // фиксированная высота вместо Spacer
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'stars',
                  color: AppTheme.warningLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '+${achievement['xpReward']} XP',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.warningLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
