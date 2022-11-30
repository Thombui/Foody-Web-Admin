import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_web_admin_portal/main_screen/home_screen.dart';
import 'package:foodpanda_web_admin_portal/widgets/simple_app_bar.dart';

class AllVerifiedSellersScreen extends StatefulWidget
{
  const AllVerifiedSellersScreen({Key? key}) : super(key: key);

  @override
  State<AllVerifiedSellersScreen> createState() => _AllVerifiedSellersScreenState();
}



class _AllVerifiedSellersScreenState extends State<AllVerifiedSellersScreen>
{
  QuerySnapshot? allSellers;

  displayDialogBoxForBlockingAccount(userDocumentID)
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text(
              "Chặn tài khoản",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Bạn muốn chặn tài khoản này không?",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                } ,
                child: const Text("Không"),
              ),
              ElevatedButton(
                onPressed: ()
                {
                  Map<String, dynamic> userDataMap =
                  {
                    "status": "not approved",
                  };
                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(userDocumentID)
                      .update(userDataMap).then((value)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        "Chặn thành công",
                        style:  TextStyle(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.pinkAccent,
                      duration:  Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  });

                } ,
                child: const Text("Có"),
              ),
            ],
          );
        }
    );
  }



  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get().then((allVerifiedUsers)
    {
      setState(() {
        allSellers = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    Widget displayVerifiedSellersDesign()
    {
      if(allSellers != null)
      {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: allSellers!.docs.length,
          itemBuilder: (context, i)
          {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(allSellers!.docs[i].get("sellerAvatarUrl")),
                              fit: BoxFit.fill,
                            )
                        ),
                      ),
                      title: Text(
                        allSellers!.docs[i].get("sellerName"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email, color: Colors.black,),
                          const SizedBox(width: 20,),
                          Text(
                            allSellers!.docs[i].get("sellerEmail"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Doanh thu".toUpperCase() + " Đ " + allSellers!.docs[i].get("earnings").toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: ()
                      {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            "Doanh thu".toUpperCase() + " Đ " + allSellers!.docs[i].get("earnings").toString(),
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      },
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Chặn tài khoản này".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: ()
                      {
                        displayDialogBoxForBlockingAccount(allSellers!.docs[i].id);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
      else
      {
        return const Center(
          child: Text(
            "Không tìm thấy bản ghi",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: SimpleAppBar(title: "Sellers đã xác minh"),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: displayVerifiedSellersDesign(),
        ),
      ),
    );
  }
}