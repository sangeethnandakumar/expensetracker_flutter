import 'package:flutter/material.dart';

class IconMapping {
  static const Map<String, IconData> iconMapping = {
    'food': Icons.restaurant,
    'repair': Icons.build,
    'shopping': Icons.shopping_cart,
    'fuel': Icons.local_gas_station,
    'home': Icons.home,
    'star': Icons.star,
    'work': Icons.work,
    'school': Icons.school,
    'favorite': Icons.favorite,
    'fitness_center': Icons.fitness_center,
    'local_dining': Icons.local_dining,
    'local_cafe': Icons.local_cafe,
    'local_bar': Icons.local_bar,
    'directions_car': Icons.directions_car,
    'flight': Icons.flight,
    'hotel': Icons.hotel,
    'movie': Icons.movie,
    'music_note': Icons.music_note,
    'photo': Icons.photo,
    'security': Icons.security,
    'sports_esports': Icons.sports_esports,
    'train': Icons.train,
    'weekend': Icons.weekend,
    // Add more icon mappings as needed
  };

  static IconData? getIcon(String? iconName) {
    return iconMapping[iconName];
  }

  static String? getIconName(IconData iconData) {
    return iconMapping.entries
        .firstWhere((entry) => entry.value == iconData, orElse: () => MapEntry('help', Icons.help))
        .key;
  }
}
