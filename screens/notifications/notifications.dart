import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/Notification%20Controller/notification_controller.dart';
import 'package:restaurant_finder/model/notification_model.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class Notifications extends StatelessWidget {
  Notifications({super.key});

  final List<Map<String, String>> todayNotifications = [
    {
      'title': 'newOfferAvailable'.tr,
      'body': 'checkOutLatestDeals'.tr,
      'time': '10:30 AM',
      'imageUrl': '',
    },
  ];

  final List<Map<String, String>> yesterdayNotifications = [
    {
      'title': 'updateSuccessful'.tr,
      'body': 'profileUpdatedSuccessfully'.tr,
      'time': '4:15 PM',
      'imageUrl': '',
    },
  ];

  final List<Map<String, String>> earlierNotifications = [
    {
      'title': 'welcomeToApp'.tr,
      'body': 'gladToHaveYouOnboard'.tr,
      'time': 'twoDaysAgo'.tr,
      'imageUrl': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? kBlackColor : Colors.white,
      appBar: simpleAppBar(title: 'notifications'.tr),
      body: ListView(
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          if (todayNotifications.isNotEmpty)
            _buildSection('today'.tr.toUpperCase(), todayNotifications, isDark),
          if (yesterdayNotifications.isNotEmpty)
            _buildSection('yesterday'.tr.toUpperCase(), yesterdayNotifications, isDark),
          if (earlierNotifications.isNotEmpty)
            _buildSection('earlier'.tr.toUpperCase(), earlierNotifications, isDark),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> notifications, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingBottom: 6,
          text: title,
          size: 14,
          color: isDark ? kTertiaryColor : kGreyColor,
          weight: FontWeight.w500,
          paddingTop: 16,
        ),
        ...notifications.map(
          (notification) => _NotificationTile(
            title: notification['title'] ?? '',
            body: notification['body'] ?? '',
            time: notification['time'] ?? '',
            imageUrl: notification['imageUrl'],
            onTap: () {
              // Handle notification tap
              print('Notification tapped: ${notification['title']}');
            },
            onDismiss: () {
              // Handle notification dismissal
              print('Notification dismissed: ${notification['title']}');
            },
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.body,
    required this.time,
    this.imageUrl,
    required this.onTap,
    required this.onDismiss,
    this.isDark = false,
  });
  
  final String title;
  final String body;
  final String time;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title + time), // Using a combination for a unique key
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark ? kDialogBlack : kPrimaryColor,
            border: Border.all(
              width: 1.0,
              color: kBorderColor,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Only show image if available
              imageUrl != null && imageUrl!.isNotEmpty
                  ? CommonImageView(
                      height: 38,
                      width: 38,
                      radius: 100,
                      url: imageUrl!,
                    )
                  : Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: kSecondaryColor,
                        size: 20,
                      ),
                    ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: title,
                      size: 14,
                      weight: FontWeight.w600,
                      paddingBottom: 6,
                      color: isDark ? kTertiaryColor : null,
                    ),
                    MyText(
                      text: body,
                      size: 12,
                      color: isDark ? kDarkTextColor : kGreyColor,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      paddingBottom: 4,
                    ),
                    MyText(
                      text: time,
                      size: 12,
                      color: isDark ? kDarkTextColor : kGreyColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Notifications Working

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:restaurant_finder/constants/app_colors.dart';
// import 'package:restaurant_finder/constants/app_sizes.dart';
// import 'package:restaurant_finder/controller/Notification%20Controller/notification_controller.dart';
// import 'package:restaurant_finder/model/notification_model.dart';
// import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
// import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
// import 'package:restaurant_finder/view/widget/my_text_widget.dart';

// class Notifications extends StatelessWidget {
//   final NotificationController controller = Get.put(NotificationController());

//   Notifications({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: simpleAppBar(
//         title: 'Notifications',
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(color: kSecondaryColor),
//           );
//         }

//         if (controller.notifications.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.notifications_off_outlined,
//                   size: 64,
//                   color: kGreyColor,
//                 ),
//                 SizedBox(height: 16),
//                 MyText(
//                   text: 'No notifications yet',
//                   size: 16,
//                   weight: FontWeight.w500,
//                   color: kGreyColor,
//                 ),
//                 SizedBox(height: 8),
//                 MyText(
//                   text: 'When you receive notifications, they will appear here',
//                   size: 14,
//                   color: kGreyColor,
//                   textAlign: TextAlign.center,
//                   paddingLeft: 32,
//                   paddingRight: 32,
//                 ),
//               ],
//             ),
//           );
//         }

//         // Build sections for today, yesterday, and earlier
//         return ListView.builder(
//           shrinkWrap: true,
//           padding: AppSizes.DEFAULT,
//           physics: BouncingScrollPhysics(),
//           itemCount: 3, // For Today, Yesterday, and Earlier sections
//           itemBuilder: (context, index) {
//             List<NotificationModel> sectionNotifications;
//             String sectionTitle;
            
//             // Determine which section we're building
//             if (index == 0) {
//               sectionTitle = 'TODAY';
//               sectionNotifications = controller.todayNotifications;
//             } else if (index == 1) {
//               sectionTitle = 'YESTERDAY';
//               sectionNotifications = controller.yesterdayNotifications;
//             } else {
//               sectionTitle = 'EARLIER';
//               sectionNotifications = controller.earlierNotifications;
//             }
            
//             // Skip empty sections
//             if (sectionNotifications.isEmpty) {
//               return SizedBox.shrink();
//             }
            
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 MyText(
//                   paddingBottom: 6,
//                   text: sectionTitle,
//                   size: 14,
//                   color: kGreyColor,
//                   weight: FontWeight.w500,
//                   paddingTop: index == 0 ? 0 : 16,
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: sectionNotifications.length,
//                   itemBuilder: (context, nIndex) {
//                     final notification = sectionNotifications[nIndex];
//                     return _NotificationTile(
//                       title: notification.title,
//                       body: notification.body,
//                       time: notification.getFormattedTime(),
//                       imageUrl: notification.imageUrl,
//                       onTap: () {
//                         // Handle notification tap
//                       },
//                       onDismiss: () {
//                         // Delete notification when dismissed
//                         controller.deleteNotification(notification.id);
//                       },
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }),
//     );
//   }
// }

// class _NotificationTile extends StatelessWidget {
//   const _NotificationTile({
//     required this.title,
//     required this.body,
//     required this.time,
//     this.imageUrl,
//     required this.onTap,
//     required this.onDismiss,
//   });
  
//   final String title;
//   final String body;
//   final String time;
//   final String? imageUrl;
//   final VoidCallback onTap;
//   final VoidCallback onDismiss;

//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: Key(title + time), // Using a combination for a unique key
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(Icons.delete, color: Colors.white),
//       ),
//       onDismissed: (direction) => onDismiss(),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           margin: EdgeInsets.only(bottom: 8),
//           padding: EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 12,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: kPrimaryColor,
//             border: Border.all(
//               width: 1.0,
//               color: kBorderColor,
//             ),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Only show image if available
//               imageUrl != null && imageUrl!.isNotEmpty
//                   ? CommonImageView(
//                       height: 38,
//                       width: 38,
//                       radius: 100,
//                       url: imageUrl!,
//                     )
//                   : Container(
//                       height: 38,
//                       width: 38,
//                       decoration: BoxDecoration(
//                         color: kSecondaryColor.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.notifications,
//                         color: kSecondaryColor,
//                         size: 20,
//                       ),
//                     ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     MyText(
//                       text: title,
//                       size: 14,
//                       weight: FontWeight.w600,
//                       paddingBottom: 6,
//                     ),
//                     MyText(
//                       text: body,
//                       size: 12,
//                       color: kGreyColor,
//                       maxLines: 2,
//                       textOverflow: TextOverflow.ellipsis,
//                       paddingBottom: 4,
//                     ),
//                     MyText(
//                       text: time,
//                       size: 12,
//                       color: kGreyColor,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }