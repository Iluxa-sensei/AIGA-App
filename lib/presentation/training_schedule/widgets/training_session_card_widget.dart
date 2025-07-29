import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrainingSessionCardWidget extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback onTap;
  final VoidCallback onBook;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const TrainingSessionCardWidget({
    Key? key,
    required this.session,
    required this.onTap,
    required this.onBook,
    required this.onFavorite,
    required this.onShare,
  }) : super(key: key);

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'начинающий':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'средний':
        return AppTheme.warningLight;
      case 'продвинутый':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  IconData _getSessionTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'бжж':
        return Icons.sports_martial_arts;
      case 'грэпплинг':
        return Icons.sports_kabaddi;
      case 'мма':
        return Icons.sports_mma;
      case 'самбо':
        return Icons.sports;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(session['id'].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'book_online',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'favorite_border',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        // Handle quick actions
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getSessionTypeIcon(session['type'] as String),
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session['name'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            session['type'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color:
                            _getDifficultyColor(session['difficulty'] as String)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        session['difficulty'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getDifficultyColor(
                              session['difficulty'] as String),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 5.w,
                      backgroundImage:
                          NetworkImage(session['trainerPhoto'] as String),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session['trainerName'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                size: 14,
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${session['time']} • ${session['duration']} мин',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'people',
                          size: 16,
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${session['availableSpots']} мест',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      '${session['price']} ₸',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
