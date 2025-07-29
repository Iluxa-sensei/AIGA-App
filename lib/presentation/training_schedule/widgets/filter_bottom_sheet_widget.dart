import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _sessionTypes = ['БЖЖ', 'Грэпплинг', 'ММА', 'Самбо'];
  final List<String> _trainers = [
    'Алексей Иванов',
    'Мария Петрова',
    'Дмитрий Сидоров',
    'Анна Козлова'
  ];
  final List<String> _timeSlots = [
    '06:00-08:00',
    '08:00-10:00',
    '10:00-12:00',
    '18:00-20:00',
    '20:00-22:00'
  ];
  final List<String> _locations = ['Зал 1', 'Зал 2', 'Зал 3'];
  final List<String> _difficulties = ['Начинающий', 'Средний', 'Продвинутый'];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required String filterKey,
    bool isMultiSelect = true,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: options.map((option) {
              final isSelected = isMultiSelect
                  ? (_filters[filterKey] as List<String>? ?? [])
                      .contains(option)
                  : _filters[filterKey] == option;

              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (isMultiSelect) {
                      final currentList =
                          _filters[filterKey] as List<String>? ?? [];
                      if (selected) {
                        _filters[filterKey] = [...currentList, option];
                      } else {
                        _filters[filterKey] = currentList
                            .where((item) => item != option)
                            .toList();
                      }
                    } else {
                      _filters[filterKey] = selected ? option : null;
                    }
                  });
                },
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                selectedColor: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.2),
                checkmarkColor: AppTheme.lightTheme.colorScheme.secondary,
                labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    final priceRange =
        _filters['priceRange'] as RangeValues? ?? const RangeValues(0, 10000);

    return ExpansionTile(
      title: Text(
        'Цена',
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${priceRange.start.round()} ₸',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${priceRange.end.round()} ₸',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              RangeSlider(
                values: priceRange,
                min: 0,
                max: 10000,
                divisions: 20,
                labels: RangeLabels(
                  '${priceRange.start.round()} ₸',
                  '${priceRange.end.round()} ₸',
                ),
                onChanged: (values) {
                  setState(() {
                    _filters['priceRange'] = values;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                    });
                  },
                  child: Text(
                    'Сбросить',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
                Text(
                  'Фильтры',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onApplyFilters(_filters);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Применить',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFilterSection(
                    title: 'Тип тренировки',
                    options: _sessionTypes,
                    filterKey: 'sessionTypes',
                  ),
                  _buildFilterSection(
                    title: 'Тренер',
                    options: _trainers,
                    filterKey: 'trainers',
                  ),
                  _buildFilterSection(
                    title: 'Время',
                    options: _timeSlots,
                    filterKey: 'timeSlots',
                  ),
                  _buildFilterSection(
                    title: 'Зал',
                    options: _locations,
                    filterKey: 'locations',
                  ),
                  _buildFilterSection(
                    title: 'Уровень сложности',
                    options: _difficulties,
                    filterKey: 'difficulties',
                  ),
                  _buildPriceRangeSection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
