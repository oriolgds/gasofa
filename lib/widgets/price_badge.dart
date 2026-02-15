/// Price badge widget with color-coded indicator
library;

import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../providers/gas_stations_provider.dart';

class PriceBadge extends StatelessWidget {
  final double? price;
  final PriceCategory category;

  const PriceBadge({super.key, required this.price, required this.category});

  Color get backgroundColor {
    switch (category) {
      case PriceCategory.low:
        return AppColors.priceGood.withOpacity(0.15);
      case PriceCategory.medium:
        return AppColors.priceMedium.withOpacity(0.15);
      case PriceCategory.high:
        return AppColors.priceHigh.withOpacity(0.15);
      case PriceCategory.unknown:
        return Colors.grey.withOpacity(0.15);
    }
  }

  Color get textColor {
    switch (category) {
      case PriceCategory.low:
        return AppColors.priceGood;
      case PriceCategory.medium:
        return AppColors.priceMedium;
      case PriceCategory.high:
        return AppColors.priceHigh;
      case PriceCategory.unknown:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            price != null ? price!.toStringAsFixed(3) : '-',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            '€/L',
            style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
