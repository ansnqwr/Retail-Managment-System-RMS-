// lib/features/home/presentation/Favorites.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delni_rms/features/home/view model/favorites_bloc.dart';
import 'package:delni_rms/features/home/view model/favorites_state.dart';
import 'package:delni_rms/features/home/view model/favorites_event.dart'; // استيراد واحد فقط

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.favoriteProductIds.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }
          return ListView.builder(
            itemCount: state.favoriteProductIds.length,
            itemBuilder: (context, index) {
              final id = state.favoriteProductIds.elementAt(index);
              return ListTile(
                title: Text('Product ID: $id'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<FavoritesBloc>().add(
                      FavoriteToggled(id, true),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
