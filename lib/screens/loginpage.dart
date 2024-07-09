// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:easybuy/routers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {

      TextEditingController remail = TextEditingController();
  TextEditingController rpassword = TextEditingController();

    return  Scaffold(
      appBar: AppBar(
            title: const Text("Sign In Page"),
            backgroundColor: const Color.fromARGB(255, 164, 142, 203),
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Padding(
               padding: const EdgeInsets.only(top: 75, right: 15, left: 15),
               child: TextField(
                controller: remail,
                decoration: InputDecoration(
                        
                        hintText: "enter email",
                        icon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                         ),
             ),

            SizedBox(height: MediaQuery.of(context).size.height*0.05,),

             Padding(
               padding: const EdgeInsets.only( right: 15, left: 15),
               child: TextField(
                controller: rpassword,
                decoration: InputDecoration(
                        hintText: "password",
                        icon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                         ),
             ),

            SizedBox(height: MediaQuery.of(context).size.height*0.05,),


            // start login button
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: const BoxDecoration(

                  color: Color.fromARGB(255, 164, 142, 203),
                  borderRadius: BorderRadius.all(Radius.elliptical(50, 50)),
                ),
                child: TextButton(
                  onPressed: () async{

                     try {
                           await FirebaseAuth.instance.signInWithEmailAndPassword(email: remail.text.trim(), password: rpassword.text.trim());
                           Navigator.pushNamed(context, Routers.homepage);

                         } on FirebaseAuthException catch (e) {
                    print(e.toString());
                  }

                  

                  

                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 5,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                     Navigator.pushNamed(context, Routers.registerpage);
                  },
                   child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.black),))





            // end

          ],
        ),
      ),
    );
  }
}