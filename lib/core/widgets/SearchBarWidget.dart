import 'package:flutter/material.dart';

import '../../features/pagination/View/PaginationScreen.dart';

class SearchBarWidget extends StatefulWidget {
  final bool isFromHomePage;
  final String? prefillSearchText;
  final Function(String)? onSearch;

  const SearchBarWidget({
    super.key,
    required this.isFromHomePage,
    this.prefillSearchText,
    this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late List<String> _searchChips;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // post search chips

  // [
  // { 'chipText' : '' },
  // { 'chipText' : '' },
  // { 'chipText' : '' },
  // ]

  @override
  void initState() {
    super.initState();
    _searchChips = _parsePrefillText(widget.prefillSearchText);
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prefillSearchText != oldWidget.prefillSearchText) {
      _searchChips = _parsePrefillText(widget.prefillSearchText);
      _controller.clear();
    }
  }

  List<String> _parsePrefillText(String? text) {
    if (text == null || text.trim().isEmpty) return [];
    return text
        .split('/')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  void _removeChip(int index) {
    setState(() {
      _searchChips.removeAt(index);
    });
  }

  void _addChip(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _searchChips.add(text.trim());
      _controller.clear();
    });
    _scrollToEnd();
    if (widget.onSearch != null) {
      widget.onSearch!(text.trim());
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSearchBar();
  }

  Widget _buildSearchBar() {
    final primaryColor = const Color(0xFF6B2D5C);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: Colors.grey.shade500),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._searchChips.asMap().entries.map((entry) {
                    final index = entry.key;
                    final chip = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Chip(
                        label: Text(
                          chip,
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        deleteIcon: Icon(
                          Icons.close,
                          size: 14,
                          color: primaryColor,
                        ),
                        onDeleted: () => _removeChip(index),
                        backgroundColor: Colors.grey.shade200,
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    );
                  }),
                  SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: _searchChips.isEmpty ? 'Search here' : '',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      keyboardType: TextInputType.name,
                      onSubmitted: (value) {
                        widget.isFromHomePage == true
                            ? {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PaginationScreen(
                                        isProduct: false,
                                        isStore: false,
                                        isSubCategory: true,
                                        // hasSubCategories: sub.hasSubCategories,
                                        hasSubCategories: true,
                                        paginationTitle: value,
                                      ),
                                ),
                              ),
                              // _controller.text = '',
                            }
                            : _addChip(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
