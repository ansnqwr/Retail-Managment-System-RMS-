import 'package:delni_rms/features/home/view%20model/store_details_bloc.dart';
import 'package:delni_rms/features/home/view%20model/store_details_event.dart';
import 'package:delni_rms/features/home/view%20model/store_details_repository.dart';
import 'package:delni_rms/features/home/view/store_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/src/client.dart';

import '/core/widgets/StoreCard.dart';
import 'package:flutter/material.dart';
import '../../features/home/Model/StoreCardItem.dart';

class StoreSilverGrid extends StatefulWidget {
  final List<StoreCardModel> stores;
  const StoreSilverGrid({super.key, required this.stores});

  @override
  State<StoreSilverGrid> createState() => _StoreSilverGridState();
}

class _StoreSilverGridState extends State<StoreSilverGrid> {
  Client? get client => null;

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
            onTap: () {

// context.read<HomeBloc>().add(HomeStoreTapped(store.id));

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (_) =>
                                StoreDetailsBloc(StoreDetailsRepository(client!))
                                  ..add(LoadStoreDetails(store.id)),
                        child: StoreDetailsScreen(storeId: store.id),
                      ),
                ),
              );


            },
            governorate: store.governorate,
            city: store.city,
            isVerified: store.isVerified,
            isBrand: store.isBrand,
            branchesCount: store.branches.length,
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
