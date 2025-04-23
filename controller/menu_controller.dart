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
      
      menuItems = response.map<MenuItemModel>((item) => MenuItemModel.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching menu items: $e");
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
      id: json['id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      isPopular: json['is_popular'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
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
