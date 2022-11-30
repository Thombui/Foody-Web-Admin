import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_web_admin_portal/main_screen/home_screen.dart';
import 'package:foodpanda_web_admin_portal/widgets/simple_app_bar.dart';

class AllBlockedSellersScreen extends StatefulWidget
{
  const AllBlockedSellersScreen({Key? key}) : super(key: key);

  @override
  State<AllBlockedSellersScreen> createState() => _AllBlockedSellersScreenState();
}



class _AllBlockedSellersScreenState extends State<AllBlockedSellersScreen>
{
  QuerySnapshot? allSellers;

  displayDialogBoxForActivatingAccount(userDocumentID)
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text(
              "Kích hoạt tài khoản",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Bạn muốn Kích hoạt tài khoản này không?",
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
                    "status": "approved",
                  };
                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(userDocumentID)
                      .update(userDataMap).then((value)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        "Kích hoạt thành công",
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
        .where("status", isEqualTo: "not approved")
        .get().then((allVerifiedSellers)
    {
      setState(() {
        allSellers = allVerifiedSellers;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    Widget displayBlockedSellersDesign()
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
                        primary: Colors.amber,
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
                          backgroundColor: Colors.amber,
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
                        primary: Colors.green,
                      ),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Kích hoạt tài khoản này".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: ()
                      {
                        displayDialogBoxForActivatingAccount(allSellers!.docs[i].id);
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
            "Không tìm thấy bản ghi nào",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: SimpleAppBar(title: "Sellers bị chặn"),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: displayBlockedSellersDesign(),
        ),
      ),
    );
  }
}
