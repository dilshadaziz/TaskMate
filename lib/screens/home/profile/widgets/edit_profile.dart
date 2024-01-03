// ignore_for_file: body_might_complete_normally_nullable

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/profile.dart';

class EditProfile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;

  const EditProfile({this.user, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? updatedImagepath;
  File? image25;
  String? imagepath;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _genderController = TextEditingController();

  dynamic _selectedGender;
  List<String> genderList = [
    'Gender',
    'Male',
    'Female',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.user[0].fullName != 'null') {
      _nameController.text = widget.user[0].fullName;
    }
    if (widget.user[0].eMail != 'null') {
      _emailController.text = widget.user[0].eMail;
    }
    if (widget.user[0].phoneNumber != 'null') {
      _phoneNumberController.text = widget.user[0].phoneNumber;
    }

    if (widget.user[0].gender != 'null') {
      _selectedGender = widget.user[0].gender;
    }

    updatedImagepath = widget.user[0].imagex;
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30))),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    child: _buildAppBar(),
                  ),
                  Positioned(
                      top: MediaQuery.sizeOf(context).height / 5,
                      left: MediaQuery.sizeOf(context).width * 0.05,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: MediaQuery.sizeOf(context).height -
                            MediaQuery.sizeOf(context).height / 5,
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                      backgroundImage: updatedImagepath !=
                                              'null'
                                          // image25 == null
                                          ? FileImage(File(updatedImagepath!))
                                          : image25 != null
                                              ? FileImage(image25!)
                                              : null,
                                      radius: 60),
                                  Positioned(
                                    bottom: 15,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color.fromRGBO(
                                                        0, 0, 0, 1)
                                                    .withOpacity(
                                                        0.25), // Shadow color
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: const Offset(2, 2))
                                          ]),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            addphoto(context);
                                          },
                                          icon:
                                              const Icon(CupertinoIcons.camera),
                                          color: Colors.black,
                                          iconSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // const Text(
                              //   'Your Name',
                              //   style: TextStyle(
                              //       fontSize: 20, fontWeight: FontWeight.bold),
                              // ),
                              // Text(
                              //   'example@gmail.com',
                              //   style: TextStyle(color: Colors.grey.shade600),
                              // ),
                              const SizedBox(height: 20),

                              // Name input field with validation
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isBlank!) {
                                    return ' Name can\'t be empty';
                                  }
                                },
                                autocorrect: true,
                                enableSuggestions: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autofocus: true,
                                keyboardType: TextInputType.name,
                                controller: _nameController,
                                decoration: InputDecoration(
                                  label: const Text('Enter your name'),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  prefixIcon: const Icon(Icons.person),
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Age input field with validation
                              TextFormField(
                                validator: (value) {
                                  if (value != null && value.trim().isEmpty || value != null &&
                                      !value.contains('@gmail.com')) {
                                    return 'Please check your email address';
                                  }
                                },
                                onTapOutside: (event) {},
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  label: const Text('Enter your email address'),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  prefixIcon: const Icon(CupertinoIcons.mail),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // PhoneNumber input field with validation
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.length != 10) {
                                    return 'Please check your phone number';
                                  }
                                },
                                keyboardType: TextInputType.number,
                                controller: _phoneNumberController,
                                decoration: InputDecoration(
                                  label: const Text('Enter your phone number'),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  prefixIcon: const Icon(CupertinoIcons.phone),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Gender input field with validation
                              DropdownButtonFormField<String>(
                                value: _selectedGender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                                items: genderList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                                decoration: InputDecoration(
                                  label: const Text('Gender'),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  prefixIcon: const Icon(
                                      CupertinoIcons.person_crop_circle_fill),
                                ),
                              ),

                              const SizedBox(height: 20),

                              ElevatedButton(
                                onPressed: () {
                                  saveDetailsClicked(context);
                                },
                                style: ButtonStyle(
                                  minimumSize: const MaterialStatePropertyAll(
                                      Size(150, 40)),
                                  maximumSize: const MaterialStatePropertyAll(
                                      Size(180, 60)),
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15)),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.black),
                                  foregroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.white),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: const Text('Save Details'),
                              )
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
    );
  }

  _buildAppBar() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Colors.white,
          )),
      SizedBox(
        width: MediaQuery.sizeOf(context).width / 4,
      ),
      const Text(
        'Edit Profile',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
      ),
    ]);
  }

  Future<void> saveDetailsClicked(ctx) async {
    if (_formKey.currentState!.validate() && widget.user[0].imagex != 'null' ||
        image25 != null) {
      final name = _nameController.text.toUpperCase();
      final email = _emailController.text.toString().trim();
      final phoneNumber = _phoneNumberController.text;
      final gender = _selectedGender;

      String imagePathToUpdate = updatedImagepath ?? imagepath!;

      final profileData = ProfileDetailsDB(
        fullName: name,
        eMail: email,
        phoneNumber: phoneNumber,
        gender: gender,
        imagex: imagePathToUpdate,
      );
      await DBHelper.updateProfile(profileData);

      ScaffoldMessenger.of(ctx).showSnackBar(
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
        _emailController.clear();
        _phoneNumberController.clear();
        _genderController.clear();
      });
      Navigator.of(ctx).pop();
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
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
      imagepath = image.path;
      updatedImagepath =
          imagepath; // Update updatedImagepath with the new image path
      debugPrint(imagepath);
      debugPrint("path ${image.path}");
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
