import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;
  final VoidCallback onClose;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
    required this.onClose,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(0, 50000);
  String _selectedSize = 'Все';
  String _selectedColor = 'Все';
  double _minRating = 0.0;
  String _sortBy = 'Популярность';

  final List<String> _sizes = ['Все', 'XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _colors = [
    'Все',
    'Черный',
    'Белый',
    'Красный',
    'Синий',
    'Серый'
  ];
  final List<String> _sortOptions = [
    'Популярность',
    'Цена: по возрастанию',
    'Цена: по убыванию',
    'Рейтинг',
    'Новинки'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] ?? 0).toDouble(),
      (_filters['maxPrice'] ?? 50000).toDouble(),
    );
    _selectedSize = _filters['size'] ?? 'Все';
    _selectedColor = _filters['color'] ?? 'Все';
    _minRating = (_filters['minRating'] ?? 0.0).toDouble();
    _sortBy = _filters['sortBy'] ?? 'Популярность';
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 50000);
      _selectedSize = 'Все';
      _selectedColor = 'Все';
      _minRating = 0.0;
      _sortBy = 'Популярность';
    });
  }

  void _applyFilters() {
    final filters = {
      'minPrice': _priceRange.start.toInt(),
      'maxPrice': _priceRange.end.toInt(),
      'size': _selectedSize,
      'color': _selectedColor,
      'minRating': _minRating,
      'sortBy': _sortBy,
    };
    widget.onFiltersApplied(filters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Фильтры',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text(
                        'Сбросить',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price range
                  Text(
                    'Цена',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 50000,
                    divisions: 100,
                    labels: RangeLabels(
                      '${_priceRange.start.toInt()} ₸',
                      '${_priceRange.end.toInt()} ₸',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_priceRange.start.toInt()} ₸',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${_priceRange.end.toInt()} ₸',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Size filter
                  Text(
                    'Размер',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _sizes.map((size) {
                      final isSelected = size == _selectedSize;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.surface,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            size,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onSecondary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Color filter
                  Text(
                    'Цвет',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _colors.map((color) {
                      final isSelected = color == _selectedColor;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.surface,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            color,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onSecondary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Rating filter
                  Text(
                    'Минимальный рейтинг',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Slider(
                    value: _minRating,
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    label: _minRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _minRating = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0.0',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      Text(
                        '5.0',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Sort by
                  Text(
                    'Сортировка',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Column(
                    children: _sortOptions.map((option) {
                      final isSelected = option == _sortBy;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortBy = option;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppTheme
                                          .lightTheme.colorScheme.secondary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Применить фильтры',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
