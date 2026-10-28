import 'package:flutter/cupertino.dart';

class IconHelper {
  static IconData getCupertinoIcon(String iconCode) {
    switch (iconCode) {
      case 'cart_fill':
        return CupertinoIcons.cart_fill;
      case 'car_fill':
        return CupertinoIcons.car_detailed;
      case 'bag_fill':
        return CupertinoIcons.bag_fill;
      case 'bolt_fill':
        return CupertinoIcons.bolt_fill;
      case 'house_fill':
        return CupertinoIcons.house_fill;
      case 'game_controller_solid':
        return CupertinoIcons.game_controller_solid;
      case 'heart_fill':
        return CupertinoIcons.heart_fill;
      case 'book_fill':
        return CupertinoIcons.book_fill;
      case 'money_dollar_circle_fill':
        return CupertinoIcons.money_dollar_circle_fill;
      case 'gift_fill':
        return CupertinoIcons.gift_fill;
      case 'graph_circle_fill':
        return CupertinoIcons.graph_circle_fill;
      case 'creditcard_fill':
        return CupertinoIcons.creditcard_fill;
      case 'plus_circle_fill':
        return CupertinoIcons.plus_circle_fill;
      case 'ellipsis_circle_fill':
      default:
        return CupertinoIcons.ellipsis_circle_fill;
    }
  }

  static Color parseHexColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return CupertinoColors.activeBlue;
    }
  }
}
