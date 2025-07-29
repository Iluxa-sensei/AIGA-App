import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activeFilters;
  final Function(String) onRemoveFilter;

  const FilterChipsWidget({
    Key? key,
    required this.activeFilters,
    required this.onRemoveFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: activeFilters.length,
        itemBuilder: (context, index) {
          final filter = activeFilters[index];
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter['label'] as String,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (filter['count'] != null) ...[
                    SizedBox(width: 1.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w,
                        vertical: 0.2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.onSecondary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        filter['count'].toString(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              onSelected: (bool selected) {},
              onDeleted: () => onRemoveFilter(filter['key'] as String),
              deleteIcon: CustomIconWidget(
                iconName: 'close',
                size: 16,
                color: AppTheme.lightTheme.colorScheme.onSecondary,
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          );
        },
      ),
    );
  }
}
