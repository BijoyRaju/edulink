import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2, 
      itemBuilder: (_, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              color: Colors.white,
            ),
            title: Container(
              height: 16,
              width: double.infinity,
              color: Colors.white,
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 8),
              height: 14,
              width: 150,
              color: Colors.white,
            ),
            trailing: Container(
              height: 16,
              width: 60,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
