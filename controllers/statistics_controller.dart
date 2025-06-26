// lib/controllers/statistics_controller.dart - Fixed with Currency Conversion
import 'package:get/get.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:flutter/material.dart';

class StatisticsController extends GetxController {
  final RxString selectedTimeFrame = '1W'.obs;
  final RxBool isLoading = false.obs;
  final RxList<double> realChartData = <double>[].obs;
  final RxList<String> realChartLabels = <String>[].obs;
  final RxMap<String, dynamic> financialSummary = <String, dynamic>{}.obs;
  final RxString currentDisplayCurrency = 'PKR'.obs;
  
  // Time frame options
  final List<Map<String, String>> timeFrameOptions = [
    {'value': '1W', 'label': 'Last 7 Days'},
    {'value': '1M', 'label': 'Last Month'},
    {'value': '3M', 'label': 'Last 3 Months'},
    {'value': '6M', 'label': 'Last 6 Months'},
    {'value': '1Y', 'label': 'Last Year'},
    {'value': 'ALL', 'label': 'All Time'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadStatisticsData();
    
    // Listen to global controller currency changes
    ever(Get.find<GlobalController>().currentCurrency, (String newCurrency) {
      if (currentDisplayCurrency.value != newCurrency) {
        _convertDataToCurrency(currentDisplayCurrency.value, newCurrency);
        currentDisplayCurrency.value = newCurrency;
      }
    });
  }
  
  // Convert all statistical data when currency changes
  void _convertDataToCurrency(String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return;
    
    final globalController = Get.find<GlobalController>();
    
    // Convert financial summary amounts
    if (financialSummary.isNotEmpty) {
      final convertedSummary = <String, dynamic>{};
      
      financialSummary.forEach((key, value) {
        if (value is num && (key.contains('amount') || key.contains('spent') || key.contains('income'))) {
          convertedSummary[key] = globalController.convertCurrency(
            value.toDouble(), fromCurrency, toCurrency
          );
        } else {
          convertedSummary[key] = value;
        }
      });
      
      financialSummary.value = convertedSummary;
    }
    
    debugPrint('Converted statistics data from $fromCurrency to $toCurrency');
  }
  
  void changeTimeFrame(String timeFrame) {
    selectedTimeFrame.value = timeFrame;
    loadStatisticsData();
  }
  
  Future<void> loadStatisticsData() async {
    isLoading.value = true;
    
    try {
      final globalController = Get.find<GlobalController>();
      if (!globalController.isAuthenticated.value) return;
      
      currentDisplayCurrency.value = globalController.currentCurrency.value;
      
      final userId = globalController.userId;
      final dates = _getDateRange();
      
      // Get expenses for the selected period
      final expenses = await SupabaseService.getExpenses(
        userId: userId,
        startDate: dates['start'],
        endDate: dates['end'],
        includeRelations: false,
      );
      
      // Get financial summary
      final summary = await SupabaseService.getSpendingSummary(
        userId: userId,
        startDate: dates['start'],
        endDate: dates['end'],
      );
      
      financialSummary.value = summary;
      
      // Process data for chart
      _processChartData(expenses, dates);
      
    } catch (e) {
      debugPrint('Error loading statistics: $e');
      // Fallback to dummy data if error
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }
  
  Map<String, DateTime> _getDateRange() {
    final now = DateTime.now();
    DateTime start;
    DateTime end = now;
    
    switch (selectedTimeFrame.value) {
      case '1W':
        start = now.subtract(Duration(days: 7));
        break;
      case '1M':
        start = DateTime(now.year, now.month - 1, now.day);
        break;
      case '3M':
        start = DateTime(now.year, now.month - 3, now.day);
        break;
      case '6M':
        start = DateTime(now.year, now.month - 6, now.day);
        break;
      case '1Y':
        start = DateTime(now.year - 1, now.month, now.day);
        break;
      case 'ALL':
        start = DateTime(2020, 1, 1); // Start from 2020
        break;
      default:
        start = now.subtract(Duration(days: 7));
    }
    
    return {'start': start, 'end': end};
  }
  
  void _processChartData(List<Map<String, dynamic>> expenses, Map<String, DateTime> dates) {
    final start = dates['start']!;
    final end = dates['end']!;
    final timeFrame = selectedTimeFrame.value;
    
    // Create time periods based on timeframe
    List<DateTime> periods = _generatePeriods(start, end, timeFrame);
    List<String> labels = _generateLabels(periods, timeFrame);
    List<double> data = [];
    
    // Group expenses by period
    for (int i = 0; i < periods.length; i++) {
      DateTime periodStart = periods[i];
      DateTime periodEnd;
      
      if (i < periods.length - 1) {
        periodEnd = periods[i + 1];
      } else {
        periodEnd = end;
      }
      
      // Sum expenses for this period
      double periodTotal = 0;
      for (var expense in expenses) {
        try {
          DateTime expenseDate = DateTime.parse(expense['expense_date']);
          if (expenseDate.isAfter(periodStart.subtract(Duration(days: 1))) && 
              expenseDate.isBefore(periodEnd.add(Duration(days: 1)))) {
            double amount = (expense['amount'] as num).toDouble();
            if (amount < 0) { // Only count expenses (negative amounts)
              periodTotal += amount.abs();
            }
          }
        } catch (e) {
          debugPrint('Error parsing expense date: $e');
        }
      }
      
      data.add(periodTotal);
    }
    
    // Normalize data for chart (0.0 to 1.0)
    if (data.isNotEmpty) {
      double maxValue = data.reduce((a, b) => a > b ? a : b);
      if (maxValue > 0) {
        realChartData.value = data.map((value) => value / maxValue).toList();
      } else {
        realChartData.value = List.filled(data.length, 0.0);
      }
    } else {
      realChartData.value = [0.0];
    }
    
    realChartLabels.value = labels;
  }
  
  List<DateTime> _generatePeriods(DateTime start, DateTime end, String timeFrame) {
    List<DateTime> periods = [];
    
    switch (timeFrame) {
      case '1W':
        // Daily periods for last 7 days
        for (int i = 6; i >= 0; i--) {
          periods.add(end.subtract(Duration(days: i)));
        }
        break;
      case '1M':
        // Weekly periods for last month
        for (int i = 3; i >= 0; i--) {
          periods.add(end.subtract(Duration(days: i * 7)));
        }
        break;
      case '3M':
        // Monthly periods for last 3 months
        for (int i = 2; i >= 0; i--) {
          periods.add(DateTime(end.year, end.month - i, 1));
        }
        break;
      case '6M':
        // Monthly periods for last 6 months
        for (int i = 5; i >= 0; i--) {
          periods.add(DateTime(end.year, end.month - i, 1));
        }
        break;
      case '1Y':
        // Monthly periods for last 12 months
        for (int i = 11; i >= 0; i--) {
          periods.add(DateTime(end.year, end.month - i, 1));
        }
        break;
      case 'ALL':
        // Yearly periods
        int startYear = start.year;
        int endYear = end.year;
        for (int year = startYear; year <= endYear; year++) {
          periods.add(DateTime(year, 1, 1));
        }
        break;
    }
    
    return periods;
  }
  
  List<String> _generateLabels(List<DateTime> periods, String timeFrame) {
    List<String> labels = [];
    
    switch (timeFrame) {
      case '1W':
        // Day names
        const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        for (DateTime period in periods) {
          labels.add(dayNames[period.weekday - 1]);
        }
        break;
      case '1M':
        // Week numbers
        for (int i = 0; i < periods.length; i++) {
          labels.add('W${i + 1}');
        }
        break;
      case '3M':
      case '6M':
      case '1Y':
        // Month names
        const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        for (DateTime period in periods) {
          labels.add(monthNames[period.month - 1]);
        }
        break;
      case 'ALL':
        // Years
        for (DateTime period in periods) {
          labels.add(period.year.toString());
        }
        break;
    }
    
    return labels;
  }
  
  void _loadFallbackData() {
    // Fallback to static data if API fails
    realChartData.value = _getFallbackChartData();
    realChartLabels.value = _getFallbackChartLabels();
  }
  
  List<double> _getFallbackChartData() {
    switch (selectedTimeFrame.value) {
      case '1W':
        return [0.3, 0.7, 0.5, 0.9, 0.6, 0.8, 1.0];
      case '1M':
        return [0.2, 0.4, 0.6, 0.3, 0.8, 0.5, 0.9, 0.7, 0.4, 0.6, 0.8, 1.0];
      case '3M':
        return [0.3, 0.5, 0.7, 0.4, 0.8, 0.6, 0.9, 0.5, 0.7, 0.8, 0.6, 1.0];
      case '6M':
        return [0.4, 0.6, 0.5, 0.8, 0.7, 1.0];
      case '1Y':
        return [0.3, 0.4, 0.6, 0.5, 0.7, 0.8, 0.6, 0.9, 0.7, 0.8, 0.9, 1.0];
      case 'ALL':
        return [0.2, 0.4, 0.5, 0.7, 0.6, 0.8, 0.9, 1.0];
      default:
        return [0.3, 0.7, 0.5, 0.9, 0.6, 0.8, 1.0];
    }
  }
  
  List<String> _getFallbackChartLabels() {
    switch (selectedTimeFrame.value) {
      case '1W':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case '1M':
        return ['W1', 'W2', 'W3', 'W4'];
      case '3M':
      case '6M':
      case '1Y':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      case 'ALL':
        final currentYear = DateTime.now().year;
        return List.generate(5, (index) => '${currentYear - 4 + index}');
      default:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }
  }
  
  // Get current time frame label
  String get currentTimeFrameLabel {
    final option = timeFrameOptions.firstWhere(
      (option) => option['value'] == selectedTimeFrame.value,
      orElse: () => {'value': '1W', 'label': 'Last 7 Days'},
    );
    return option['label']!;
  }
  
  // Get chart data (real or fallback)
  List<double> get chartData {
    return realChartData.isNotEmpty ? realChartData : _getFallbackChartData();
  }
  
  // Get chart labels (real or fallback)
  List<String> get chartLabels {
    return realChartLabels.isNotEmpty ? realChartLabels : _getFallbackChartLabels();
  }
  
  List<String> get yAxisLabels {
    final globalController = Get.find<GlobalController>();
    
    if (financialSummary.isNotEmpty) {
      double maxSpending = (financialSummary['total_spent'] ?? 0).toDouble();
      if (maxSpending > 0) {
        double step = maxSpending / 5;
        return List.generate(5, (index) => 
          globalController.formatCurrency((index + 1) * step)
        );
      }
    }
    
    // Fallback labels with current currency
    String currencySymbol = globalController.getCurrencySymbol(null);
    
    switch (selectedTimeFrame.value) {
      case '1W':
      case '1M':
        return ['${currencySymbol}500', '${currencySymbol}1K', '${currencySymbol}1.5K', '${currencySymbol}2K', '${currencySymbol}2.5K'];
      case '3M':
        return ['${currencySymbol}2K', '${currencySymbol}4K', '${currencySymbol}6K', '${currencySymbol}8K', '${currencySymbol}10K'];
      case '6M':
        return ['${currencySymbol}5K', '${currencySymbol}10K', '${currencySymbol}15K', '${currencySymbol}20K', '${currencySymbol}25K'];
      case '1Y':
        return ['${currencySymbol}10K', '${currencySymbol}20K', '${currencySymbol}30K', '${currencySymbol}40K', '${currencySymbol}50K'];
      case 'ALL':
        return ['${currencySymbol}50K', '${currencySymbol}100K', '${currencySymbol}150K', '${currencySymbol}200K', '${currencySymbol}250K'];
      default:
        return ['${currencySymbol}500', '${currencySymbol}1K', '${currencySymbol}1.5K', '${currencySymbol}2K', '${currencySymbol}2.5K'];
    }
  }
  
  // Calculate spending insights based on real data
  Map<String, dynamic> get spendingInsights {
    if (financialSummary.isEmpty || chartData.isEmpty) {
      return {
        'trend': 'stable',
        'changePercent': 0.0,
        'isAboveAverage': false,
        'averageSpending': 0.0,
      };
    }
    
    final data = chartData;
    final currentPeriod = data.last;
    final previousPeriod = data.length > 1 ? data[data.length - 2] : 0.0;
    final average = data.reduce((a, b) => a + b) / data.length;
    final trend = currentPeriod > previousPeriod ? 'increasing' : 'decreasing';
    final changePercent = previousPeriod > 0 ? 
        ((currentPeriod - previousPeriod) / previousPeriod * 100).abs() : 0.0;
    
    return {
      'trend': trend,
      'changePercent': changePercent,
      'isAboveAverage': currentPeriod > average,
      'averageSpending': average,
      'totalSpent': financialSummary['total_spent'] ?? 0,
      'transactionCount': financialSummary['transaction_count'] ?? 0,
    };
  }
  
  // Refresh data
  Future<void> refreshData() async {
    await loadStatisticsData();
  }
}