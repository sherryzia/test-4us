
// Filter model
import 'package:flutter/material.dart';

class FilterOption {
  final int id;
  final String name;
  final IconData icon;
  final String description;
  final Color overlayColor;
  final BlendMode blendMode;
  final double opacity;

  FilterOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.overlayColor,
    this.blendMode = BlendMode.multiply,
    this.opacity = 0.3,
  });
}





  // Available filters
  final List<FilterOption> availableFilters = [
    FilterOption(
      id: 0,
      name: 'None',
      icon: Icons.filter_none,
      description: 'Original camera view',
      overlayColor: Colors.transparent,
    ),
    FilterOption(
      id: 1,
      name: 'Vintage',
      icon: Icons.camera_alt,
      description: 'Classic sepia film look',
      overlayColor: const Color(0xFFD2B48C),
      blendMode: BlendMode.overlay,
      opacity: 0.35,
    ),
    FilterOption(
      id: 2,
      name: 'Cool Blue',
      icon: Icons.ac_unit,
      description: 'Cool blue cinema tone',
      overlayColor: const Color(0xFF4A90E2),
      blendMode: BlendMode.multiply,
      opacity: 0.25,
    ),
    FilterOption(
      id: 3,
      name: 'Warm Sunset',
      icon: Icons.wb_sunny,
      description: 'Warm golden hour',
      overlayColor: const Color(0xFFFF8C42),
      blendMode: BlendMode.overlay,
      opacity: 0.3,
    ),
    FilterOption(
      id: 4,
      name: 'Purple Dream',
      icon: Icons.color_lens,
      description: 'Dreamy purple atmosphere',
      overlayColor: const Color(0xFF9C27B0),
      blendMode: BlendMode.softLight,
      opacity: 0.28,
    ),
    FilterOption(
      id: 5,
      name: 'Forest Green',
      icon: Icons.nature,
      description: 'Natural forest vibes',
      overlayColor: const Color(0xFF4CAF50),
      blendMode: BlendMode.multiply,
      opacity: 0.22,
    ),
    FilterOption(
      id: 6,
      name: 'Rose Pink',
      icon: Icons.favorite,
      description: 'Romantic rose filter',
      overlayColor: const Color(0xFFE91E63),
      blendMode: BlendMode.softLight,
      opacity: 0.32,
    ),
    FilterOption(
      id: 7,
      name: 'Monochrome',
      icon: Icons.photo_filter,
      description: 'Black and white classic',
      overlayColor: const Color(0xFF757575),
      blendMode: BlendMode.saturation,
      opacity: 0.8,
    ),
    FilterOption(
      id: 8,
      name: 'Cyber Neon',
      icon: Icons.electrical_services,
      description: 'Futuristic cyan glow',
      overlayColor: const Color(0xFF00BCD4),
      blendMode: BlendMode.screen,
      opacity: 0.25,
    ),
    FilterOption(
      id: 9,
      name: 'Golden Hour',
      icon: Icons.wb_incandescent,
      description: 'Perfect golden hour lighting',
      overlayColor: const Color(0xFFFFB74D),
      blendMode: BlendMode.overlay,
      opacity: 0.3,
    ),
  ];
