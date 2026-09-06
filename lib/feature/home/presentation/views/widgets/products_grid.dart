import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_pharmacy/feature/home/data/models/product_model.dart';

import 'package:smart_pharmacy/feature/home/presentation/views/widgets/Product_details_consumer.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/product_item.dart';


class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key, required this.items});

  final List<ProductModel> items;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: items.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
          ProductDetailsConsumer.routeName,
            arguments: items[index].id,
          );
        },
        child: ProductItem(product: items[index])),
    );
  }
}
