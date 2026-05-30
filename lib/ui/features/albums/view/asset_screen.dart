import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';

class AssetScreen extends StatelessWidget {
  const AssetScreen({super.key, required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Image.network(
          asset.previewUri,
          headers: asset.headers,
          fit: BoxFit.contain,
        ),
      ),
      bottomNavigationBar: BottomAppBar(color: Colors.black),
    );
  }
}
