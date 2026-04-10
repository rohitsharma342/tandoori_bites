import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';
import '../data/static_data.dart';

class MenuProvider with ChangeNotifier {
  List<MenuItem> _menuItems = [];
  List<MenuItem> _filteredItems = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<MenuItem> get menuItems => _filteredItems.isEmpty && _searchQuery.isEmpty && _selectedCategory == 'All'
      ? _menuItems
      : _filteredItems;

  List<String> get categories => ['All', ...StaticData.categories];

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  MenuProvider() {
    loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _menuItems = StaticData.menuItems;
    _filteredItems = _menuItems;
    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredItems = _menuItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  List<MenuItem> getItemsByCategory(String category) {
    if (category == 'All') return _menuItems;
    return _menuItems.where((item) => item.category == category).toList();
  }

  MenuItem? getItemById(String id) {
    try {
      return _menuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}