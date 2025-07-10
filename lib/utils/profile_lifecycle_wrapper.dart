import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:candid/controller/profile_video_controller.dart';

class ProfileLifecycleWrapper extends StatefulWidget {
  final Widget child;
  
  const ProfileLifecycleWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ProfileLifecycleWrapper> createState() => _ProfileLifecycleWrapperState();
}

class _ProfileLifecycleWrapperState extends State<ProfileLifecycleWrapper> 
    with WidgetsBindingObserver {
  
  ProfileVideoController? _videoController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize video controller if not already done
    if (!Get.isRegistered<ProfileVideoController>()) {
      Get.put(ProfileVideoController(), permanent: true);
    }
    _videoController = Get.find<ProfileVideoController>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    // Clean up video controllers when widget is disposed
    _videoController?.onNavigateAway();
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _videoController?.onAppLifecycleChanged(state);
    
    // Additional cleanup for memory pressure
    if (state == AppLifecycleState.paused) {
      // Force garbage collection hint when app goes to background
      print('App paused - cleaning up video memory');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}