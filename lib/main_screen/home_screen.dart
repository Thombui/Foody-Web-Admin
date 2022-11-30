import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_web_admin_portal/authentication/login_screen.dart';
import 'package:foodpanda_web_admin_portal/riders/all_blocked_riders_screen.dart';
import 'package:foodpanda_web_admin_portal/riders/all_verified_riders_screen.dart';
import 'package:foodpanda_web_admin_portal/sellers/all_block_sellers_screen.dart';
import 'package:foodpanda_web_admin_portal/sellers/all_verified_sellers_screen.dart';
import 'package:foodpanda_web_admin_portal/users/all_blocked_users_screen.dart';
import 'package:foodpanda_web_admin_portal/users/all_verified_users_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  String timeText = "";
  String dateText = "";


  String formatCurrentLiveTime(DateTime time)
  {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime date)
  {
    return DateFormat("dd MMMM, yyyy").format(date);
  }

  getCurrentLiveTime()
  {
    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentLiveTime(timeNow);
    final String liveDate = formatCurrentLiveDate(timeNow);

    if(this.mounted)
    {
      setState(() {
        setState(() {
          timeText = liveTime;
          dateText = liveDate;
        });
      });
    }
  }

  @override
  void initState()
  {
    super.initState();

    //time
    timeText =  formatCurrentLiveTime(DateTime.now());

    //date
    dateText = formatCurrentLiveDate(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (timer)
    {
      getCurrentLiveTime();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.amber,
                    Colors.cyan,
                  ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
          ),
        ),
        title: const Text(
          "Admin Web Portal",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                timeText + "\n" +dateText,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Regular"
                ),
              ),
            ),

            // users activate and block accounts button

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // activate
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.white,),
                  label: Text(
                    "Users đã xác minh" + "\n" +"Tài khoản",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3,
                        fontFamily: "Regular"
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    primary: Colors.amber,
                  ),
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const AllVerifiedUserScreen()));

                  },

                ),

                const SizedBox(width: 20,),

                //block
                ElevatedButton.icon(
                  icon: const Icon(Icons.block_flipped, color: Colors.white,),
                  label: Text(
                    "Users đã bị chặn" + "\n" + "Tài khoản",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3, fontFamily: "Regular"
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    primary: Colors.cyan,
                  ),
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const AllBlockedUsersScreen()));
                  },

                ),
              ],
            ),

            //sellers activate and block accounts button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // activate
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.white,),
                  label: Text(
                    "Sellers đã xác minh" + "\n" +"Tài khoản",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3, fontFamily: "Regular"
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    primary: Colors.cyan,
                  ),
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const AllVerifiedSellersScreen()));

                  },

                ),

                const SizedBox(width: 20,),

                //block
                ElevatedButton.icon(
                  icon: const Icon(Icons.block_flipped, color: Colors.white,),
                  label: Text(
                    "Sellers đã bị chăn" + "\n" + "Tài khoản",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3, fontFamily: "Regular"
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    primary: Colors.amber,
                  ),
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const AllBlockedSellersScreen()));

                  },

                ),
              ],
            ),

            //riders activate and block accounts button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // activate
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.white,),
                  label: Text(
                    "Riders đã xác minh" + "\n" +"Tài khoản",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3, fontFamily: "Regular"
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    primary: Colors.amber,
                  ),
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const AllVerifiedRidersScreen()));

                  },

                ),

                const SizedBox(width: 20,),

                //block
                ElevatedButton.icon(
                  icon: const Icon(Icons.block_flipped, color: Colors.white,),
                  label: Text(
                    "Riders đã bị chặn"+ "\n" + "Tài khoản",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3, fontFamily: "Regular"
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    primary: Colors.cyan,
                  ),
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const AllBlockedRidersScreen()));

                  },

                ),
              ],
            ),

            //logout button
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white,),
              label: Text(
                "Đăng xuất",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 3, fontFamily: "Regular"
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(30),
                primary: Colors.amber,
              ),
              onPressed: ()
              {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
              },

            ),

          ],
        ),
      ),
    );
  }
}
