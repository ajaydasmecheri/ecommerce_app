import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Fashion extends StatefulWidget {
  const Fashion({super.key});

  @override
  State<Fashion> createState() => _FashionState();
}

class _FashionState extends State<Fashion> {
  final CollectionReference productslist=FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("df")
      
      
    );
  }
}