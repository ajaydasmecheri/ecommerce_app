// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybuy/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userdetails =
      FirebaseFirestore.instance.collection('ebuy-users').where("useremail",
                isEqualTo: FirebaseAuth.instance.currentUser?.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 164, 142, 203),
      ),
      body: StreamBuilder(
        stream: userdetails.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot userDetails =
                    snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                   
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                      backgroundImage: NetworkImage("https://freepngimg.com/thumb/google/66726-customer-account-google-service-button-search-logo.png"),
                      radius: 50,
                    ),
        
                  SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                  Text('Name : ${userDetails["username"]}', style: const TextStyle(fontSize: 15, fontWeight:FontWeight.bold),),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Text('Number : ${userDetails["userphonenumber"]}', style: const TextStyle(fontSize: 15, fontWeight:FontWeight.bold),),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                   Text('Email id : ${userDetails["useremail"]}', style: const TextStyle(fontSize: 15, fontWeight:FontWeight.bold),),
                  SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                   Center(child: ElevatedButton(onPressed: ()async{

                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return const Loginpage();
                  }));
                     
                   }, child: const Text("Log out")))
                  
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
