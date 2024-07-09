import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybuy/routers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:input_quantity/input_quantity.dart';

class Productbuyview extends StatefulWidget {
  const Productbuyview({super.key});

  @override
  State<Productbuyview> createState() => _ProductbuyviewState();
}

class _ProductbuyviewState extends State<Productbuyview> {
  dynamic tf = 0;
  dynamic rating = 0;
  dynamic productquantity = 0;

  final CollectionReference ratinginfo =
      FirebaseFirestore.instance.collection("rating");

  @override
  Widget build(BuildContext context) {
    final productargs = ModalRoute.of(context)!.settings.arguments as Map?;

    TextEditingController comments = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("product details"),
        backgroundColor: const Color.fromARGB(255, 164, 142, 203),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Container(
                  height: 450,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 3))
                      ]),
                  child: Column(
                    children: [
                      Container(
                        child: Image.network(productargs?["image"]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        productargs?["productname"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        productargs?["price"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputQty(
                        maxVal: 10,
                        initVal: 0,
                        minVal: 1,
                        steps: 1,
                        onQtyChanged: (val) {
                          var totalPrice =
                              double.parse(productargs?["price"]) * val;

                          setState(() {
                            tf = totalPrice;
                            productquantity = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Total price: ₹ ${tf.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection("cart").add({
                        "productname": productargs?["productname"],
                        "price": productargs?["price"],
                        "image": productargs?["image"],
                        "totalprice": tf,
                        "productquantity": productquantity,
                        "useremail": FirebaseAuth.instance.currentUser?.email
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item successfully added to cart!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Add to Cart")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routers.buynow, arguments: {
                        "productname": productargs?["productname"],
                        "price": productargs?["price"],
                        "image": productargs?["image"],
                        "totalprice": tf,
                        "productquantity": productquantity,
                        "useremail": FirebaseAuth.instance.currentUser?.email
                      });
                    },
                    child: const Text("Buy Now"))
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            const Text(
              "Product Rating",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 28,
              itemPadding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (value) {
                print(value);

                setState(() {
                  rating = value;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              "Comments and reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: TextField(
                controller: comments,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection("rating").add({
                            "productname": productargs?["productname"],
                            "comments": comments.text.trim(),
                            "rating": rating,
                            "docid": productargs?["docid"],
                            "useremail":
                                FirebaseAuth.instance.currentUser?.email
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('comment sending'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          comments.clear();
                        },
                        icon: const Icon(Icons.send)),
                    hintText: "comments",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),

            const SizedBox(
              height: 50,
            ),

            const Padding(
              padding: EdgeInsets.only(right: 250),
              child: Text(
                " All Comments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            const SizedBox(
              height: 50,
            ),

            //  fetching data from collection rating

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("rating")
                    .where("docid", isEqualTo: productargs!["docid"])
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  final data = snapshot.data?.docs;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (data!.isEmpty) {
                    return const Center(child: Text("there are no comments"));
                  } else {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ratinginfo = data[index].data();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                RatingBar.builder(
                                  initialRating: ratinginfo["rating"],
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemSize: 15,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 36, 124, 4),
                                  ),
                                  onRatingUpdate: (value) {
                                    print(value);

                                    setState(() {
                                      rating = value;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(ratinginfo["rating"].toString())
                              ],
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: SizedBox(
                                  child: Text(
                                ratinginfo["comments"],
                                textAlign: TextAlign.left,
                              )),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
