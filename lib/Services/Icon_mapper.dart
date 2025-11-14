// lib/utils/icon_mapper.dart
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

IconData mapIcon(String name) {
  switch (name.toLowerCase()) {
    case 'home':
      return Iconsax.home;
    case 'clock':
    case 'service time':
      return Iconsax.clock;
    case 'video':
    case 'sermons':
      return Iconsax.video;
    case 'book':
    case 'bible':
      return Iconsax.book;
    case 'give':
    case 'wallet':
      return Iconsax.empty_wallet_tick;
    default:
      return Iconsax.component; // fallback
  }
}
