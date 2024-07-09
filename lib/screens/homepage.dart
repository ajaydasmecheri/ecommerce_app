import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybuy/routers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Stream<QuerySnapshot> productsList;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productsList = FirebaseFirestore.instance.collection('products').snapshots();
  }

  void searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        productsList = FirebaseFirestore.instance.collection('products').snapshots();
      } else {
        String lowercaseQuery = query.toLowerCase();
        productsList = FirebaseFirestore.instance
            .collection('products')
            .where("productname", isGreaterThanOrEqualTo: lowercaseQuery)
            .where("productname", isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
            .snapshots();
      }
    });
  }

  Widget scrolltap({required String word, required VoidCallback ontap}) {
    return Container(
      height: 35,
      width: 100,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 164, 142, 203),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: TextButton(
          onPressed: ontap,
          child: Text(
            word,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget productview({
    required String productname,
    required String productprice,
    required String image,
    required bool isFavorite,
    required VoidCallback onFavoriteToggle,
  }) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.scaleDown)),
              ),
              Text(
                productname,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '₹ $productprice',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.red),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          )
        ],
      ),
    );
  }

  Future<bool> isFavoriteProduct(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    final favSnapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .where('useremail', isEqualTo: user?.email)
        .where('productid', isEqualTo: productId)
        .get();
    return favSnapshot.docs.isNotEmpty;
  }

  Future<void> toggleFavoriteStatus(
      String productId, String productName, String productPrice, String image) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favCollection = FirebaseFirestore.instance.collection('favorite');
    final favSnapshot = await favCollection
        .where('useremail', isEqualTo: user.email)
        .where('productid', isEqualTo: productId)
        .get();

    if (favSnapshot.docs.isNotEmpty) {
      await favCollection.doc(favSnapshot.docs.first.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item removed from favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await favCollection.add({
        'productid': productId,
        'productname': productName,
        'price': productPrice,
        'image': image,
        'useremail': user.email,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item added to favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    searchProducts(searchController.text.trim());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 164, 142, 203),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(child: Text("search")),
                  ),
                ),
              ),
              hintText: "search it",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: MediaQuery.of(context).size.height * 0.10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    scrolltap(
                      word: "All",
                      ontap: () {
                        setState(() {
                          productsList = FirebaseFirestore.instance
                              .collection('products')
                              .snapshots();
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    scrolltap(
                      word: "fashion",
                      ontap: () {
                        setState(() {
                          productsList = FirebaseFirestore.instance
                              .collection('products')
                              .where("category", isEqualTo: "fashion")
                              .snapshots();
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    scrolltap(
                      word: "appliances",
                      ontap: () {
                        setState(() {
                          productsList = FirebaseFirestore.instance
                              .collection('products')
                              .where("category", isEqualTo: "appliances")
                              .snapshots();
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    scrolltap(
                      word: "electronics",
                      ontap: () {
                        setState(() {
                          productsList = FirebaseFirestore.instance
                              .collection('products')
                              .where("category", isEqualTo: "eletronics")
                              .snapshots();
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    scrolltap(
                      word: "mobiles",
                      ontap: () {
                        setState(() {
                          productsList = FirebaseFirestore.instance
                              .collection('products')
                              .where("category", isEqualTo: "mobiles")
                              .snapshots();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<QuerySnapshot>(
                stream: productsList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot productSnap =
                            snapshot.data!.docs[index];
                        return FutureBuilder<bool>(
                          future: isFavoriteProduct(productSnap.id),
                          builder: (context, favoriteSnapshot) {
                            if (favoriteSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routers.productbuyview,
                                  arguments: {
                                    "image": productSnap["image"],
                                    "productname": productSnap["productname"],
                                    "price": productSnap["price"],
                                    "docid": productSnap.id,
                                    "id":
                                        FirebaseAuth.instance.currentUser?.email,
                                  },
                                );
                              },
                              child: productview(
                                productname: productSnap["productname"],
                                image: productSnap["image"],
                                productprice: productSnap["price"],
                                isFavorite: favoriteSnapshot.data ?? false,
                                onFavoriteToggle: () {
                                  toggleFavoriteStatus(
                                    productSnap.id,
                                    productSnap["productname"],
                                    productSnap["price"],
                                    productSnap["image"],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
