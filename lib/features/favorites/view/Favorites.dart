// lib/features/home/presentation/Favorites.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../products/view/ProductDetailsScreen.dart';
import '../model/favoritesModel.dart';
import '../view model/favorites_bloc.dart';
import '../view model/favorites_event.dart';
import '../view model/favorites_state.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    // Fetch data every time the page is entered
    context.read<FavoritesBloc>().add(const FavoritesStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<FavoritesBloc>().add(const FavoritesStarted());
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesBloc>().add(
                        const FavoritesStarted(),
                      );
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.products.isEmpty) {
            return Center(
              child: Text(
                'No favorites added yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoritesBloc>().add(const FavoritesStarted());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = state.products[index];
                return InkWell(
                  onTap: () {
                    context.read<FavoritesBloc>().add(
                      FavoritesProductTapped(product.id),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProductDetailsScreen(productId: product.id),
                      ),
                    );
                  },
                  child: _FavoriteCard(product: product),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Product product;

  const _FavoriteCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.formattedPrice} IQD',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (product.isOnSale)
                    Text(
                      '-${product.discount}%',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                context.read<FavoritesBloc>().add(
                  FavoriteToggled(product.id, true),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
