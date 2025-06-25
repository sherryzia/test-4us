// lib/services/supabase_service.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expensary/configs/supabase_config.dart';

class SupabaseService {
  static final SupabaseClient _client = SupabaseConfig.client;
  
  // ====== Authentication Methods ======
  
  // Sign up a new user
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Sign up with email and password
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      
      // If sign up is successful, create a new user profile
      if (response.user != null) {
        await _createUserProfile(
          userId: response.user!.id,
          fullName: fullName,
          email: email,
        );
      }
      
      return response;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }
  
  // Create a user profile after signup
  static Future<void> _createUserProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    try {
      await _client.from('users').insert({
        'id': userId,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Create user profile error: $e');
      rethrow;
    }
  }
  
  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }
  
  // Sign out the current user
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }
  
  // Send a password reset email
  static Future<void> resetPasswordForEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      debugPrint('Reset password error: $e');
      rethrow;
    }
  }
  
  // Update a user's password with reset token
  static Future<UserResponse> updateUserPasswordWithToken({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      debugPrint('Update password error: $e');
      rethrow;
    }
  }
  
  // Update user attributes (email, password, data)
  static Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _client.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: data,
        ),
      );
    } catch (e) {
      debugPrint('Update user error: $e');
      rethrow;
    }
  }
  
  // ====== OTP Methods ======
  
  // Generate a random OTP
  static String generateOTP() {
    // Generate a random 4-digit OTP
    final Random random = Random();
    final int otp = 1000 + random.nextInt(9000); // Ensures 4 digits (1000-9999)
    return otp.toString();
  }
  
  // Save OTP for a user
  static Future<void> saveOTP({
    required String userId,
    String? otp,
  }) async {
    try {
      final otpCode = otp ?? generateOTP();
      
      await _client.from('users').update({
        'otp': otpCode,
        'otp_created_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      
      debugPrint('OTP saved for user: $userId');
      
      // In a real app, you would send this OTP via email or SMS
      // For testing, we'll just print it to the console
      debugPrint('Generated OTP: $otpCode');
    } catch (e) {
      debugPrint('Error saving OTP: $e');
      rethrow;
    }
  }
  
  // Verify OTP
  static Future<bool> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    try {
      final response = await _client
          .from('users')
          .select('otp, otp_created_at')
          .eq('id', userId)
          .single();
      
      if (response == null) return false;
      
      final storedOTP = response['otp'] as String?;
      final otpCreatedAt = response['otp_created_at'] as String?;
      
      if (storedOTP == null || otpCreatedAt == null) return false;
      
      // Check if OTP matches
      if (storedOTP != otp) return false;
      
      // Check if OTP is expired (10 minutes validity)
      final createdAt = DateTime.parse(otpCreatedAt);
      final now = DateTime.now();
      final difference = now.difference(createdAt);
      
      if (difference.inMinutes > 10) {
        // OTP expired
        return false;
      }
      
      // Clear the OTP after successful verification
      await _client.from('users').update({
        'otp': null,
        'otp_created_at': null,
      }).eq('id', userId);
      
      return true;
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      return false;
    }
  }
  
  // Resend OTP
  static Future<void> resendOTP({
    required String userId,
  }) async {
    try {
      // Generate a new OTP and save it
      final newOTP = generateOTP();
      await saveOTP(userId: userId, otp: newOTP);
      
      // In a real app, you would send this OTP via email or SMS
      debugPrint('Resent OTP: $newOTP');
    } catch (e) {
      debugPrint('Error resending OTP: $e');
      rethrow;
    }
  }
  
  // ====== User Profile Methods ======
  
  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return null;
    }
  }
  
  // Update user profile
  static Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await _client
          .from('users')
          .update(data)
          .eq('id', userId);
    } catch (e) {
      debugPrint('Update user profile error: $e');
      rethrow;
    }
  }
  
  // ====== Categories Methods ======
  
  // Get all categories (default + user's custom categories)
  static Future<List<Map<String, dynamic>>> getCategories(String? userId) async {
    try {
      var query = _client.from('categories').select();
      
      if (userId != null) {
        // Get both default categories and user's custom categories
        query = query.or('is_default.eq.true,user_id.eq.$userId');
      } else {
        // Get only default categories
        query = query.eq('is_default', true);
      }
      
      // Convert to List<Map<String, dynamic>>
      final result = await query.order('name');
      return result;
    } catch (e) {
      debugPrint('Get categories error: $e');
      return [];
    }
  }
  
  // Create a new category
  static Future<Map<String, dynamic>> createCategory({
    required String name,
    required String userId,
    String? iconName,
    String? color,
  }) async {
    try {
      final data = {
        'name': name,
        'user_id': userId,
        'icon_name': iconName,
        'color': color,
        'is_default': false,
      };
      
      final response = await _client
          .from('categories')
          .insert(data)
          .select()
          .single();
      
      return response;
    } catch (e) {
      debugPrint('Create category error: $e');
      rethrow;
    }
  }
  
  // Update a category
  static Future<void> updateCategory({
    required String categoryId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _client
          .from('categories')
          .update(data)
          .eq('id', categoryId);
    } catch (e) {
      debugPrint('Update category error: $e');
      rethrow;
    }
  }
  
  // Delete a category
  static Future<void> deleteCategory(String categoryId) async {
    try {
      await _client
          .from('categories')
          .delete()
          .eq('id', categoryId);
    } catch (e) {
      debugPrint('Delete category error: $e');
      rethrow;
    }
  }
  
  // ====== Payment Methods ======
  
  // Get all payment methods (default + user's custom methods)
  static Future<List<Map<String, dynamic>>> getPaymentMethods(String? userId) async {
    try {
      var query = _client.from('payment_methods').select();
      
      if (userId != null) {
        // Get both default payment methods and user's custom methods
        query = query.or('is_default.eq.true,user_id.eq.$userId');
      } else {
        // Get only default payment methods
        query = query.eq('is_default', true);
      }
      
      // Convert to List<Map<String, dynamic>>
      final result = await query.order('name');
      return result;
    } catch (e) {
      debugPrint('Get payment methods error: $e');
      return [];
    }
  }
  
  // Create a new payment method
  static Future<Map<String, dynamic>> createPaymentMethod({
    required String name,
    required String userId,
    String? type,
    String? iconName,
  }) async {
    try {
      final data = {
        'name': name,
        'user_id': userId,
        'type': type,
        'icon_name': iconName,
        'is_default': false,
      };
      
      final response = await _client
          .from('payment_methods')
          .insert(data)
          .select()
          .single();
      
      return response;
    } catch (e) {
      debugPrint('Create payment method error: $e');
      rethrow;
    }
  }
  
  // Update a payment method
  static Future<void> updatePaymentMethod({
    required String paymentMethodId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _client
          .from('payment_methods')
          .update(data)
          .eq('id', paymentMethodId);
    } catch (e) {
      debugPrint('Update payment method error: $e');
      rethrow;
    }
  }
  
  // Delete a payment method
  static Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      await _client
          .from('payment_methods')
          .delete()
          .eq('id', paymentMethodId);
    } catch (e) {
      debugPrint('Delete payment method error: $e');
      rethrow;
    }
  }
  
  // ====== Expenses Methods ======
  static Future<List<Map<String, dynamic>>> getExpenses({
  required String userId,
  int? limit,
  String? categoryId,
  DateTime? startDate,
  DateTime? endDate,
  bool includeRelations = true,
}) async {
  try {
    String query = '*';
    
    if (includeRelations) {
      query = '''
        *,
        categories(name, icon_name, color),
        payment_methods(name, type, icon_name)
      ''';
    }
    
    var dbQuery = _client
        .from('expenses')
        .select(query)
        .eq('user_id', userId);
    
    if (categoryId != null) {
      dbQuery = dbQuery.eq('category_id', categoryId);
    }
    
    if (startDate != null) {
      dbQuery = dbQuery.gte('expense_date', startDate.toIso8601String().split('T')[0]);
    }
    
    if (endDate != null) {
      dbQuery = dbQuery.lte('expense_date', endDate.toIso8601String().split('T')[0]);
    }
    
    // First apply ordering
    var orderedQuery = dbQuery.order('expense_date', ascending: false);
    
    // Then apply limit if needed
    if (limit != null) {
      orderedQuery = orderedQuery.limit(limit);
    }
    
    // Execute query
    final result = await orderedQuery;
    return result;
  } catch (e) {
    debugPrint('Get expenses error: $e');
    return [];
  }
}
  
  // Create a new expense
  // Partial file showing only the createExpense method update

// In lib/services/supabase_service.dart, replace or update the createExpense method:
static Future<Map<String, dynamic>> createExpense({
  required String title,
  required double amount,
  required DateTime expenseDate,
  required String userId,
  String? categoryId,
  String? paymentMethodId,
  String? notes,
  String? iconData,
  String? iconBg,
  String? category, // We'll use this to find the category_id, not insert directly
  TimeOfDay? transactionTime,
}) async {
  try {
    // Determine transaction type (income vs expense)
    String transactionType = amount >= 0 ? 'income' : 'expense';
    
    // If categoryId is not provided but category name is, try to find the categoryId
    if (categoryId == null && category != null) {
      try {
        // Look up category by name
        final categories = await _client
            .from('categories')
            .select('id')
            .or('is_default.eq.true,user_id.eq.$userId')
            .ilike('name', '%${category.replaceAll("Income: ", "")}%')
            .limit(1);
            
        if (categories.isNotEmpty) {
          categoryId = categories[0]['id'];
        }
      } catch (e) {
        debugPrint('Error finding category by name: $e');
        // Continue without categoryId if lookup fails
      }
    }
    
    // Create data object according to your schema
    final data = {
      'title': title,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String().split('T')[0],
      'user_id': userId,
      'category_id': categoryId,
      'payment_method_id': paymentMethodId,
      'notes': notes,
      'icon_data': iconData,
      'icon_bg': iconBg,
      'transaction_type': transactionType,
      'transaction_time': transactionTime != null 
          ? '${transactionTime.hour.toString().padLeft(2, '0')}:${transactionTime.minute.toString().padLeft(2, '0')}:00'
          : null,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    final response = await _client
        .from('expenses')
        .insert(data)
        .select()
        .single();
    
    return response;
  } catch (e) {
    debugPrint('Create expense error: $e');
    rethrow;
  }
}
  // Update an expense
  static Future<void> updateExpense({
    required String expenseId,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await _client
          .from('expenses')
          .update(data)
          .eq('id', expenseId);
    } catch (e) {
      debugPrint('Update expense error: $e');
      rethrow;
    }
  }
  
  // Delete an expense
  static Future<void> deleteExpense(String expenseId) async {
    try {
      await _client
          .from('expenses')
          .delete()
          .eq('id', expenseId);
    } catch (e) {
      debugPrint('Delete expense error: $e');
      rethrow;
    }
  }
  
  // ====== Analytics Methods ======
  
  // Get monthly spending by category
  static Future<List<Map<String, dynamic>>> getMonthlySpending({
    required String userId,
    DateTime? month,
  }) async {
    try {
      final targetMonth = month ?? DateTime.now();
      
      return await _client.rpc('get_monthly_spending', params: {
        'user_uuid': userId,
        'target_month': targetMonth.toIso8601String().split('T')[0],
      });
    } catch (e) {
      debugPrint('Get monthly spending error: $e');
      return [];
    }
  }
  
  // Get spending summary for a period
  static Future<Map<String, dynamic>> getSpendingSummary({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
      final end = endDate ?? DateTime.now();
      
      final response = await _client
          .from('expenses')
          .select('amount, expense_date')
          .eq('user_id', userId)
          .gte('expense_date', start.toIso8601String().split('T')[0])
          .lte('expense_date', end.toIso8601String().split('T')[0]);
      
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
    } catch (e) {
      debugPrint('Get spending summary error: $e');
      return {
        'total_spent': 0,
        'transaction_count': 0,
        'average_transaction': 0,
      };
    }
  }
  
  // ====== Budget Methods ======
  
  // Get all active budgets
  static Future<List<Map<String, dynamic>>> getBudgets(String userId) async {
    try {
      return await _client
          .from('budgets')
          .select('''
            *,
            categories(name, icon_name, color)
          ''')
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('created_at', ascending: false);
    } catch (e) {
      debugPrint('Get budgets error: $e');
      return [];
    }
  }
  
  // Create a new budget
  static Future<Map<String, dynamic>> createBudget({
    required String name,
    required double amount,
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
    String? categoryId,
  }) async {
    try {
      final data = {
        'name': name,
        'amount': amount,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
        'user_id': userId,
        'category_id': categoryId,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      final response = await _client
          .from('budgets')
          .insert(data)
          .select()
          .single();
      
      return response;
    } catch (e) {
      debugPrint('Create budget error: $e');
      rethrow;
    }
  }
  
  // Update a budget
  static Future<void> updateBudget({
    required String budgetId,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await _client
          .from('budgets')
          .update(data)
          .eq('id', budgetId);
    } catch (e) {
      debugPrint('Update budget error: $e');
      rethrow;
    }
  }
  
  
  // ====== Financial Tips Methods ======
  
  // Get financial tips
  static Future<List<Map<String, dynamic>>> getFinancialTips({
    String? category,
    int? limit,
  }) async {
    try {
      var query = _client
          .from('financial_tips')
          .select()
          .eq('is_public', true);
      
      if (category != null) {
        query = query.eq('category', category);
      }
      
      // Apply ordering
      var orderedQuery = query.order('created_at', ascending: false);
      
      // Apply limit if needed
      if (limit != null) {
        orderedQuery = orderedQuery.limit(limit);
      }
      
      // Execute the query
      final result = await orderedQuery;
      return result;
    } catch (e) {
      debugPrint('Get financial tips error: $e');
      return [];
    }
  }
  
  // ====== Session Management ======
  
  // Create a new session
  static Future<void> createSession(String userId, Map<String, dynamic> sessionData) async {
    try {
      await _client.from('user_sessions').insert({
        'user_id': userId,
        'is_active': true,
        'last_activity': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        ...sessionData,
      });
    } catch (e) {
      debugPrint('Create session error: $e');
      // Continue even if error - this is not critical
    }
  }
  
  // Update session activity
  static Future<void> updateSessionActivity(String userId) async {
    try {
      await _client
          .from('user_sessions')
          .update({'last_activity': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('is_active', true);
    } catch (e) {
      debugPrint('Update session activity error: $e');
      // Continue even if error - this is not critical
    }
  }
  
  // End session
  static Future<void> endSession(String userId) async {
    try {
      await _client
          .from('user_sessions')
          .update({'is_active': false})
          .eq('user_id', userId)
          .eq('is_active', true);
    } catch (e) {
      debugPrint('End session error: $e');
      // Continue even if error - this is not critical
    }
  }
}