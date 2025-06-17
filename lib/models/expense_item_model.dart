// models/expense_item.dart
class ExpenseItem {
  final String title;
  final String date;
  final double amount;
  final String iconData;
  final String iconBg;
  
  ExpenseItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.iconData,
    required this.iconBg,
  });
  
  // Convert to JSON (for API calls)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'amount': amount,
      'iconData': iconData,
      'iconBg': iconBg,
    };
  }
  
  // Create from JSON (for API responses)
  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      iconData: json['iconData'] ?? 'shopping_bag',
      iconBg: json['iconBg'] ?? 'black',
    );
  }
  
  // Create a copy with modified fields
  ExpenseItem copyWith({
    String? title,
    String? date,
    double? amount,
    String? iconData,
    String? iconBg,
  }) {
    return ExpenseItem(
      title: title ?? this.title,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      iconData: iconData ?? this.iconData,
      iconBg: iconBg ?? this.iconBg,
    );
  }
}