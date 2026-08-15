import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> filters;
  final Function(String) onRemoveFilter;
  final VoidCallback? onClearAllFilters;

  const FilterChipsWidget({
    super.key,
    required this.filters,
    required this.onRemoveFilter,
    this.onClearAllFilters,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chips = _buildChips();

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onClearAllFilters != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: onClearAllFilters,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B2D5C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6B2D5C).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list_off,
                        size: 14,
                        color: const Color(0xFF6B2D5C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Clear All'.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B2D5C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Wrap(
            spacing: 5,
            runSpacing: 0,
            children:
                chips.map((chip) {
                  return Chip(
                    label: Text(chip['label'.tr()]),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () {
                      onRemoveFilter(chip['key']);
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
        ],
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

    if (filters['inStockOnly'] == true || filters['inStockOnly'] == null) {
      if (filters.containsKey('inStockOnly')) {
        chips.add({'key': 'inStockOnly', 'label': 'In Stock'.tr()});
      }
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
