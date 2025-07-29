import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShoppingCartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int, int) onQuantityChanged;
  final Function(int) onRemoveItem;
  final VoidCallback onCheckout;
  final VoidCallback onClose;

  const ShoppingCartWidget({
    super.key,
    required this.cartItems,
    required this.onQuantityChanged,
    required this.onRemoveItem,
    required this.onCheckout,
    required this.onClose,
  });

  double get totalAmount {
    return cartItems.fold(
        0.0,
        (sum, item) =>
            sum + ((item['price'] as int) * (item['quantity'] as int)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Корзина (${cartItems.length})',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Cart items
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'shopping_cart_outlined',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Ваша корзина пуста',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Добавьте товары для покупки',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 3.w),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Product image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CustomImageWidget(
                                imageUrl: item['image'] as String,
                                width: 20.w,
                                height: 20.w,
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(width: 3.w),

                            // Product details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 1.h),
                                  if (item['selectedSize'] != null)
                                    Text(
                                      'Размер: ${item['selectedSize']}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    '${item['price']} ₸',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity controls
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final currentQuantity =
                                            item['quantity'] as int;
                                        if (currentQuantity > 1) {
                                          onQuantityChanged(
                                              index, currentQuantity - 1);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: CustomIconWidget(
                                          iconName: 'remove',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 12.w,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      child: Text(
                                        '${item['quantity']}',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final currentQuantity =
                                            item['quantity'] as int;
                                        onQuantityChanged(
                                            index, currentQuantity + 1);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: CustomIconWidget(
                                          iconName: 'add',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                GestureDetector(
                                  onTap: () => onRemoveItem(index),
                                  child: CustomIconWidget(
                                    iconName: 'delete_outline',
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Checkout section
          if (cartItems.isNotEmpty)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итого:',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${totalAmount.toInt()} ₸',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.secondary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onSecondary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Оформить заказ',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
