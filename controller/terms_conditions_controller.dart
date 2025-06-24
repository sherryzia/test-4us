// lib/controller/terms_conditions_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_finder/model/terms_conditions_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TermsConditionsController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  
  var isLoading = true.obs;
  var termsConditions = Rx<TermsConditionsModel?>(null);
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTermsAndConditions();
  }

  // Fetch the active terms and conditions
  Future<void> fetchTermsAndConditions() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    
    try {
      // Query for active terms and conditions, sorted by creation date (newest first)
      final response = await supabase
          .from('terms_conditions')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .single();
      
      // Parse the response
      termsConditions.value = TermsConditionsModel.fromJson(response);
    } catch (e) {
      print("Error fetching terms and conditions: $e");
      hasError.value = true;
      errorMessage.value = 'Failed to load terms and conditions. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch a specific version of terms and conditions
  Future<void> fetchTermsAndConditionsByVersion(String version) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    
    try {
      final response = await supabase
          .from('terms_conditions')
          .select()
          .eq('version', version)
          .limit(1)
          .single();
      
      termsConditions.value = TermsConditionsModel.fromJson(response);
    } catch (e) {
      print("Error fetching terms and conditions by version: $e");
      hasError.value = true;
      errorMessage.value = 'Failed to load the specified version. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method to handle user agreement
  
}