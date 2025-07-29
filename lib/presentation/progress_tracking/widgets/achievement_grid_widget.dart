import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;
  final Function(Map<String, dynamic>) onAchievementTap;

  const AchievementGridWidget({
    super.key,
    required this.achievements,
    required this.onAchievementTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Достижения',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.8,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              final isEarned = achievement['earned'] as bool;

              return GestureDetector(
                onTap: () => onAchievementTap(achievement),
                onLongPress: isEarned
                    ? () => _showShareOptions(context, achievement)
                    : null,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: isEarned
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : Colors.grey.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        boxShadow: isEarned
                            ? [
                                BoxShadow(
                                  color: AppTheme
                                      .lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: achievement['icon'] as String,
                          color: isEarned ? Colors.white : Colors.grey,
                          size: 6.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      achievement['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight:
                            isEarned ? FontWeight.w500 : FontWeight.normal,
                        color: isEarned
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showShareOptions(
      BuildContext context, Map<String, dynamic> achievement) {
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
              'Поделиться достижением',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  context,
                  'Telegram',
                  'telegram',
                  () => _shareToSocial('telegram', achievement),
                ),
                _buildShareOption(
                  context,
                  'WhatsApp',
                  'whatsapp',
                  () => _shareToSocial('whatsapp', achievement),
                ),
                _buildShareOption(
                  context,
                  'Instagram',
                  'camera_alt',
                  () => _shareToSocial('instagram', achievement),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
      BuildContext context, String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _shareToSocial(String platform, Map<String, dynamic> achievement) {
    // Real sharing implementation would go here
    // For now, we'll show a toast message
    print('Sharing ${achievement['name']} to $platform');
  }
}
