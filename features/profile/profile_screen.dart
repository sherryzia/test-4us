import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Controllers.profileController.getProfile();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Added ScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header with Bell Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),

                // Rewards Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rewards Balance',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '12550.50',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Redeem'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Profile Picture Section
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1657306607237-3eab445c4a84?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      // Added Expanded
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () {
                              return Text(
                                Controllers.profileController
                                            .isLoading[keys.getProfile] ??
                                        false
                                    ? " -- "
                                    : Controllers
                                        .profileController.profile!.fullName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Change profile picture',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                ),

                // Account Settings Section
                const Text(
                  'Account settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),
                // _buildSettingsItem('Fullname', 'Jayce Rodrygo'),
                // _buildSettingsItem('Display name', 'TheRealJayce'),
                // _buildSettingsItem('Email address', 'Jaycero@gmail.com'),
                // _buildSettingsItem('Gender', 'Male'),
                // _buildSettingsItem('Age', '32'),
                // _buildSettingsItem('Password', '••••••••••'),

                Obx(() {
                  if (Controllers
                          .profileController.isLoading[keys.getProfile] ??
                      false) {
                    return Column(
                      children: [
                        _buildSettingsItem('Fullname', "---"),
                        _buildSettingsItem('Display name', "---"),
                        _buildSettingsItem('Email address', "---"),
                        _buildSettingsItem('Gender', "---"),
                        _buildSettingsItem('Age', "---"),
                      ],
                    );
                  } else
                    return Column(
                      children: [
                        _buildSettingsItem('Fullname',
                            Controllers.profileController.profile!.fullName),
                        _buildSettingsItem('Display name',
                            Controllers.profileController.profile!.username),
                        _buildSettingsItem('Email address',
                            Controllers.profileController.profile!.email),
                        _buildSettingsItem(
                            'Gender',
                            Controllers.profileController.profile!.gender
                                .toString()
                                .capitalizeFirst!),
                        _buildSettingsItem('Age', '32'),
                      ],
                    );
                }),
                const Divider(
                  color: Colors.grey,
                ),

                // Additional Settings
                _buildNavigationItem('Notification settings'),
                const Divider(
                  color: Colors.grey,
                ),
                _buildNavigationItem('Help and support'),
                const Divider(
                  color: Colors.grey,
                ),
                _buildNavigationItem('About'),
                const Divider(
                  color: Colors.grey,
                ),
                _buildNavigationItem('Rate the app'),

                const SizedBox(height: 10),

                // Premium Button
                DynamicButton.fromText(text: "Get Premium", onPressed: () {}),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
