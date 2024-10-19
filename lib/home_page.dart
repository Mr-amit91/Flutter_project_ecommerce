
import 'package:flutter/material.dart';
import 'product_form.dart';
import 'shared_preferences_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _products = [];
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _prefsService.getProducts();
    setState(() {
      _products = products;
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
    _prefsService.saveProducts(_products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _products = _products
                      .where((product) =>
                          product['name'].toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: _products.isEmpty
                ? const Center(child: Text('No Product Found'))
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text('Price: \$${product['price']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProduct(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductForm()),
          );
          _loadProducts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
