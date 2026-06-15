import 'package:delni_rms/core/widgets/StoreCard.dart';
import 'package:flutter/material.dart';
import '../../features/pagination/Model/StoreCardItem.dart';

class StoreSilverGrid extends StatefulWidget {
  final List<StoreCardModel> stores;
  const StoreSilverGrid({super.key, required this.stores});

  @override
  State<StoreSilverGrid> createState() => _StoreSilverGridState();
}

class _StoreSilverGridState extends State<StoreSilverGrid> {
  @override
  Widget build(BuildContext context) {
    return _storeGridSliver(widget.stores);
  }

  Widget _storeGridSliver(List<StoreCardModel> stores) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final store = stores[index];
          return StoreCard(
            imageUrl: store.imageUrl,
            title: store.title,
            isNew: store.isNew,
            width: double.infinity,
            onTap: () {},
            governorate: store.governorate,
            city: store.city,
            isVerified: store.isVerified,
            isBrand: store.isBrand,
          );
        }, childCount: stores.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
      ),
    );
  }
}
