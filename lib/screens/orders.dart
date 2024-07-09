import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybuy/routers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final orderdetails = FirebaseFirestore.instance
      .collection('orderlist')
      .where("useremail", isEqualTo: FirebaseAuth.instance.currentUser?.email);

  @override
  Widget build(BuildContext context) {
    Widget gap(double size) {
      return SizedBox(height: size);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color.fromARGB(255, 164, 142, 203),
      ),
      body: StreamBuilder(
        stream: orderdetails.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot orderdetailz = snapshot.data.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Image.network(
                            orderdetailz["image"],
                            fit: BoxFit.cover,
                          ),
                        ),
                        gap(10),
                        Text(
                          orderdetailz["productname"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Order Information"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          
                                          children: [
                                            const Text(
                                              "Product Details",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            gap(20),
                                            Text('Product name: ${orderdetailz["productname"]}'),
                                            gap(20),
                                            Text('Qty: ${orderdetailz["productquantity"].toString()}'),
                                            gap(20),
                                            Text('Price: ${orderdetailz["totalprice"].toString()}'),
                                            gap(20),
                                            const Divider(),
                                            const Text(
                                              "Delivery Details",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            gap(20),
                                            Text('Name: ${orderdetailz["customername"]}'),
                                            gap(20),
                                            Text('House no: ${orderdetailz["flat number"]}'),
                                            gap(20),
                                            Text('Address: ${orderdetailz["home address"]}'),
                                            gap(20),
                                            Text('Pincode: ${orderdetailz["pincode"]}'),
                                            gap(20),
                                            Text('Phone no: ${orderdetailz["mobile number"]}'),
                                            gap(20),
                                            Text('Payment mode: ${orderdetailz["paymentmode"]}'),
                                            gap(20),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context, Routers.trackorder);
                                              },
                                              child: const Center(child: Text("Track Order")),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Back"),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.more_horiz_outlined),
                              label: const Text("More Info"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .doc("orderlist/${orderdetailz.id}")
                                    .delete();
                              },
                              icon: const Icon(Icons.cancel),
                              label: const Text("Cancel Order"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
