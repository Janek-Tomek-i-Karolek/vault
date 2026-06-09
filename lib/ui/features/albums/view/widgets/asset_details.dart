import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';

class AssetDetails extends StatelessWidget {
  final Asset asset;
  final double minHeight;

  const AssetDetails({super.key, required this.asset, required this.minHeight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: minHeight,
      child: ColoredBox(
        color: theme.colorScheme.primary,
        child: Center(child: Text("dupa jasiu")),
      ),
    );
  }
}
