import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_bottom_sheet_widget.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/date_selector_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/training_session_card_widget.dart';

class TrainingSchedule extends StatefulWidget {
  const TrainingSchedule({Key? key}) : super(key: key);

  @override
  State<TrainingSchedule> createState() => _TrainingScheduleState();
}

class _TrainingScheduleState extends State<TrainingSchedule>
    with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarView = false;
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _filteredSessions = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock training sessions data
  final List<Map<String, dynamic>> _allSessions = [
    {
      "id": 1,
      "name": "Основы БЖЖ",
      "type": "БЖЖ",
      "trainerName": "Алексей Иванов",
      "trainerPhoto":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "time": "08:00",
      "duration": 90,
      "availableSpots": 8,
      "price": 3500,
      "difficulty": "Начинающий",
      "date": "2025-07-22",
      "location": "Зал 1",
      "description":
          "Изучение базовых позиций и переходов в бразильском джиу-джитсу"
    },
    {
      "id": 2,
      "name": "Грэпплинг для продвинутых",
      "type": "Грэпплинг",
      "trainerName": "Мария Петрова",
      "trainerPhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "time": "10:00",
      "duration": 120,
      "availableSpots": 5,
      "price": 4500,
      "difficulty": "Продвинутый",
      "date": "2025-07-22",
      "location": "Зал 2",
      "description":
          "Сложные техники борьбы в партере и работа с сопротивлением"
    },
    {
      "id": 3,
      "name": "ММА базовый курс",
      "type": "ММА",
      "trainerName": "Дмитрий Сидоров",
      "trainerPhoto":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "time": "18:00",
      "duration": 90,
      "availableSpots": 12,
      "price": 4000,
      "difficulty": "Средний",
      "date": "2025-07-22",
      "location": "Зал 1",
      "description": "Комплексная подготовка: ударная техника, борьба, партер"
    },
    {
      "id": 4,
      "name": "Самбо для начинающих",
      "type": "Самбо",
      "trainerName": "Анна Козлова",
      "trainerPhoto":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "time": "20:00",
      "duration": 90,
      "availableSpots": 10,
      "price": 3000,
      "difficulty": "Начинающий",
      "date": "2025-07-22",
      "location": "Зал 3",
      "description": "Основы самбо: броски, болевые приемы, самооборона"
    },
    {
      "id": 5,
      "name": "БЖЖ спарринг",
      "type": "БЖЖ",
      "trainerName": "Алексей Иванов",
      "trainerPhoto":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "time": "19:00",
      "duration": 60,
      "availableSpots": 6,
      "price": 2500,
      "difficulty": "Средний",
      "date": "2025-07-23",
      "location": "Зал 1",
      "description": "Практические поединки с применением изученных техник"
    },
    {
      "id": 6,
      "name": "Женское самбо",
      "type": "Самбо",
      "trainerName": "Мария Петрова",
      "trainerPhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "time": "17:00",
      "duration": 75,
      "availableSpots": 8,
      "price": 3200,
      "difficulty": "Начинающий",
      "date": "2025-07-23",
      "location": "Зал 2",
      "description": "Специализированная программа самбо для женщин"
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredSessions = List.from(_allSessions);
    _filterSessionsByDate();
  }

  void _filterSessionsByDate() {
    final dateString =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    setState(() {
      _filteredSessions = _allSessions.where((session) {
        bool matchesDate = session['date'] == dateString;
        bool matchesSearch = _searchQuery.isEmpty ||
            (session['name'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (session['trainerName'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (session['type'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        bool matchesFilters = true;
        if (_activeFilters.isNotEmpty) {
          if (_activeFilters['sessionTypes'] != null) {
            final sessionTypes = _activeFilters['sessionTypes'] as List<String>;
            if (sessionTypes.isNotEmpty &&
                !sessionTypes.contains(session['type'])) {
              matchesFilters = false;
            }
          }
          if (_activeFilters['trainers'] != null) {
            final trainers = _activeFilters['trainers'] as List<String>;
            if (trainers.isNotEmpty &&
                !trainers.contains(session['trainerName'])) {
              matchesFilters = false;
            }
          }
          if (_activeFilters['difficulties'] != null) {
            final difficulties = _activeFilters['difficulties'] as List<String>;
            if (difficulties.isNotEmpty &&
                !difficulties.contains(session['difficulty'])) {
              matchesFilters = false;
            }
          }
          if (_activeFilters['priceRange'] != null) {
            final priceRange = _activeFilters['priceRange'] as RangeValues;
            final sessionPrice = session['price'] as int;
            if (sessionPrice < priceRange.start ||
                sessionPrice > priceRange.end) {
              matchesFilters = false;
            }
          }
        }

        return matchesDate && matchesSearch && matchesFilters;
      }).toList();
    });
  }

  List<Map<String, dynamic>> _getActiveFiltersList() {
    List<Map<String, dynamic>> filters = [];

    if (_activeFilters['sessionTypes'] != null) {
      final sessionTypes = _activeFilters['sessionTypes'] as List<String>;
      for (String type in sessionTypes) {
        filters.add({
          'key': 'sessionType_$type',
          'label': type,
          'count': null,
        });
      }
    }

    if (_activeFilters['trainers'] != null) {
      final trainers = _activeFilters['trainers'] as List<String>;
      for (String trainer in trainers) {
        filters.add({
          'key': 'trainer_$trainer',
          'label': trainer,
          'count': null,
        });
      }
    }

    if (_activeFilters['difficulties'] != null) {
      final difficulties = _activeFilters['difficulties'] as List<String>;
      for (String difficulty in difficulties) {
        filters.add({
          'key': 'difficulty_$difficulty',
          'label': difficulty,
          'count': null,
        });
      }
    }

    return filters;
  }

  void _removeFilter(String filterKey) {
    setState(() {
      if (filterKey.startsWith('sessionType_')) {
        final type = filterKey.substring('sessionType_'.length);
        final sessionTypes =
            _activeFilters['sessionTypes'] as List<String>? ?? [];
        sessionTypes.remove(type);
        if (sessionTypes.isEmpty) {
          _activeFilters.remove('sessionTypes');
        } else {
          _activeFilters['sessionTypes'] = sessionTypes;
        }
      } else if (filterKey.startsWith('trainer_')) {
        final trainer = filterKey.substring('trainer_'.length);
        final trainers = _activeFilters['trainers'] as List<String>? ?? [];
        trainers.remove(trainer);
        if (trainers.isEmpty) {
          _activeFilters.remove('trainers');
        } else {
          _activeFilters['trainers'] = trainers;
        }
      } else if (filterKey.startsWith('difficulty_')) {
        final difficulty = filterKey.substring('difficulty_'.length);
        final difficulties =
            _activeFilters['difficulties'] as List<String>? ?? [];
        difficulties.remove(difficulty);
        if (difficulties.isEmpty) {
          _activeFilters.remove('difficulties');
        } else {
          _activeFilters['difficulties'] = difficulties;
        }
      }
    });
    _filterSessionsByDate();
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = Map<String, dynamic>.from(filters);
    });
    _filterSessionsByDate();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    _filterSessionsByDate();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onApplyFilters: _applyFilters,
      ),
    );
  }

  void _showBookingBottomSheet(Map<String, dynamic> session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingBottomSheetWidget(
        session: session,
        onBookingConfirmed: () {
          // Handle booking confirmation
          _filterSessionsByDate();
        },
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
        _filterSessionsByDate();
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterSessionsByDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Поиск тренировок...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text('Расписание тренировок'),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          if (!_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isCalendarView = !_isCalendarView;
                });
              },
              icon: CustomIconWidget(
                iconName: _isCalendarView ? 'view_list' : 'calendar_month',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_isCalendarView && !_isSearching) ...[
            DateSelectorWidget(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
                _filterSessionsByDate();
              },
            ),
            FilterChipsWidget(
              activeFilters: _getActiveFiltersList(),
              onRemoveFilter: _removeFilter,
            ),
          ],
          Expanded(
            child: _isCalendarView
                ? CalendarViewWidget(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                      _filterSessionsByDate();
                    },
                    sessions: _allSessions,
                    onSessionTap: _showBookingBottomSheet,
                  )
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                            ),
                          )
                        : _filteredSessions.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.only(bottom: 10.h),
                                itemCount: _filteredSessions.length,
                                itemBuilder: (context, index) {
                                  final session = _filteredSessions[index];
                                  return TrainingSessionCardWidget(
                                    session: session,
                                    onTap: () =>
                                        _showBookingBottomSheet(session),
                                    onBook: () =>
                                        _showBookingBottomSheet(session),
                                    onFavorite: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Добавлено в избранное'),
                                          backgroundColor: AppTheme
                                              .lightTheme.colorScheme.tertiary,
                                        ),
                                      );
                                    },
                                    onShare: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Тренировка отправлена'),
                                          backgroundColor: AppTheme
                                              .lightTheme.colorScheme.primary,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                  ),
          ),
        ],
      ),
      floatingActionButton: !_isCalendarView
          ? FloatingActionButton(
              onPressed: _showFilterBottomSheet,
              child: CustomIconWidget(
                iconName: 'filter_list',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onSecondary,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/login-screen');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/athlete-dashboard');
              break;
            case 2:
              // Current screen
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/progress-tracking');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/merchandise-store');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'login',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'login',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            ),
            label: 'Вход',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'schedule',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            ),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'trending_up',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            ),
            label: 'Прогресс',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'store',
              size: 24,
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            ),
            label: 'Магазин',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'event_busy',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
            ),
            SizedBox(height: 3.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Тренировки не найдены'
                  : 'Нет тренировок на выбранную дату',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Попробуйте изменить поисковый запрос'
                  : 'Выберите другую дату или просмотрите все доступные тренировки',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                if (_searchQuery.isNotEmpty) {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                    _isSearching = false;
                  });
                } else {
                  setState(() {
                    _selectedDate = DateTime.now();
                    _activeFilters.clear();
                  });
                }
                _filterSessionsByDate();
              },
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'Очистить поиск'
                    : 'Показать все тренировки',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
