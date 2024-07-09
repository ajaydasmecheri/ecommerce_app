import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  bool isFavorite = false;
  final String productId = "example_product_id"; // Replace with your actual product ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Page'),
      ),
      body: Center(
        child: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () async {
            setState(() {
              isFavorite = !isFavorite;
            });

            if (isFavorite) {
              await addToFavorites(productId);
            } else {
              await removeFromFavorites(productId);
            }
          },
        ),
      ),
    );
  }

  Future<void> addToFavorites(String productId) async {
    await FirebaseFirestore.instance.collection('favorites').doc(productId).set({
      'productId': productId,
      // Add other product details here
    });
  }

  Future<void> removeFromFavorites(String productId) async {
    await FirebaseFirestore.instance.collection('favorites').doc(productId).delete();
  }
}
