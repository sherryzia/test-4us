import 'package:flutter/material.dart';
import 'package:forus_app/controllers/GlobalController.dart';
import 'package:forus_app/view/auth/login_screen.dart';
import 'package:forus_app/view/auth/verification_otp.dart';
import 'package:forus_app/view/event_organizer/EventBottomBarNav.dart';
import 'package:forus_app/view/event_organizer/event_organizer_business_registration.dart';
import 'package:forus_app/view/general/user_under_verification_screen.dart';
import 'package:forus_app/view/service_provider/ProviderBottomBarNav.dart';
import 'package:get/get.dart';
import 'package:forus_app/services/general/get_user_service.dart';
import "package:dio/src/dio_exception.dart";
import 'package:forus_app/view/service_provider/BusinessManagement/provider_select_services.dart';

import '../../services/event_organizer/organizer_business_service.dart';
import '../../services/service_provider/provider_business_service.dart';

class AuthenticationPointController extends GetxController {
  final GetUserServiceService _getUserService = GetUserServiceService();
  final BusinessService _checkBusinessAvailabilityService = BusinessService();
  final OrganizerBusinessService _checkOrganizerBusinessAvailabilityService = OrganizerBusinessService();
  final globalController = Get.find<GlobalController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateAuthentication();
    });
  }

  Future<void> validateAuthentication() async {

    // Check if the existing authToken is valid and if user is verified or not.
    try{
      await _getUserService.fetchUserDetails();
    }
    on DioException catch (e){
      if(e.response?.statusCode == 403){
        // Show OTP Verification Screen
        Get.offAll(() => VerificationOtpScreen(), arguments: {"email": globalController.email.toString()});
        return;
      }
      else if(e.response?.statusCode == 401){
        // Token is Invalid
        await globalController.clear();
        Get.offAll(() => LoginScreen());
        return;
      }
    }

    // Check if the user is a vendor,
    if(globalController.userType.toString() != "customer"){
      if(globalController.userType.toString() == "serviceProvider"){
        // check if it has registered business.
        try{
          await _checkBusinessAvailabilityService.checkServiceProviderBusiness();
          Get.offAll(() => ProviderBottomBarNav());
        }
        on DioException catch (e){

          if(e.response?.data?["message"] == "api.failed.register_business"){
            // Show screen to register business for Service Provider
            Get.offAll(() => ProviderSelectServicesScreen());
          }
          else if(e.response?.data?["message"] == "api.failed.business_awaiting_admin_approval"){
            // Show screen for service provider where he is awaiting admin approval
            // This is a temporary solution to redirect the user to the Add Service Screen
            Get.offAll(() => UserUnderVerificationScreen());
          }

          return;
        }
      }
      else if(globalController.userType.toString() == "eventOrganizer"){
        try{
          await _checkOrganizerBusinessAvailabilityService.checkEventOrganizerBusiness();
          // Get.offAll(() => SP_HomePage());
          Get.offAll(() => EventBottomBarNav());

        }
        on DioException catch (e){

          if(e.response?.data?["message"] == "api.failed.register_business"){
            // Show screen to register business for Service Provider
            Get.offAll(() => EventOrganizerBusinessRegistrationScreen());
          }
          else if(e.response?.data?["message"] == "api.failed.business_awaiting_admin_approval"){
           
           Get.offAll(() => UserUnderVerificationScreen());
            // Get.offAll(() => ProviderAddServiceScreen());
          }
          else if(e.response?.data?["message"] == "api.success"){
       
            Get.offAll(() => EventBottomBarNav());
          }

          return;
        }
      }
    }
    else{
      // Directly continue customer to HomePage as email verification check already happened.
    }

    return;

  }
}
