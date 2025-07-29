import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BeltProgressionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> beltData;
  final int currentBeltIndex;

  const BeltProgressionWidget({
    super.key,
    required this.beltData,
    required this.currentBeltIndex,
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
            'Прогресс поясов',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: beltData.length,
              itemBuilder: (context, index) {
                final belt = beltData[index];
                final isCurrentBelt = index == currentBeltIndex;
                final isEarned = index <= currentBeltIndex;

                return Container(
                  margin: EdgeInsets.only(right: 3.w),
                  child: Column(
                    children: [
                      Container(
                        width: 15.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: isEarned
                              ? Color(belt['color'] as int)
                              : Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: isCurrentBelt
                              ? Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  width: 3,
                                )
                              : null,
                          boxShadow: isEarned
                              ? [
                                  BoxShadow(
                                    color: Color(belt['color'] as int)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isEarned
                            ? Center(
                                child: CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 6.w,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        width: 15.w,
                        child: Text(
                          belt['name'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: isCurrentBelt
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCurrentBelt
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (currentBeltIndex < beltData.length - 1) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Требования для следующего пояса:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    beltData[currentBeltIndex + 1]['requirements'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
