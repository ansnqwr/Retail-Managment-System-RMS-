// lib/core/widgets/FilterChipWidget.dart
import 'package:flutter/material.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> filters;
  final Function(Map<String, dynamic>) onRemoveFilter;

  const FilterChipsWidget({
    super.key,
    required this.filters,
    required this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chips = _buildChips();

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Wrap(
        spacing: 5,
        runSpacing: 0,
        children:
            chips.map((chip) {
              return Chip(
                label: Text(chip['label']),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  final updatedFilters = Map<String, dynamic>.from(filters);
                  updatedFilters.remove(chip['key']);
                  onRemoveFilter(updatedFilters);
                },
                backgroundColor: Colors.grey.shade200,
                side: BorderSide(color: Colors.grey.shade400),
                labelStyle: const TextStyle(
                  color: Color(0xFF6B2D5C),
                  fontSize: 10,
                ),
              );
            }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _buildChips() {
    final List<Map<String, dynamic>> chips = [];

    final priceRange = filters['priceRange'];
    if (priceRange != null && priceRange is RangeValues) {
      if (priceRange.start != 0 || priceRange.end != 1000) {
        chips.add({
          'key': 'priceRange',
          'label':
              '\$${priceRange.start.toStringAsFixed(0)} - \$${priceRange.end.toStringAsFixed(0)}',
        });
      }
    }

    if (filters['inStockOnly'] == true) {
      chips.add({'key': 'inStockOnly', 'label': 'In Stock'});
    }

    if (filters['category'] != null) {
      chips.add({'key': 'category', 'label': filters['category']});
    }

    if (filters['subCategory'] != null) {
      chips.add({'key': 'subCategory', 'label': filters['subCategory']});
    }

    if (filters['brand'] != null) {
      chips.add({'key': 'brand', 'label': filters['brand']});
    }

    if (filters['color'] != null) {
      chips.add({'key': 'color', 'label': filters['color']});
    }

    if (filters['governorate'] != null) {
      chips.add({'key': 'governorate', 'label': filters['governorate']});
    }

    if (filters['city'] != null) {
      chips.add({'key': 'city', 'label': filters['city']});
    }

    return chips;
  }
}
