import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_web_admin_portal/main_screen/home_screen.dart';
import 'package:foodpanda_web_admin_portal/widgets/simple_app_bar.dart';

class AllVerifiedRidersScreen extends StatefulWidget
{
  const AllVerifiedRidersScreen({Key? key}) : super(key: key);

  @override
  State<AllVerifiedRidersScreen> createState() => _AllVerifiedRidersScreenState();
}



class _AllVerifiedRidersScreenState extends State<AllVerifiedRidersScreen>
{
  QuerySnapshot? allRiders;

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
              "Bạn có muốn chặn tài khoản này không?",
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
                      .collection("riders")
                      .doc(userDocumentID)
                      .update(userDataMap).then((value)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        "Chăn thành công",
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
        .collection("riders")
        .where("status", isEqualTo: "approved")
        .get().then((allVerifiedRiders)
    {
      setState(() {
        allRiders = allVerifiedRiders;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    Widget displayVerifiedRidersDesign()
    {
      if(allRiders != null)
      {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: allRiders!.docs.length,
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
                              image: NetworkImage(allRiders!.docs[i].get("riderAvatarUrl")),
                              fit: BoxFit.fill,
                            )
                        ),
                      ),
                      title: Text(
                        allRiders!.docs[i].get("riderName"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email, color: Colors.black,),
                          const SizedBox(width: 20,),
                          Text(
                            allRiders!.docs[i].get("riderEmail"),
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
                        "Doanh thu".toUpperCase() + " Đ " + allRiders!.docs[i].get("earnings").toString(),
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
                            "Doanh thu".toUpperCase() + " Đ " + allRiders!.docs[i].get("earnings").toString(),
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
                        displayDialogBoxForBlockingAccount(allRiders!.docs[i].id);
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
      appBar: SimpleAppBar(title: "Riders được xác minh"),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: displayVerifiedRidersDesign(),
        ),
      ),
    );
  }
}
