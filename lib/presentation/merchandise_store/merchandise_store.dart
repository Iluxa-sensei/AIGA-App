import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_filter_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/shopping_cart_widget.dart';

class MerchandiseStore extends StatefulWidget {
  const MerchandiseStore({super.key});

  @override
  State<MerchandiseStore> createState() => _MerchandiseStoreState();
}

class _MerchandiseStoreState extends State<MerchandiseStore> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Все';
  List<Map<String, dynamic>> _cartItems = [];
  Map<String, dynamic> _currentFilters = {};
  bool _isSearching = false;

  final List<String> _categories = [
    'Все',
    'Рашгарды',
    'Шапки',
    'Перчатки',
    'Аксессуары'
    'Лонгслив'
  ];

  final List<Map<String, dynamic>> _mockProducts = [
    {
      "id": 1,
      "name": "Рашгард AIGA",
      "category": "Рашгарды",
      "price": 15000,
      "originalPrice": 18000,
      "discount": 17,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmEw3KU1St7jylvZArv7mTfFXZVe7o-uITUQ&s",
      "availableSizes": ["S", "M", "L", "XL"],
      "colors": ["Белый"],
      "rating": 4.8,
      "stock": 15,
      "isNewArrival": true,
      "isWishlisted": false,
      "description":
          "Профессиональный белый рашгард для тренировок по грэпплингу и ММА"
    },
    {
      "id": 2,
        "name": "Шапка AIGA",
        "category": "Шапки",
        "price": 12000,
        "originalPrice": null,
        "discount": null,
        "image":
        "https://res.cloudinary.com/du1lmawkd/image/upload/v1753559750/7C1D75DE-CFAB-4248-BA5E-BE6391615883_tvss6l.png",
      "availableSizes": ["M", "L", "XL", "XXL"],
      "colors": ["Черный", "Серый"],
      "rating": 4.6,
      "stock": 8,
      "isNewArrival": false,
      "isWishlisted": true,
      "description": "Теплые шапки"
    },
    {
      "id": 3,
      "name": "Перчатки для грэпплинга",
      "category": "Перчатки",
      "price": 8500,
      "originalPrice": 10000,
      "discount": 15,
      "image":
          "https://images.pexels.com/photos/4761663/pexels-photo-4761663.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availableSizes": ["S", "M", "L"],
      "colors": ["Черный"],
      "rating": 4.7,
      "stock": 0,
      "isNewArrival": false,
      "isWishlisted": false,
      "description": "Профессиональные перчатки для грэпплинга"
    },
    {
      "id": 4,
      "name": "Защита голени AIGA",
      "category": "Аксессуары",
      "price": 6500,
      "originalPrice": null,
      "discount": null,
      "image":
          "https://images.pexels.com/photos/6456297/pexels-photo-6456297.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availableSizes": ["S", "M", "L"],
      "colors": ["Черный", "Белый"],
      "rating": 4.5,
      "stock": 12,
      "isNewArrival": true,
      "isWishlisted": false,
      "description": "Надежная защита голени для спаррингов"
    },
    {
      "id": 5,
      "name": "Рашгард Training Pro",
      "category": "Рашгарды",
      "price": 13500,
      "originalPrice": null,
      "discount": null,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRksraNCNgDEfv75EaDjFLAyWMAPNDI2ZgLe1HdnMWAlCtJe3pt7UX4RbldvbktFU2u9kc&usqp=CAU",
      "availableSizes": ["XS", "S", "M", "L"],
      "colors": ["Синий", "Черный"],
      "rating": 4.4,
      "stock": 20,
      "isNewArrival": false,
      "isWishlisted": false,
      "description": "Тренировочный рашгард для ежедневных занятий"
    },
    {
      "id": 6,
      "name": "Лонгслив",
      "category": "Лонгслив",
      "price": 14500,
      "originalPrice": 16000,
      "discount": 9,
      "image":
      "https://res.cloudinary.com/du1lmawkd/image/upload/v1753559866/94B8E056-2123-4F06-A876-5FA5F4F1518A_fnqgse.png",
      "availableSizes": ["M", "L", "XL"],
      "colors": ["Черный"],
      "rating": 4.9,
      "stock": 5,
      "isNewArrival": false,
      "isWishlisted": true,
      "description": "Черный лонгслив"
    },
    {
      "id": 7,
      "name": "Рашгард Al Leone",
      "category": "Рашгарды",
      "price": 13500,
      "originalPrice": null,
      "discount": null,
      "image":
      "https://cdn.shopify.com/s/files/1/0658/9533/4125/files/88_23948f43-b36e-4121-9fae-72e57d28bd83_480x480.png?v=1724221692",
      "availableSizes": ["XS", "S", "M", "L"],
      "colors": ["Фиолетовый"],
      "rating": 4.9,
      "stock": 20,
      "isNewArrival": false,
      "isWishlisted": false,
      "description": "Тренировочный рашгард "
    }
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> products = List.from(_mockProducts);

    // Category filter
    if (_selectedCategory != 'Все') {
      products = products
          .where((product) => product['category'] == _selectedCategory)
          .toList();
    }

    // Search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      products = products
          .where((product) =>
              (product['name'] as String).toLowerCase().contains(searchTerm) ||
              (product['description'] as String)
                  .toLowerCase()
                  .contains(searchTerm))
          .toList();
    }

    // Apply filters
    if (_currentFilters.isNotEmpty) {
      products = products.where((product) {
        // Price filter
        final price = product['price'] as int;
        if (price < (_currentFilters['minPrice'] ?? 0) ||
            price > (_currentFilters['maxPrice'] ?? 50000)) {
          return false;
        }

        // Size filter
        if (_currentFilters['size'] != null &&
            _currentFilters['size'] != 'Все') {
          final availableSizes = product['availableSizes'] as List;
          if (!availableSizes.contains(_currentFilters['size'])) {
            return false;
          }
        }

        // Color filter
        if (_currentFilters['color'] != null &&
            _currentFilters['color'] != 'Все') {
          final colors = product['colors'] as List;
          if (!colors.contains(_currentFilters['color'])) {
            return false;
          }
        }

        // Rating filter
        final rating = product['rating'] as double;
        if (rating < (_currentFilters['minRating'] ?? 0.0)) {
          return false;
        }

        return true;
      }).toList();

      // Sort products
      final sortBy = _currentFilters['sortBy'] ?? 'Популярность';
      switch (sortBy) {
        case 'Цена: по возрастанию':
          products
              .sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
          break;
        case 'Цена: по убыванию':
          products
              .sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
          break;
        case 'Рейтинг':
          products.sort((a, b) =>
              (b['rating'] as double).compareTo(a['rating'] as double));
          break;
        case 'Новинки':
          products.sort((a, b) => (b['isNewArrival'] as bool ? 1 : 0)
              .compareTo(a['isNewArrival'] as bool ? 1 : 0));
          break;
      }
    }

    return products;
  }

  int get _cartItemCount {
    return _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    _showProductDetailBottomSheet(product);
  }

  void _toggleWishlist(Map<String, dynamic> product) {
    setState(() {
      final index = _mockProducts.indexWhere((p) => p['id'] == product['id']);
      if (index != -1) {
        _mockProducts[index]['isWishlisted'] =
            !(_mockProducts[index]['isWishlisted'] as bool);
      }
    });
  }

  void _addToCart(Map<String, dynamic> product,
      {String? selectedSize, int quantity = 1}) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) =>
          item['id'] == product['id'] && item['selectedSize'] == selectedSize);

      if (existingIndex != -1) {
        _cartItems[existingIndex]['quantity'] =
            (_cartItems[existingIndex]['quantity'] as int) + quantity;
      } else {
        _cartItems.add({
          'id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'image': product['image'],
          'selectedSize': selectedSize,
          'quantity': quantity,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} добавлен в корзину'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShoppingCartWidget(
        cartItems: _cartItems,
        onQuantityChanged: (index, quantity) {
          setState(() {
            _cartItems[index]['quantity'] = quantity;
          });
        },
        onRemoveItem: (index) {
          setState(() {
            _cartItems.removeAt(index);
          });
        },
        onCheckout: () {
          Navigator.pop(context);
          _showCheckoutDialog();
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showProductDetailBottomSheet(Map<String, dynamic> product) {
    String? selectedSize;
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 85.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20.0)),
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
                      'Детали товара',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: AppTheme.lightTheme.colorScheme.surface,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CustomImageWidget(
                            imageUrl: product['image'] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Product name and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'star',
                                color: Colors.amber,
                                size: 20,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${product['rating']}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Price
                      Row(
                        children: [
                          if (product['discount'] != null)
                            Text(
                              '${product['originalPrice']} ₸',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          if (product['discount'] != null) SizedBox(width: 2.w),
                          Text(
                            '${product['price']} ₸',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Description
                      Text(
                        'Описание',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        product['description'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),

                      SizedBox(height: 3.h),

                      // Size selection
                      if (product['availableSizes'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Размер',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Wrap(
                              spacing: 2.w,
                              runSpacing: 1.h,
                              children: (product['availableSizes'] as List)
                                  .map((size) {
                                final isSelected = size == selectedSize;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      selectedSize = size;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.secondary
                                          : AppTheme
                                              .lightTheme.colorScheme.surface,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.lightTheme.colorScheme
                                                .secondary
                                            : AppTheme
                                                .lightTheme.colorScheme.outline,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      size.toString(),
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: isSelected
                                            ? AppTheme.lightTheme.colorScheme
                                                .onSecondary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),

                      // Quantity selector
                      Text(
                        'Количество',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setModalState(() {
                                  quantity--;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: CustomIconWidget(
                                iconName: 'remove',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: 20.w,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Text(
                              '$quantity',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: CustomIconWidget(
                                iconName: 'add',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Add to cart button
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (product['stock'] as int) > 0
                        ? () {
                            _addToCart(product,
                                selectedSize: selectedSize, quantity: quantity);
                            Navigator.pop(context);
                          }
                        : null,
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
                      (product['stock'] as int) > 0
                          ? 'Добавить в корзину'
                          : 'Нет в наличии',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Оформление заказа',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите способ оплаты:',
              style: AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'credit_card',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Kaspi Pay'),
              onTap: () {
                Navigator.pop(context);
                _processPayment('Kaspi Pay');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'payment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Банковская карта'),
              onTap: () {
                Navigator.pop(context);
                _processPayment('Банковская карта');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _processPayment(String paymentMethod) {
    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
            SizedBox(height: 2.h),
            Text('Обработка платежа...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      setState(() {
        _cartItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Заказ успешно оформлен! Номер заказа: #${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'),
          duration: const Duration(seconds: 3),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Поиск товаров...',
                  border: InputBorder.none,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.7),
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
                onChanged: (value) => setState(() {}),
              )
            : Text('Магазин'),
        actions: [
          if (!_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
          Stack(
            children: [
              IconButton(
                onPressed: _showCartBottomSheet,
                icon: CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 5.w,
                      minHeight: 5.w,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: Column(
          children: [
            // Category filters
            CategoryFilterWidget(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: _onCategorySelected,
            ),

            // Filter and sort bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredProducts.length} товаров',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterBottomSheet,
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'tune',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Фильтры',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Product grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'search_off',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 64,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Товары не найдены',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Попробуйте изменить фильтры или поисковый запрос',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(2.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 2.w,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCardWidget(
                          product: product,
                          onTap: () => _onProductTap(product),
                          onWishlistToggle: () => _toggleWishlist(product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _cartItemCount > 0
          ? FloatingActionButton(
              onPressed: _showCartBottomSheet,
              child: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    size: 24,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 4.w,
                        minHeight: 4.w,
                      ),
                      child: Text(
                        '$_cartItemCount',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 8.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
