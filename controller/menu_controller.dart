// lib/controller/menu_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantMenuController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final String restaurantId;
  
  bool isLoading = true;
  List<MenuItemModel> menuItems = [];
  
  RestaurantMenuController(this.restaurantId);
  
  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }
  
  Future<void> fetchMenuItems() async {
    isLoading = true;
    update();
    
    try {
      final response = await supabase
          .from('menu_items')
          .select()
          .eq('restaurant_id', restaurantId)
          .order('is_popular', ascending: false);
      
      // Add null check here
      if (response != null) {
        menuItems = response.map<MenuItemModel>((item) => MenuItemModel.fromJson(item)).toList();
      } else {
        menuItems = [];
      }
    } catch (e) {
      print("Error fetching menu items: $e");
      menuItems = []; // Ensure empty list on error
    } finally {
      isLoading = false;
      update();
    }
  }
}

// lib/model/menu_item_model.dart
class MenuItemModel {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String image;
  final bool isPopular;
  final DateTime createdAt;
  
  MenuItemModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isPopular,
    required this.createdAt,
  });
  
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurant_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Item',
      description: json['description']?.toString() ?? '',
      price: _parseDouble(json['price']),
      image: json['image']?.toString() ?? '',
      isPopular: json['is_popular'] == true,
      createdAt: _parseDateTime(json['created_at']),
    );
  }
  
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'is_popular': isPopular,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
