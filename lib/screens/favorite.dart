import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Products"),
        backgroundColor: const Color.fromARGB(255, 164, 142, 203),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("favorite")
            .where("useremail", isEqualTo: FirebaseAuth.instance.currentUser?.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final data = snapshot.data?.docs;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data!.isEmpty) {
            return const Center(child: Text("There are no products in favorite"));
          } else {
            double totalPrice = 0.0;
            for (var doc in data) {
              totalPrice += double.parse(doc["price"]);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final favoriteinfo = data[index].data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.network(favoriteinfo["image"]),
                              title: Text(favoriteinfo["productname"]),
                              subtitle: Text('₹ ${favoriteinfo["price"]}'),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .doc("favorite/${data[index].id}")
                                            .delete();
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    'Total Price: ₹ ${totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
