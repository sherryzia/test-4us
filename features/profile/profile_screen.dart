import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    // Load user data when screen initializes
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _isLoading.value = true;
    await Controllers.global.refreshUserData();
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header with Bell Icon
                  _buildHeader(),
                  
                  // Rewards Balance Card
                  _buildRewardsCard(),

                  const SizedBox(height: 20),

                  // Profile Picture Section
                  _buildProfileSection(),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),

                  // Account Settings Section
                  _buildAccountSettings(),
                  
                  const Divider(color: Colors.grey),

                  // Additional Settings
                  _buildAdditionalSettings(),

                  const SizedBox(height: 20),

                  // Sign Out Button
                  _buildSignOutButton(),

                  const SizedBox(height: 20),

                  // Premium Button
                  DynamicButton.fromText(
                    text: "Get Premium", 
                    onPressed: () {
                      // Premium subscription logic
                    }
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Profile Header
  Widget _buildHeader() {
    return Row(
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
          onPressed: () {
            // Navigate to notifications
          },
        ),
      ],
    );
  }

  // Rewards Balance Card
  Widget _buildRewardsCard() {
    return Obx(() {
      final userData = Controllers.global.userData.value;
      final points = userData['points'] ?? 0;
      
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eco Points Balance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$points',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Redeem points
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    elevation: 0,
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
      );
    });
  }

  // Profile Picture Section
  Widget _buildProfileSection() {
    return Obx(() {
      final user = Controllers.auth.currentUser;
      final userData = Controllers.global.userData.value;
      
      return Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                backgroundImage: CachedNetworkImageProvider(
                  userData['photoURL'] ?? user?.photoURL ?? 'https://via.placeholder.com/150',
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Change profile picture
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['fullName'] ?? user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${userData['username'] ?? 'username'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to profile edit
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(120, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  // Account Settings Section
  Widget _buildAccountSettings() {
    return Obx(() {
      final user = Controllers.auth.currentUser;
      final userData = Controllers.global.userData.value;
      final isLoading = _isLoading.value;
      
      if (isLoading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem('Full Name', userData['fullName'] ?? user?.displayName ?? 'Not set'),
          _buildSettingsItem('Username', userData['username'] ?? 'Not set'),
          _buildSettingsItem('Email', userData['email'] ?? user?.email ?? 'Not set'),
          _buildSettingsItem('Phone', userData['phoneNo'] ?? user?.phoneNumber ?? 'Not set'),
          _buildSettingsItem('Member Since', _formatDate(userData['createdAt'])),
          _buildSettingsItem('Last Login', _formatDate(userData['lastLogin'])),
        ],
      );
    });
  }

  // Additional Settings
  Widget _buildAdditionalSettings() {
    return Column(
      children: [
        _buildNavigationItem('Notification Settings', () {
          // Navigate to notification settings
        }),
        const Divider(color: Colors.grey),
        _buildNavigationItem('Privacy Settings', () {
          // Navigate to privacy settings
        }),
        const Divider(color: Colors.grey),
        _buildNavigationItem('Help and Support', () {
          // Navigate to help and support
        }),
        const Divider(color: Colors.grey),
        _buildNavigationItem('About', () {
          // Navigate to about
        }),
        const Divider(color: Colors.grey),
        _buildNavigationItem('Rate the App', () {
          // Open app rating dialog
        }),
      ],
    );
  }

  // Sign Out Button
  Widget _buildSignOutButton() {
    return DynamicButton.fromText(
      text: "Sign Out", 
      onPressed: () async {
        // Show confirmation dialog
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sign Out'),
              ),
            ],
          ),
        );
        
        if (result == true) {
          await Controllers.auth.signOut();
          // Navigate to login screen
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      color: Colors.red.shade100,
      textColor: Colors.red,
    );
  }

  // Settings Item
  Widget _buildSettingsItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Item
  Widget _buildNavigationItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Format Firestore Timestamp
  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Not available';
    
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    
    return 'Not available';
  }
}