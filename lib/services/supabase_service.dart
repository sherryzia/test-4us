// lib/config/supabase_config.dart

import 'package:expensary/configs/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = SupabaseConfig.client;
  
  // Auth methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }
  
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  static Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
  
  static Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    return await _client.auth.updateUser(
      UserAttributes(
        email: email,
        password: password,
        data: data,
      ),
    );
  }
  
  // User profile methods
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }
  
  static Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _client
        .from('users')
        .update(data)
        .eq('id', userId);
  }
  
  // Categories methods
  static Future<List<Map<String, dynamic>>> getCategories(String? userId) async {
    var query = _client.from('categories').select();
    
    if (userId != null) {
      query = query.or('is_default.eq.true,user_id.eq.$userId');
    } else {
      query = query.eq('is_default', true);
    }
    
    return await query.order('name');
  }
  
  static Future<void> createCategory(Map<String, dynamic> category) async {
    await _client.from('categories').insert(category);
  }
  
  // Payment methods
  static Future<List<Map<String, dynamic>>> getPaymentMethods(String? userId) async {
    var query = _client.from('payment_methods').select();
    
    if (userId != null) {
      query = query.or('is_default.eq.true,user_id.eq.$userId');
    } else {
      query = query.eq('is_default', true);
    }
    
    return await query.order('name');
  }
  
  static Future<void> createPaymentMethod(Map<String, dynamic> paymentMethod) async {
    await _client.from('payment_methods').insert(paymentMethod);
  }
  
  // Expenses methods
  static Future<List<Map<String, dynamic>>> getExpenses({
    required String userId,
    int? limit,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    dynamic query = _client
        .from('expenses')
        .select('''
          *,
          categories(name, icon_name, color),
          payment_methods(name, type)
        ''')
        .eq('user_id', userId);
    
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    
    if (startDate != null) {
      query = query.gte('expense_date', startDate.toIso8601String());
    }
    
    if (endDate != null) {
      query = query.lte('expense_date', endDate.toIso8601String());
    }
    
    query = query.order('expense_date', ascending: false);
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return await query;
  }
  
  static Future<void> createExpense(Map<String, dynamic> expense) async {
    await _client.from('expenses').insert(expense);
  }
  
  static Future<void> updateExpense(String expenseId, Map<String, dynamic> expense) async {
    await _client.from('expenses').update(expense).eq('id', expenseId);
  }
  
  static Future<void> deleteExpense(String expenseId) async {
    await _client.from('expenses').delete().eq('id', expenseId);
  }
  
  // Analytics methods
  static Future<List<Map<String, dynamic>>> getMonthlySpending({
    required String userId,
    DateTime? month,
  }) async {
    final targetMonth = month ?? DateTime.now();
    
    return await _client.rpc('get_monthly_spending', params: {
      'user_uuid': userId,
      'target_month': targetMonth.toIso8601String().split('T')[0],
    });
  }
  
  static Future<Map<String, dynamic>> getSpendingSummary({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = endDate ?? DateTime.now();
    
    final response = await _client
        .from('expenses')
        .select('amount, expense_date')
        .eq('user_id', userId)
        .gte('expense_date', start.toIso8601String())
        .lte('expense_date', end.toIso8601String());
    
    double totalSpent = 0;
    int transactionCount = 0;
    
    for (var expense in response) {
      totalSpent += (expense['amount'] as num).toDouble();
      transactionCount++;
    }
    
    return {
      'total_spent': totalSpent,
      'transaction_count': transactionCount,
      'average_transaction': transactionCount > 0 ? totalSpent / transactionCount : 0,
      'period_start': start.toIso8601String(),
      'period_end': end.toIso8601String(),
    };
  }
  
  // Budget methods
  static Future<List<Map<String, dynamic>>> getBudgets(String userId) async {
    return await _client
        .from('budgets')
        .select('''
          *,
          categories(name, icon_name, color)
        ''')
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('created_at', ascending: false);
  }
  
  static Future<void> createBudget(Map<String, dynamic> budget) async {
    await _client.from('budgets').insert(budget);
  }
  
  static Future<void> updateBudget(String budgetId, Map<String, dynamic> budget) async {
    await _client.from('budgets').update(budget).eq('id', budgetId);
  }
  
  // Session tracking
  static Future<void> createSession(String userId, Map<String, dynamic> sessionData) async {
    await _client.from('user_sessions').insert({
      'user_id': userId,
      ...sessionData,
    });
  }
  
  static Future<void> updateSessionActivity(String userId) async {
    await _client
        .from('user_sessions')
        .update({'last_activity': DateTime.now().toIso8601String()})
        .eq('user_id', userId)
        .eq('is_active', true);
  }
  
  static Future<void> endSession(String userId) async {
    await _client
        .from('user_sessions')
        .update({'is_active': false})
        .eq('user_id', userId)
        .eq('is_active', true);
  }
}