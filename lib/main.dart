import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

final _products = [
  Product(name: "iphone", price: 999),
  Product(name: "BMW", price: 99999),
  Product(name: "cigars", price: 2),
];

final productsProvider = Provider<List<Product>>((ref) {
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      return _products.sorted((a, b) => a.name.compareTo(b.name));
    case ProductSortType.price:
      return _products.sorted((a, b) => a.price.compareTo(b.price));
  }
});

enum ProductSortType {
  name,
  price,
}

final productSortTypeProvider = StateProvider<ProductSortType>(
  // We return the default sort type, here name.
  (ref) => ProductSortType.name,
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          DropdownButton<ProductSortType>(
            value: ref.watch(productSortTypeProvider),
            onChanged: (value) =>
                ref.read(productSortTypeProvider.notifier).state = value!,
            items: const [
              DropdownMenuItem(
                value: ProductSortType.name,
                child: Icon(Icons.sort_by_alpha),
              ),
              DropdownMenuItem(
                value: ProductSortType.price,
                child: Icon(Icons.sort),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('${product.price}\$'),
            );
          }),
    );
  }
}
