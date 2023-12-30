import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () {
                Get.back();
              }),
          title: const Text('Privacy Policy'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
          centerTitle: true,
          surfaceTintColor: Colors.white),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Privacy Policy of TaskMate',
                style: _heading(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  'Effective Date: ${DateFormat.yMd().format(DateTime.now())}'),
              const SizedBox(
                height: 10,
              ),
              const Text('Welcome to TaskMate!'),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'This Privacy Policy outlines how we handles user data when you use our app.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Data Storage or Informations We Collect', style: _heading()),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  'TaskMate stores all user-provided information, including but not limited to name, email, phone number, gender, and profile picture, locally on your device. This local storage is utilized to enhance your user experience within the app and is solely accessible within the app on your device.',
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 10,
              ),
              Text('Data Security', style: _heading()),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  'We prioritize the security of all locally stored user information. While this data is stored on your device, TaskMate implements measures to protect it from unauthorized access.',
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Changes to this Privacy Policy',
                style: _heading(),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  'We reserve the right to update or change our Privacy Policy at any time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Contact Us',
                style: _heading(),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  'If you have any questions or concerns about this Privacy Policy, please contact us at dilshadazim910@gmail.com.',
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Thank you for using TaskMate!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

_heading() {
  return const TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
}
