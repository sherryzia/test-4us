// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quran_app/controllers/DuaController.dart';
// import 'package:quran_app/view/duaDetailsPage.dart';

// class DuaListPage extends StatelessWidget {
//   final String category;
//   final DuaController duaController = Get.find<DuaController>();

//   DuaListPage({required this.category, Key? key}) : super(key: key) {
//     // Fetch Duas when the page opens
//     Future.delayed(Duration.zero, () => duaController.fetchDuas(category));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(category)),
//       body: Obx(() {
//         if (duaController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         // Ensure the list is not empty
//         if (duaController.duas.isEmpty) {
//           return const Center(child: Text("No Duas found"));
//         }

//         return ListView.builder(
//   itemCount: duaController.duas.length,
//   itemBuilder: (context, index) {
//     try {
//       if (index >= duaController.duas.length) {
//         return const SizedBox(); // Prevent index error
//       }

//       final dua = duaController.duas[index];

//       return ListTile(
//         title: Text(dua['title'] ?? "No title"),
//         onTap: () {
//           Get.to(() => DuaDetailsPage(category: category, duaId: dua['id'].toString()));
//         },
//       );
//     } catch (e) {
//       print("❌ Error accessing index $index: $e");
//       return const SizedBox(); // Prevent crash
//     }
//   },
// );

//       }),
//     );
//   }
// }
