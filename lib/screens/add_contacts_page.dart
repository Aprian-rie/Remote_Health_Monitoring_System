import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:remote_health/defaults/round_text_field.dart';

import '../defaults/round_gradient_button.dart';
import '../services/database_service.dart';
import '../utils/app_colors.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController agecontroller = new TextEditingController();
  TextEditingController numbercontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Add ",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: media.height * 0.02,
                ),
                SizedBox(
                  width: media.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      SizedBox(
                        width: media.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: media.width * 0.01,
                            ),
                            Text(
                              "Hey There",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Text(
                              "Fill In the Important Details for your go-to person"
                              " whenever an inconvenience occurs.",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "Don't Worry It's Confidential no data is shared publicly",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.02,
                      ),
                      RoundTextField(
                          textEditingController: namecontroller,
                          hintText: "Name",
                          icon: "assets/Icons/user_blue.png",
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: media.width * 0.02,
                      ),
                      RoundTextField(
                          textEditingController: agecontroller,
                          hintText: "Age",
                          icon: "assets/Icons/age_blue.png",
                          textInputType: TextInputType.number),
                      SizedBox(
                        height: media.width * 0.02,
                      ),
                      RoundTextField(
                          textEditingController: numbercontroller,
                          hintText: "Phone Number",
                          icon: "assets/Icons/telephone_blue.png",
                          textInputType: TextInputType.phone),
                      SizedBox(
                        height: media.width * 0.02,
                      ),
                      RoundTextField(
                          textEditingController: locationcontroller,
                          hintText: "Location",
                          icon: "assets/Icons/pin_blue.png",
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                      RoundGradientButton(
                        title: "Add Contact",
                        onPressed: () async {
                          String Id = randomAlphaNumeric(10);
                          Map<String, dynamic> contactInfoMap={
                            "Name": namecontroller.text,
                            "Age": agecontroller.text,
                            "Number": numbercontroller.text,
                            "Id": Id,
                            "Location": locationcontroller.text,
                          };
                          await DatabaseService().addContactDetails(contactInfoMap, Id).then((value) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Contact Details has been uploaded Successfully",
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
