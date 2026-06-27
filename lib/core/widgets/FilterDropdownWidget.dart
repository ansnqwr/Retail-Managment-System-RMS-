import 'package:flutter/material.dart';
import 'ColorCircleWidget.dart';
import 'DropDownListWidget.dart';
import '../../features/pagination/Model/FiltersModel.dart';

class FilterDropdownWidget extends StatefulWidget {
  final bool isStore;
  final bool isSubCategory;
  final List<String> categories;
  final Map<String, List<String>> subcategories;
  final List<String> brands;
  final List<String> governorates;
  final Map<String, List<String>> cities;
  final List<ColorOption> colors;
  final Map<String, dynamic>? initialFilters;
  final double minPrice;
  final double maxPrice;

  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterDropdownWidget({
    super.key,
    required this.categories,
    required this.subcategories,
    required this.brands,
    required this.onApplyFilters,
    required this.governorates,
    required this.cities,
    required this.isStore,
    required this.isSubCategory,
    required this.colors,
    this.initialFilters,
    required this.maxPrice,
    required this.minPrice,
  });

  @override
  State<FilterDropdownWidget> createState() => _FilterDropdownWidgetState();
}

class _FilterDropdownWidgetState extends State<FilterDropdownWidget> {
  late RangeValues _priceRange;
  late bool _inStockOnly;
  late String? _selectedCategory;
  late String? _selectedSubCategory;
  late String? _selectedBrand;
  late String? _selectedGovernorate;
  late String? _selectedCity;
  late String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _initializeFromFilters();
  }

  void _initializeFromFilters() {
    final filters = widget.initialFilters ?? {};

    final priceRange = filters['priceRange'];
    if (priceRange != null && priceRange is RangeValues) {
      _priceRange = priceRange;
    } else {
      _priceRange = RangeValues(widget.minPrice, widget.maxPrice);
    }

    _inStockOnly =
        filters['inStockOnly'] == true || filters['inStockOnly'] == null;

    _selectedCategory = filters['category'];
    _selectedSubCategory = filters['subCategory'];
    _selectedBrand = filters['brand'];
    _selectedGovernorate = filters['governorate'];
    _selectedCity = filters['city'];
    _selectedColor = filters['color'];
  }

  void _applyFilters() {
    widget.onApplyFilters({
      'priceRange': _priceRange,
      'inStockOnly': _inStockOnly,
      'category': _selectedCategory,
      'subCategory': _selectedSubCategory,
      'brand': _selectedBrand,
      'color': _selectedColor,
      'governorate': _selectedGovernorate,
      'city': _selectedCity,
    });
  }

  void _resetFilters() {
    setState(() {
      _priceRange = RangeValues(widget.minPrice, widget.maxPrice);
      _inStockOnly = true;
      _selectedCategory = null;
      _selectedSubCategory = null;
      _selectedBrand = null;
      _selectedColor = null;
      _selectedGovernorate = null;
      _selectedCity = null;
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
            widget.isStore == false
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilterWidgetHelpers.buildSectionTitle('Price Range'),
                    RangeSlider(
                      values: _priceRange,
                      min: widget.minPrice,
                      max: widget.maxPrice,
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

                    FilterWidgetHelpers.buildSectionTitle('Availability'),
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
                  ],
                )
                : const SizedBox(),

            widget.isSubCategory == false
                ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FilterWidgetHelpers.buildSectionTitle(
                            'Category',
                          ),
                        ),
                        const SizedBox(width: 12),

                        (_selectedCategory != null &&
                                widget.subcategories.containsKey(
                                  _selectedCategory!,
                                ))
                            ? Expanded(
                              child: FilterWidgetHelpers.buildSectionTitle(
                                'Sub Category',
                              ),
                            )
                            : const Expanded(child: SizedBox()),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropDownListWidget(
                            value: _selectedCategory,
                            hint: 'Select Category',
                            items: widget.categories,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                                _selectedSubCategory = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        (_selectedCategory != null &&
                                widget.subcategories.containsKey(
                                  _selectedCategory!,
                                ))
                            ? Expanded(
                              child: DropDownListWidget(
                                value: _selectedSubCategory,
                                hint: 'Select Sub Category',
                                items:
                                    widget.subcategories[_selectedCategory!]!,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSubCategory = value;
                                  });
                                },
                              ),
                            )
                            : const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                )
                : const SizedBox(),

            Row(
              children: [
                Expanded(
                  child: FilterWidgetHelpers.buildSectionTitle('Governorate'),
                ),
                const SizedBox(width: 12),

                (_selectedGovernorate != null &&
                        widget.cities.containsKey(_selectedGovernorate!))
                    ? Expanded(
                      child: FilterWidgetHelpers.buildSectionTitle('City'),
                    )
                    : const Expanded(child: SizedBox()),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropDownListWidget(
                    value: _selectedGovernorate,
                    hint: 'Select Governorate',
                    items: widget.governorates,
                    onChanged: (value) {
                      setState(() {
                        _selectedGovernorate = value;
                        _selectedCity = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                (_selectedGovernorate != null &&
                        widget.cities.containsKey(_selectedGovernorate!))
                    ? Expanded(
                      child: DropDownListWidget(
                        value: _selectedCity,
                        hint: 'Select City',
                        items: widget.cities[_selectedGovernorate!]!,
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                          });
                        },
                      ),
                    )
                    : const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 16),

            FilterWidgetHelpers.buildSectionTitle('Brand'),
            DropDownListWidget(
              value: _selectedBrand,
              hint: 'Select Brand',
              items: widget.brands,
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value;
                });
              },
            ),
            const SizedBox(height: 20),

            widget.isStore == false
                ? Column(
                  children: [
                    FilterWidgetHelpers.buildSectionTitle('Color'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          widget.colors.map((colorOption) {
                            final isSelected =
                                _selectedColor == colorOption.name;
                            return _ColorCircleFromBackend(
                              colorOption: colorOption,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedColor = colorOption.name;
                                });
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                )
                : const SizedBox(),

            Row(
              children: [
                Expanded(
                  child: FilterWidgetHelpers.buildActionButton(
                    onPressed: _resetFilters,
                    label: 'Reset',
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilterWidgetHelpers.buildActionButton(
                    onPressed: _applyFilters,
                    label: 'Apply',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorCircleFromBackend extends StatelessWidget {
  final ColorOption colorOption;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCircleFromBackend({
    required this.colorOption,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colorOption.colorValue,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF6B2D5C) : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF6B2D5C).withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child:
            isSelected
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : null,
      ),
    );
  }
}

class FilterWidgetHelpers {
  static Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static Widget buildActionButton({
    required VoidCallback onPressed,
    required String label,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return OutlinedButton(onPressed: onPressed, child: Text(label));
    }
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
