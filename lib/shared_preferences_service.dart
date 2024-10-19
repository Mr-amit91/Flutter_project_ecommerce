
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesService {
  static const String _productsKey = 'products';

  Future<void> addProduct(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    final products = await getProducts();
    products.add(product);
    await prefs.setString(_productsKey, jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getString(_productsKey);
    if (productsString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(productsString));
    }
    return [];
  }

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_productsKey, jsonEncode(products));
  }
}
