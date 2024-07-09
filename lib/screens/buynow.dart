import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Buynow extends StatefulWidget {
  const Buynow({super.key});

  @override
  State<Buynow> createState() => _BuynowState();
}

class _BuynowState extends State<Buynow> {
  bool? ischecked = false;
  bool? ischecked2 = false;
  TextEditingController flatno = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  TextEditingController customername = TextEditingController();
  final paymentmode = ["cash on delivery", "online payment"];
  String? selectedcategory;

  @override
  Widget build(BuildContext context) {
    final productargs = ModalRoute.of(context)!.settings.arguments as Map?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("payment mode"),
        backgroundColor: const Color.fromARGB(255, 164, 142, 203),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                child: DropdownButtonFormField(
                    decoration:
                        const InputDecoration(label: Text("Payment Mode")),
                    items: paymentmode
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      selectedcategory = val;
                      print(selectedcategory);
                    }),
              ),

              const SizedBox(
                height: 50,
              ),

              const Center(
                  child: Text(
                "Shipping Address",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              )),
              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextField(
                  controller: customername,
                  decoration: InputDecoration(
                      hintText: "Customer Name",
                      icon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  controller: flatno,
                  decoration: InputDecoration(
                      hintText: "Flat Number",
                      icon: const Icon(Icons.home_work_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextField(
                  controller: address,
                  decoration: InputDecoration(
                      hintText: "Home Address",
                      icon: const Icon(Icons.pin_drop_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  controller: pincode,
                  decoration: InputDecoration(
                      hintText: "Pincode",
                      icon: const Icon(Icons.near_me_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: phoneno,
                  decoration: InputDecoration(
                      hintText: "Mobile Number",
                      icon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // arrgument data fetching (working )

              // Text(productargs?["useremail"]),

              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection("orderlist").add({
                      "paymentmode": selectedcategory,
                      "customername": customername.text.trim(),
                      "flat number": flatno.text.trim(),
                      "home address": address.text.trim(),
                      "pincode": pincode.text.trim(),
                      "mobile number": phoneno.text.trim(),
                      "productname": productargs?["productname"],
                      "price": productargs?["price"],
                      "image": productargs?["image"],
                      "totalprice": productargs?["totalprice"],
                      "productquantity": productargs?["productquantity"],
                      "useremail": FirebaseAuth.instance.currentUser?.email
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item successfully ordered'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text("Order Now"))
            ],
          ),
        ),
      ),
    );
  }
}
