import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/screens/home/profile/pages/about_us.dart';
import 'package:taskmate/screens/home/profile/pages/privacy_policy.dart';
import 'package:taskmate/screens/home/profile/pages/t_&_c.dart';
import 'package:taskmate/screens/home/profile/widgets/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? image25;
  String? imagepath;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: dbProfileList,
        builder: (context, profileList, child) => 
         SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        height: MediaQuery.sizeOf(context).height / 2.7,
                        decoration: const BoxDecoration(
                            color: Colors.black87,
                            borderRadius:
                                BorderRadius.only(bottomLeft: Radius.circular(30))),
                      ),
                    ),
                    Positioned(top: 25,child: _buildAppBar()),
                    Positioned(
                        top: MediaQuery.sizeOf(context).height / 5.5,
                        left: MediaQuery.sizeOf(context).width * 0.05,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: MediaQuery.sizeOf(context).height -
                              MediaQuery.sizeOf(context).height / 5.5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 1)
                                    .withOpacity(0.25), // Shadow color
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 0), // Changes position of shadow
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(height: MediaQuery.sizeOf(context).height*0.03),
                                Stack(
                                  children: [
                                     CircleAvatar(
                                        backgroundImage:
                                            profileList[0].imagex == 'null' ? null : FileImage(File(profileList[0].imagex!)) ,
                                        radius: MediaQuery.sizeOf(context).height*0.06)
                                  ],
                                ),
                                
                                const SizedBox(height: 10),
                                
                                 Text(
                                  profileList[0].fullName == 'null' ? 'Full Name':profileList[0].fullName!,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  profileList[0].eMail == 'null' ? 'Email Address' : profileList[0].eMail!,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                SizedBox(height: MediaQuery.sizeOf(context).height*0.02),
                                
                                // Name input field with validation
                                TextField(
                                  readOnly: true,
                                  // keyboardType: TextInputType.name,
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*0.1),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                    hintText: profileList[0].fullName == 'null' ? 'Full Name' : profileList[0].fullName,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                                SizedBox(height: MediaQuery.sizeOf(context).height*0.02),
                                
                                // Age input field with validation
                                TextField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: _ageController,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*0.1),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                    hintText: profileList[0].eMail == 'null'? 'Email Address':profileList[0].eMail,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    prefixIcon: const Icon(CupertinoIcons.mail),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.sizeOf(context).height*0.02),
                                
                                // PhoneNumber input field with validation
                                TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*0.1),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                    hintText: profileList[0].phoneNumber =='null' ? 'Phone Number' : profileList[0].phoneNumber,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    prefixIcon: const Icon(CupertinoIcons.phone),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.sizeOf(context).height*0.02),
                                
                                // Mobile input field with validation
                                TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*0.1),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                    hintText: profileList[0].gender == 'null'? 'Gender' : profileList[0].gender,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    prefixIcon: const Icon(
                                        CupertinoIcons.person_crop_circle_fill),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(()=>EditProfile(user:profileList));
                                  },
                                  style: ButtonStyle(
                                    minimumSize:
                                        const MaterialStatePropertyAll(Size(150, 40)),
                                    maximumSize:
                                        const MaterialStatePropertyAll(Size(180, 60)),
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15)),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(Colors.black),
                                    foregroundColor:
                                        const MaterialStatePropertyAll(Colors.white),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Edit Profile'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(onPressed: (){
                                      Get.to(()=>const TermsAndConditions());
                                    },style:  const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent),enableFeedback: true), child: const Text('Terms & Conditions',style: TextStyle(fontSize: 13),),),
                                    TextButton(onPressed: (){
                                      Get.to(()=>const PrivacyPolicy());
                                    },style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent),enableFeedback: true),child: const Text('Privacy Policy',style: TextStyle(fontSize: 13)),)
                                  ],
                                ),
                                TextButton(onPressed: (){
                                  Get.to(()=> const AboutUs());
                                },style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent),enableFeedback: true),child: const Text('About Us',style: TextStyle(fontSize: 13)),)
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return ValueListenableBuilder(
      valueListenable: dbProfileList,
      builder: (context, profileList, child) => 
       Row(
        children: [
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: Colors.white,
            )),
            SizedBox(width: MediaQuery.sizeOf(context).width/4,),
            const Text('Profile',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
            SizedBox(width: MediaQuery.sizeOf(context).width/3.5,),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.grey.shade800,),
          child: IconButton(
            onPressed: () {
              Get.to(()=>EditProfile(user: profileList,));
            },
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.grey.shade400,
            ),
            iconSize: 25,
          ),
        ),
      ]),
    );
  }

  Future<void> addstudentclicked(mtx) async {
    if (_formKey.currentState!.validate() && image25 != null) {
      ScaffoldMessenger.of(mtx).showSnackBar(
        const SnackBar(
          content: Text("Successfully added"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        image25 = null;
        _nameController.clear();
        _ageController.clear();
        _guardianController.clear();
        _mobileController.clear();
      });
      Navigator.of(mtx).pop();
    } else {
      ScaffoldMessenger.of(mtx).showSnackBar(
        const SnackBar(
          content: Text('Add all details'),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> getimage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    setState(() {
      image25 = File(image.path);
      imagepath = image.path.toString();
    });
  }

  void addphoto(ctxr) {
    showDialog(
      context: ctxr,
      builder: (ctxr) {
        return AlertDialog(
          content: const Text('Choose Image From.......'),
          actions: [
            IconButton(
              onPressed: () {
                getimage(ImageSource.camera);
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                getimage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.image,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
