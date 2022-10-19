import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medi_tech/Provider/OrderProvider.dart';
import 'package:medi_tech/Provider/cart_provider.dart';
import 'package:medi_tech/Provider/exchangeProvider.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:medi_tech/Screens/splash_screen.dart';

import 'Provider/CustomOrderProvider.dart';
import 'Provider/customer_provider.dart';
import 'constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PharmacyProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExchangeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomOrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediTech',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: kBackgroundColor,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MySplashScreen(), //LoginScreen(),
      ),
    );
  }
}
