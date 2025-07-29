import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/qr_check_in/qr_check_in.dart';
import '../presentation/progress_tracking/progress_tracking.dart';
import '../presentation/athlete_dashboard/athlete_dashboard.dart';
import '../presentation/merchandise_store/merchandise_store.dart';
import '../presentation/training_schedule/training_schedule.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String qrCheckIn = '/qr-check-in';
  static const String progressTracking = '/progress-tracking';
  static const String athleteDashboard = '/athlete-dashboard';
  static const String merchandiseStore = '/merchandise-store';
  static const String trainingSchedule = '/training-schedule';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    qrCheckIn: (context) => QrCheckIn(),
    progressTracking: (context) => ProgressTracking(),
    athleteDashboard: (context) => AthleteDashboard(),
    merchandiseStore: (context) => MerchandiseStore(),
    trainingSchedule: (context) => TrainingSchedule(),
    // TODO: Add your other routes here
  };
}
