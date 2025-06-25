// lib/models/expense_item_model.dart
class ExpenseItem {
  final String title;
  final String date;
  final double amount;
  final String iconData;
  final String iconBg;
  final String category; // Add this field
  
  ExpenseItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.iconData,
    required this.iconBg,
    this.category = 'Other', // Default category
  });
  
  // Update toJson method
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'amount': amount,
      'iconData': iconData,
      'iconBg': iconBg,
      'category': category,
    };
  }
  
  // Update fromJson factory
  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      iconData: json['iconData'] ?? 'shopping_bag',
      iconBg: json['iconBg'] ?? 'black',
      category: json['category'] ?? 'Other',
    );
  }
  
  // Update copyWith method
  ExpenseItem copyWith({
    String? title,
    String? date,
    double? amount,
    String? iconData,
    String? iconBg,
    String? category,
  }) {
    return ExpenseItem(
      title: title ?? this.title,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      iconData: iconData ?? this.iconData,
      iconBg: iconBg ?? this.iconBg,
      category: category ?? this.category,
    );
  }
}