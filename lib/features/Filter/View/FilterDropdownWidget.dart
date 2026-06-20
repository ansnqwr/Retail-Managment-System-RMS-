import 'package:flutter/material.dart';
import '../../../core/widgets/ColorCircleWidget.dart';
import '../../../core/widgets/DropDownListWidget.dart';

class FilterDropdownWidget extends StatefulWidget {
  final bool isStore;
  final bool isSubCategory;
  final List<String> categories;
  final Map<String, List<String>> subcategories;
  final List<String> brands;
  final List<String> governorates;
  final Map<String, List<String>> cities;

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
  });

  @override
  State<FilterDropdownWidget> createState() => _FilterDropdownWidgetState();
}

class _FilterDropdownWidgetState extends State<FilterDropdownWidget> {
  // int minPrice
  // int maxPrice
  // List<Map<String,dynamic>> brands [{'title':'Adidas','id':1},{'title':'Puma','id':2}]
  // List<Map<String,dynamic>> colors [{'name':'red','id':1},{'name':'blue','id':2}]
  // List<Map<String,dynamic>> categories [{ 'id': 1,'title' : 'electronics','hasSubCategories' : true,'subcategories' : [{ 'id': 11,'title' : 'electronics','subcategories' : [],'hasSubCategories' : false},] },]
  // List<Map<String,dynamic>> governorates [{ 'id': 1,'title' : 'Homs','cities' : [{ 'id': 11,'title' : 'Hamidieh'}] },]
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _inStockOnly = false;
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedBrand;
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedColor;

  // get filter colors
  // [
  //   {'name': 'Red', 'value': Colors.red},
  //   {'name': 'Blue', 'value': Colors.blue},
  //   {'name': 'Green', 'value': Colors.green},
  // ]

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

  // post apply filter
  //   'priceRange': _priceRange,
  //   'inStockOnly': _inStockOnly,
  //   'category': _selectedCategory,
  //   'subCategory': _selectedSubCategory,
  //   'brand': _selectedBrand,
  //   'color': _selectedColor,
  //   'governorate' : _selectedGovernorate,
  //   'city': _selectedCity

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

  // post reset filters

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 1000);
      _inStockOnly = false;
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
                : SizedBox(),

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
                            : Expanded(child: SizedBox()),
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
                            : Expanded(child: const SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                )
                : SizedBox(),

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
                    : Expanded(child: SizedBox()),
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
                    : Expanded(child: const SizedBox()),
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
                          _colors.map((color) {
                            final isSelected = _selectedColor == color['name'];
                            return ColorCircleWidget(
                              color: color,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedColor = color['name'];
                                });
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                )
                : SizedBox(),

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
