import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_health/defaults/round_gradient_button.dart';
import 'package:remote_health/screens/add_contacts_page.dart';
import 'package:remote_health/services/database_service.dart';
import 'package:remote_health/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../defaults/round_text_field.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController agecontroller = new TextEditingController();
  TextEditingController numbercontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();
  Stream? ContactStream;
  getontheload() async {
    ContactStream = await DatabaseService().getContactDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allContactDetails() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name: " + ds["Name"],
                                  style: TextStyle(
                                      color: AppColors.primaryColor2,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    namecontroller.text = ds["Name"];
                                    agecontroller.text = ds["Age"];
                                    numbercontroller.text = ds["Number"];
                                    locationcontroller.text = ds["Location"];
                                    EditContactDetail(ds["Id"]);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.primaryColor1,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    await DatabaseService().deleteContactDetail(ds["Id"]);

                                  },
                                    child: Icon(
                                  Icons.delete,
                                  color: AppColors.primaryColor1,
                                ))
                              ],
                            ),
                            Text(
                              "Age: " + ds["Age"],
                              style: TextStyle(
                                  color: AppColors.primaryColor1,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Phone Number: " + ds["Number"],
                              style: TextStyle(
                                  color: AppColors.primaryColor2,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Location: " + ds["Location"],
                              style: TextStyle(
                                  color: AppColors.primaryColor1,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            RoundGradientButton(
                                title: "Call",
                                onPressed: () async{
                                  final url = Uri(scheme: 'tel', path: ds["Number"]);
                                  if (await canLaunchUrl(url)){
                                    launchUrl(url);
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Container();
      },
      stream: ContactStream,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddContactsPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Emergency ",
              style: TextStyle(
                  color: AppColors.primaryColor1,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Contacts",
              style: TextStyle(
                  color: AppColors.primaryColor2,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
            Expanded(child: allContactDetails()),
          ],
        ),
      ),
    );
  }

  Future EditContactDetail(String id) => showDialog(
      builder: (context) => AlertDialog(
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                      SizedBox(
                        width: 60.0,
                      ),
                      Text(
                        "Edit ",
                        style: TextStyle(
                            color: AppColors.primaryColor1,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Details",
                        style: TextStyle(
                            color: AppColors.primaryColor2,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundTextField(
                      textEditingController: namecontroller,
                      hintText: "Name",
                      icon: "assets/Icons/user_blue.png",
                      textInputType: TextInputType.text),
                  SizedBox(
                    height: 10,
                  ),
                  RoundTextField(
                      textEditingController: agecontroller,
                      hintText: "Age",
                      icon: "assets/Icons/age_blue.png",
                      textInputType: TextInputType.number),
                  SizedBox(
                    height: 10,
                  ),
                  RoundTextField(
                      textEditingController: numbercontroller,
                      hintText: "Phone Number",
                      icon: "assets/Icons/telephone_blue.png",
                      textInputType: TextInputType.phone),
                  SizedBox(
                    height: 10,
                  ),
                  RoundTextField(
                      textEditingController: locationcontroller,
                      hintText: "Location",
                      icon: "assets/Icons/pin_blue.png",
                      textInputType: TextInputType.text),
                  RoundGradientButton(
                    title: "Update",
                    onPressed: () async {
                      Map<String, dynamic> updateInfo = {
                        "Name": namecontroller.text,
                        "Age": agecontroller.text,
                        "Number": numbercontroller.text,
                        "Id": id,
                        "Location": locationcontroller.text,
                      };
                      await DatabaseService()
                          .updateContactDetail(id, updateInfo)
                          .then((value) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "Contact Details has been updated Successfully",
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
      context: context);
}
