
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Product information
class Product {
  final String name;
  final String price;
  final String image;
  final String category;
  final String description;

  const Product({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });
}

// List of products
const List<Product> products = [
  Product(
    name: 'Classic Tote Bag',
    price: '₱850',
    image: 'assets/images/bag1.jpg',
    category: 'Bags',
    description: 'A simple and stylish tote bag for everyday use.',
  ),
  Product(
    name: 'Mini Shoulder Bag',
    price: '₱720',
    image: 'assets/images/bag2.jpg',
    category: 'Bags',
    description: 'A compact shoulder bag that is easy to carry.',
  ),
  Product(
    name: 'Minimal Watch',
    price: '₱1,250',
    image: 'assets/images/watch1.jpg',
    category: 'Watches',
    description: 'A minimal watch that matches different outfits.',
  ),
  Product(
    name: 'Classic Sunglasses',
    price: '₱450',
    image: 'assets/images/sunglasses1.jpg',
    category: 'Sunglasses',
    description: 'Classic sunglasses for a simple everyday look.',
  ),
  Product(
    name: 'Everyday Backpack',
    price: '₱990',
    image: 'assets/images/backpack.jpg',
    category: 'Bags',
    description: 'A useful backpack for school and daily activities.',
  ),
  Product(
    name: 'Retro Sunglasses',
    price: '₱520',
    image: 'assets/images/sunglasses2.jpg',
    category: 'Sunglasses',
    description: 'Retro-inspired sunglasses with a casual style.',
  ),
  Product(
    name: 'Silver Watch',
    price: '₱1,450',
    image: 'assets/images/watch2.jpg',
    category: 'Watches',
    description: 'A silver watch with a clean and timeless design.',
  ),
  Product(
    name: 'Casual Handbag',
    price: '₱890',
    image: 'assets/images/bag3.jpg',
    category: 'Bags',
    description: 'A casual handbag suitable for everyday outings.',
  ),
];

// Main application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  final Color seedColor = Colors.teal;

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Catalog',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      home: CatalogPage(
        isDarkMode: themeMode == ThemeMode.dark,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}

// Main catalog screen
class CatalogPage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const CatalogPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessories'),
        actions: [
          IconButton(
            tooltip: isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: onToggleTheme,
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width < 600) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductTile(product: products[index]);
              },
            );
          }

          final columns = width < 840 ? 2 : 3;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
}

// Product image
class ProductImage extends StatelessWidget {
  final Product product;
  final double? height;

  const ProductImage({
    super.key,
    required this.product,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      product.image,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      semanticLabel: product.name,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported, size: 40),
        );
      },
    );
  }
}

// Product tile for mobile list layout
class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProductDetailPage(product: product);
              },
            ),
          );
        },
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 125,
              child: ProductImage(product: product),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.price,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Product card for tablet and desktop grid layouts
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProductDetailPage(product: product);
              },
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 175,
              width: double.infinity,
              child: ProductImage(product: product),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.price,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Product detail screen
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ProductImage(
                product: product,
                height: 320,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.category,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              product.price,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}