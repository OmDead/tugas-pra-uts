import 'package:flutter/material.dart';
import '../providers/item_service.dart';
import '../models/item_model.dart';
import 'item_form.dart';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final ItemService _itemService = ItemService();
  late Future<List<Item>> _items;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() {
    _items = _itemService.getItems();
  }

  Future<void> _refreshItems() async {
    setState(() {
      _fetchItems();
    });
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _itemService.deleteItem(id);
      _refreshItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: $e')),
      );
    }
  }

  Future<void> _navigateToForm({Item? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemFormPage(item: item),
      ),
    );
    if (result == true) {
      _refreshItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
        actions: [
          IconButton(
            onPressed: () => _navigateToForm(),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: _refreshItems,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(186, 255, 230, 7),
      body: FutureBuilder<List<Item>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _navigateToForm(item: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(item.id.toString()),
                        ),
                      ],
                    ),
                    onTap: () {
                      _navigateToForm(item: item);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
