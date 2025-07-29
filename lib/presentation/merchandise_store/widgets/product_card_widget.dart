import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onWishlistToggle;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWishlisted = product['isWishlisted'] ?? false;
    final bool hasDiscount =
        product['discount'] != null && (product['discount'] as int) > 0;
    final bool isNewArrival = product['isNewArrival'] ?? false;
    final bool isOutOfStock = product['stock'] == 0;

    return GestureDetector(
        onTap: isOutOfStock ? null : onTap,
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with badges
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12.0)),
                        color: AppTheme.lightTheme.colorScheme.surface,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12.0)),
                        child: CustomImageWidget(
                          imageUrl: product['image'] as String,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Out of stock overlay
                    if (isOutOfStock)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.8),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12.0)),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Нет в наличии',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onError,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Badges
                    Positioned(
                      top: 2.w,
                      left: 2.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasDiscount)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme
                                    .secondary,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                '-${product['discount']}%',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                  AppTheme.lightTheme.colorScheme.onSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (isNewArrival)
                            Container(
                              margin: EdgeInsets.only(top: hasDiscount
                                  ? 1.w
                                  : 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                'Новинка',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                  AppTheme.lightTheme.colorScheme.onTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Wishlist button
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: GestureDetector(
                        onTap: onWishlistToggle,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface
                                .withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName:
                            isWishlisted ? 'favorite' : 'favorite_border',
                            color: isWishlisted
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        Text(
                          product['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 1.h),

                        // Size availability
                        if (product['availableSizes'] != null)
                          Wrap(
                            spacing: 1.w,
                            children: (product['availableSizes'] as List)
                                .take(3)
                                .map((size) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.lightTheme.colorScheme
                                        .outline,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  size.toString(),
                                  style: AppTheme.lightTheme.textTheme
                                      .labelSmall,
                                ),
                              );
                            }).toList(),
                          ),

                        SizedBox(height: 1.h),

                        // Price
                        Row(
                          children: [
                            if (hasDiscount)
                              Text(
                                '${product['originalPrice']} ₸',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            if (hasDiscount) SizedBox(width: 2.w),
                            Text(
                              '${product['price']} ₸',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme
                                    .secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}