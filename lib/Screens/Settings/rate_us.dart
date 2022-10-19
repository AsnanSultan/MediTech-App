import 'package:flutter/material.dart';
import 'package:medi_tech/Widgets/my_text_button.dart';

class RateUsScreen extends StatefulWidget {
  const RateUsScreen({Key? key}) : super(key: key);

  @override
  _RateUsScreenState createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  List<bool> rating = [true, false, false, false, false];

  void setRating(int count) {
    for (int i = 0; i < 5; i++) {
      if (i < count) {
        rating[i] = true;
      } else {
        rating[i] = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 600,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              // color: Colors.blue,
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 250),
            height: 800,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(230),
                topLeft: Radius.circular(120),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/team_illustration.png'),
                const Text(
                  "Your opinion matters to us!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Text(
                  "We work super hard to serve you better and\nwould love to know how you rate our app,",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setRating(1);
                        },
                        icon: Icon(
                          rating[0] ? Icons.star : Icons.star_border,
                          size: 38,
                          color: Colors.yellow,
                        )),
                    IconButton(
                        onPressed: () {
                          setRating(2);
                        },
                        icon: Icon(
                          rating[1] ? Icons.star : Icons.star_border,
                          size: 38,
                          color: Colors.yellow,
                        )),
                    IconButton(
                        onPressed: () {
                          setRating(3);
                        },
                        icon: Icon(
                          rating[2] ? Icons.star : Icons.star_border,
                          size: 38,
                          color: Colors.yellow,
                        )),
                    IconButton(
                        onPressed: () {
                          setRating(4);
                        },
                        icon: Icon(
                          rating[3] ? Icons.star : Icons.star_border,
                          size: 38,
                          color: Colors.yellow,
                        )),
                    IconButton(
                        onPressed: () {
                          setRating(5);
                        },
                        icon: Icon(
                          rating[4] ? Icons.star : Icons.star_border,
                          size: 38,
                          color: Colors.yellow,
                        )),
                  ],
                ),
                SizedBox(
                  width: 170,
                  child: MyTextButton(
                      buttonName: "Submit",
                      onTap: () {},
                      bgColor: Colors.blueAccent,
                      textColor: Colors.white,
                      isLoading: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
