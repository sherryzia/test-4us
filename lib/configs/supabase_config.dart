// lib/configs/supabase_config.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Your Supabase URL and anon key - keep these secure in production
  static const String supabaseUrl = 'https://yqsssaxktjixypmypigl.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlxc3NzYXhrdGppeHlwbXlwaWdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAyMzA4OTcsImV4cCI6MjA2NTgwNjg5N30.eIsKTQvoADnia1FmcHorgaKaVRZiGRSQ95wXZv9dbtk';
  
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          // Enable auto refresh to keep session active
          autoRefreshToken: true,
          // The persistSession parameter is not needed - it's enabled by default
        ),
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
        ),
        debug: kDebugMode, // Enable debug logs in debug mode
      );
      
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Supabase: $e');
      rethrow;
    }
  }
  
  // Access the Supabase client
  static SupabaseClient get client => Supabase.instance.client;
  
  // Access the auth client
  static GoTrueClient get auth => Supabase.instance.client.auth;
  
  // Helper method to get a table query builder
  static SupabaseQueryBuilder table(String tableName) {
    return client.from(tableName);
  }
  
  // Helper for users table
  static SupabaseQueryBuilder get users => table('users');
  
  // Helper for categories table
  static SupabaseQueryBuilder get categories => table('categories');
  
  // Helper for payment methods table
  static SupabaseQueryBuilder get paymentMethods => table('payment_methods');
  
  // Helper for expenses table
  static SupabaseQueryBuilder get expenses => table('expenses');
  
  // Helper for budgets table
  static SupabaseQueryBuilder get budgets => table('budgets');
  
  // Helper for user sessions table
  static SupabaseQueryBuilder get userSessions => table('user_sessions');
  
  // Helper for financial tips table
  static SupabaseQueryBuilder get financialTips => table('financial_tips');
}