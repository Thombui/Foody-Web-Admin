import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_web_admin_portal/main_screen/home_screen.dart';


class LoginScreen extends StatefulWidget
{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  String adminEmail = "";
  String adminPassword = "";

  allowAdminToLogin() async
  {
    SnackBar snackBar = const SnackBar(
      content: Text(
        "Đang kiểm tra thông tin đăng nhập, vui lòng đợi ...",
        style:  TextStyle(
          fontSize: 36,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.pinkAccent,
      duration:  Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);


    User? currentAdmin;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
    ).then((fAuth)
    {
      //success
      currentAdmin = fAuth.user;

    }).catchError((onError)
    {
      //in case of error
      // display error message
      final snackBar = SnackBar(
        content: Text(
          "Có lỗi xảy ra: $onError",
          style: const TextStyle(
            fontSize: 36,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.pinkAccent,
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if(currentAdmin != null)
    {
      // check if that admin record also exists in the admins collections in firestore database
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(currentAdmin!.uid)
          .get().then((snap)
      {
        if(snap.exists)
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
        }
        else
        {
          SnackBar snackBar = const SnackBar(
            content: Text(
              "Không tìm thấy thông tin. Bạn không phải admin!",
              style:  TextStyle(
                fontSize: 36,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.pinkAccent,
            duration:  Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  //image
                  Image.asset(
                    "images/admin.png",
                  ),

                  // email text field
                  TextField(
                    onChanged: (value)
                    {
                      adminEmail = value;
                    },
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.cyan,
                            width: 2,
                      ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      icon: Icon(
                        Icons.email,
                        color: Colors.cyan,
                      )
                    )

                  ),

                  const SizedBox(height: 10,),
                  // password text field

                  TextField(
                      onChanged: (value)
                      {
                        adminPassword = value;
                      },
                      obscureText: true,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.cyan,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber,
                              width: 2,
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.cyan,
                          )
                      )

                  ),

                  const SizedBox(height: 30,),

                  // button Login
                  ElevatedButton(
                    onPressed: ()
                    {
                      allowAdminToLogin();

                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),


                    ),
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 16,
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
