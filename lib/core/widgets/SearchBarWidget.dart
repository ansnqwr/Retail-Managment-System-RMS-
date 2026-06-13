import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSearchBar();
  }
}

Widget _buildSearchBar() {
  return Container(
    child: SearchBar(
      hintText: 'Search here',
      hintStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      enabled: true,
      keyboardType: TextInputType.name,
      leading: Icon(Icons.search),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
      ),
      padding: WidgetStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
      backgroundColor: WidgetStateProperty.all(Colors.white),
      elevation: WidgetStatePropertyAll(0),
    ),
  );
}
