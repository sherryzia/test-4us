// lib/controllers/statistics_controller.dart (Updated)
import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final RxString selectedTimeFrame = '1W'.obs;
  
  // Time frame options
  final List<Map<String, String>> timeFrameOptions = [
    {'value': '1W', 'label': 'Last 7 Days'},
    {'value': '1M', 'label': 'Last Month'},
    {'value': '3M', 'label': 'Last 3 Months'},
    {'value': '6M', 'label': 'Last 6 Months'},
    {'value': '1Y', 'label': 'Last Year'},
    {'value': 'ALL', 'label': 'All Time'},
  ];
  
  void changeTimeFrame(String timeFrame) {
    selectedTimeFrame.value = timeFrame;
  }
  
  // Get current time frame label
  String get currentTimeFrameLabel {
    final option = timeFrameOptions.firstWhere(
      (option) => option['value'] == selectedTimeFrame.value,
      orElse: () => {'value': '1W', 'label': 'Last 7 Days'},
    );
    return option['label']!;
  }
  
  // Get chart data based on selected time frame
  List<double> get chartData {
    switch (selectedTimeFrame.value) {
      case '1W':
        return [0.3, 0.7, 0.5, 0.9, 0.6, 0.8, 1.0]; // 7 days
      case '1M':
        return [0.2, 0.4, 0.6, 0.3, 0.8, 0.5, 0.9, 0.7, 0.4, 0.6, 0.8, 1.0]; // 12 data points for month
      case '3M':
        return [0.3, 0.5, 0.7, 0.4, 0.8, 0.6, 0.9, 0.5, 0.7, 0.8, 0.6, 1.0]; // 12 weeks
      case '6M':
        return [0.4, 0.6, 0.5, 0.8, 0.7, 1.0]; // 6 months
      case '1Y':
        return [0.3, 0.4, 0.6, 0.5, 0.7, 0.8, 0.6, 0.9, 0.7, 0.8, 0.9, 1.0]; // 12 months
      case 'ALL':
        return [0.2, 0.4, 0.5, 0.7, 0.6, 0.8, 0.9, 1.0]; // All time data
      default:
        return [0.3, 0.7, 0.5, 0.9, 0.6, 0.8, 1.0];
    }
  }
  
  // Get chart labels based on selected time frame
  List<String> get chartLabels {
    switch (selectedTimeFrame.value) {
      case '1W':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case '1M':
        final now = DateTime.now();
        final List<String> labels = [];
        for (int i = 11; i >= 0; i--) {
          final date = DateTime(now.year, now.month, now.day - (i * 2.5).round());
          labels.add('${date.day}');
        }
        return labels;
      case '3M':
        final now = DateTime.now();
        final List<String> labels = [];
        for (int i = 11; i >= 0; i--) {
          final date = DateTime(now.year, now.month, now.day - (i * 7));
          labels.add('W${12 - i}');
        }
        return labels;
      case '6M':
        final now = DateTime.now();
        final List<String> labels = [];
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        for (int i = 5; i >= 0; i--) {
          final monthIndex = (now.month - 1 - i) % 12;
          labels.add(months[monthIndex < 0 ? monthIndex + 12 : monthIndex]);
        }
        return labels;
      case '1Y':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      case 'ALL':
        final currentYear = DateTime.now().year;
        return List.generate(8, (index) => '${currentYear - 7 + index}');
      default:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }
  }
  
  // Get Y-axis labels based on selected time frame
  List<String> get yAxisLabels {
    switch (selectedTimeFrame.value) {
      case '1W':
      case '1M':
        return ['500', '1K', '1.5K', '2K', '2.5K'];
      case '3M':
        return ['2K', '4K', '6K', '8K', '10K'];
      case '6M':
        return ['5K', '10K', '15K', '20K', '25K'];
      case '1Y':
        return ['10K', '20K', '30K', '40K', '50K'];
      case 'ALL':
        return ['50K', '100K', '150K', '200K', '250K'];
      default:
        return ['500', '1K', '1.5K', '2K', '2.5K'];
    }
  }
  
  // Calculate spending insights
  Map<String, dynamic> get spendingInsights {
    final data = chartData;
    if (data.isEmpty) return {};
    
    final currentPeriod = data.last;
    final previousPeriod = data.length > 1 ? data[data.length - 2] : 0.0;
    final average = data.reduce((a, b) => a + b) / data.length;
    final trend = currentPeriod > previousPeriod ? 'increasing' : 'decreasing';
    final changePercent = previousPeriod > 0 ? ((currentPeriod - previousPeriod) / previousPeriod * 100).abs() : 0.0;
    
    return {
      'trend': trend,
      'changePercent': changePercent,
      'isAboveAverage': currentPeriod > average,
      'averageSpending': average,
    };
  }
}