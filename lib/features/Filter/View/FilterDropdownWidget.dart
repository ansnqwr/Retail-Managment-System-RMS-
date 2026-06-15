import 'package:flutter/material.dart';

class FilterDropdownWidget extends StatefulWidget {
  final List<String> categories;
  final Map<String, List<String>> subCategories;
  final List<String> brands;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterDropdownWidget({
    super.key,
    required this.categories,
    required this.subCategories,
    required this.brands,
    required this.onApplyFilters,
  });

  @override
  State<FilterDropdownWidget> createState() => _FilterDropdownWidgetState();
}

class _FilterDropdownWidgetState extends State<FilterDropdownWidget> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _inStockOnly = false;
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedBrand;
  String? _selectedColor;

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Red', 'value': Colors.red},
    {'name': 'Blue', 'value': Colors.blue},
    {'name': 'Green', 'value': Colors.green},
    {'name': 'Black', 'value': Colors.black},
    {'name': 'White', 'value': Colors.white},
    {'name': 'Yellow', 'value': Colors.yellow},
    {'name': 'Purple', 'value': Colors.purple},
    {'name': 'Orange', 'value': Colors.orange},
  ];

  void _applyFilters() {
    widget.onApplyFilters({
      'priceRange': _priceRange,
      'inStockOnly': _inStockOnly,
      'category': _selectedCategory,
      'subCategory': _selectedSubCategory,
      'brand': _selectedBrand,
      'color': _selectedColor,
    });
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 1000);
      _inStockOnly = false;
      _selectedCategory = null;
      _selectedSubCategory = null;
      _selectedBrand = null;
      _selectedColor = null;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Range Slider
            _buildSectionTitle('Price Range'),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 1000,
              divisions: 100,
              labels: RangeLabels(
                '\$${_priceRange.start.toStringAsFixed(0)}',
                '\$${_priceRange.end.toStringAsFixed(0)}',
              ),
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${_priceRange.start.toStringAsFixed(0)}'),
                Text('\$${_priceRange.end.toStringAsFixed(0)}'),
              ],
            ),
            const SizedBox(height: 20),

            // Availability
            _buildSectionTitle('Availability'),
            CheckboxListTile(
              title: const Text('In Stock Only'),
              value: _inStockOnly,
              onChanged: (value) {
                setState(() {
                  _inStockOnly = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            _buildSectionTitle('Category'),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text('Select Category'),
              isExpanded: true,
              items:
                  widget.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _selectedSubCategory = null;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),

            // SubCategory Dropdown
            if (_selectedCategory != null &&
                widget.subCategories.containsKey(_selectedCategory!)) ...[
              _buildSectionTitle('Sub Category'),
              DropdownButtonFormField<String>(
                value: _selectedSubCategory,
                hint: const Text('Select Sub Category'),
                isExpanded: true,
                items:
                    widget.subCategories[_selectedCategory!]!.map((sub) {
                      return DropdownMenuItem(value: sub, child: Text(sub));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Brand Dropdown
            _buildSectionTitle('Brand'),
            DropdownButtonFormField<String>(
              value: _selectedBrand,
              hint: const Text('Select Brand'),
              isExpanded: true,
              items:
                  widget.brands.map((brand) {
                    return DropdownMenuItem(value: brand, child: Text(brand));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Color Radio Buttons
            _buildSectionTitle('Color'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _colors.map((color) {
                    final isSelected = _selectedColor == color['name'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedColor = color['name'];
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color['value'],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child:
                            isSelected
                                ? Icon(
                                  Icons.check,
                                  color:
                                      color['name'] == 'White' ||
                                              color['name'] == 'Yellow'
                                          ? Colors.black
                                          : Colors.white,
                                  size: 20,
                                )
                                : null,
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
