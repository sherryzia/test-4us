//This is a configuration file for main app

import 'package:supabase_flutter/supabase_flutter.dart';

class AppConfigs {
  static Future<void> initializeSupabase() async {
    await Supabase.initialize(
      url: 'https://hykjowvgpmlvqphnmdaj.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh5a2pvd3ZncG1sdnFwaG5tZGFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIxOTM5ODYsImV4cCI6MjA1Nzc2OTk4Nn0.6jb7d9FY5_kuM5E0vFq4lM7sMuwX5r2kP6sEPUcRQwo',
    );
  }
  
  }