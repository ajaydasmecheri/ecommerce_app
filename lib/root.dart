import 'package:easybuy/routers.dart';
import 'package:easybuy/screens/buynow.dart';
import 'package:easybuy/screens/cartpage.dart';
import 'package:easybuy/screens/fashion.dart';


import 'package:easybuy/screens/homepage.dart';
import 'package:easybuy/screens/loginpage.dart';
import 'package:easybuy/screens/productbuyview.dart';

import 'package:easybuy/screens/registerpage.dart';
import 'package:easybuy/screens/splashscreen.dart';
import 'package:easybuy/screens/trackorder.dart';
import 'package:flutter/material.dart';

class Rootpage extends StatelessWidget {
  const Rootpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routers.splashpage,
      routes:  {
        Routers.splashpage:(context) => const Splashpage(),
        Routers.loginpage:(context) => const Loginpage(),
        Routers.registerpage:(context) => const Registerpage(),
        Routers.homepage:(context) => const Homepage(),
        Routers.cartpage:(context) => const CartPage(),
        Routers.fashion:(context) => const Fashion(),
        Routers.productbuyview:(context) => const Productbuyview(),
        Routers.buynow:(context) => const Buynow(),
        Routers.trackorder:(context) => const Trackorder(),
      
        
        
    


      },
    );
  }
}