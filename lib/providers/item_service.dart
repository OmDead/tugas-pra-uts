import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/item_model.dart';

class ItemService {
  static const String baseUrl =
      'https://6727ddfc270bd0b97553c3c7.mockapi.io/api/v1/items';

  Future<List<Item>> getItems() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Item.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading items: $e');
    }
  }

  Future<Item> createItem(Item item) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(item.toJson()),
      );
      if (response.statusCode == 201) {
        return Item.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating item: $e');
    }
  }

  Future<Item> updateItem(Item item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${item.id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(item.toJson()),
      );
      if (response.statusCode == 200) {
        return Item.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating item: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }
}
