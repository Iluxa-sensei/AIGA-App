import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LeaderboardPreviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> topAthletes;
  final VoidCallback onViewAll;

  const LeaderboardPreviewWidget({
    super.key,
    required this.topAthletes,
    required this.onViewAll,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Топ спортсмены',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'Все рейтинги',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (topAthletes.isNotEmpty) ...[
                  for (int i = 0; i < topAthletes.length && i < 3; i++)
                    _buildLeaderboardItem(topAthletes[i], i + 1),
                ] else
                  Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'leaderboard',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Рейтинг пока пуст',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Станьте первым!',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
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

  Widget _buildLeaderboardItem(Map<String, dynamic> athlete, int position) {
    Color positionColor;
    String positionIcon;

    switch (position) {
      case 1:
        positionColor = AppTheme.warningLight;
        positionIcon = 'emoji_events';
        break;
      case 2:
        positionColor =
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7);
        positionIcon = 'workspace_premium';
        break;
      case 3:
        positionColor =
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
        positionIcon = 'military_tech';
        break;
      default:
        positionColor =
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3);
        positionIcon = 'person';
    }

    return Container(
      margin: EdgeInsets.only(bottom: position < 3 ? 2.h : 0),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: positionColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: position <= 3
                  ? CustomIconWidget(
                      iconName: positionIcon,
                      color: positionColor,
                      size: 24,
                    )
                  : Text(
                      position.toString(),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: positionColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: athlete['avatar'] as String,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  athlete['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        athlete['rank'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'stars',
                      color: AppTheme.warningLight,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${athlete['xp']} XP',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#$position',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: positionColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${athlete['streak']} дн.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
