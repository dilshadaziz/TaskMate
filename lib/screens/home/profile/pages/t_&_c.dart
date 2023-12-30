import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon:const Icon(CupertinoIcons.back),onPressed: (){
        Get.back();
      },),title: const Text('Terms and Conditions'),titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),centerTitle: true,surfaceTintColor: Colors.white),
      body:  SafeArea(child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Effective Date: ${DateFormat.yMd().format(DateTime.now())}'),
              const SizedBox(height: 10,),
              const Text('Welcome to TaskMate!'),
              const SizedBox(height: 10,),
              const Text('These terms and conditions "Terms" govern your use of TaskMate, a task management application.',textAlign: TextAlign.center),
              const SizedBox(height: 10,),
              Text('Acceptance of Terms',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('By accessing or using TaskMate, you agree to comply with and be bound by these Terms. If you do not agree with any part of these Terms, you may not use our services.',textAlign: TextAlign.center),
              const SizedBox(height: 10,),
              Text('User Responsibilities',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('- You are responsible for maintaining the confidentiality of your account information.',textAlign: TextAlign.center),
              const Text('- You agree not to use TaskMate for any illegal or unauthorized purpose.',textAlign: TextAlign.center),
              const SizedBox(height: 10,),
              Text('Data and Content',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('- You retain ownership of the data and content you add to TaskMate.',textAlign: TextAlign.center),
              const Text('- We may collect and use anonymized usage data to improve our services.',textAlign: TextAlign.center),
              const SizedBox(height: 10,),
              Text('Prohibited Activities',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('You agree not to engage in any of the following prohibited',textAlign: TextAlign.center),
              const Text('activities:'),
              const Text('- Violating any applicable laws or regulations.',textAlign: TextAlign.center),
              const Text('- Uploading malicious code or engaging in harmful activities.',textAlign: TextAlign.center),
              const Text('- Impersonating others or providing false information.',textAlign: TextAlign.center),
              const SizedBox(height:10),
              Text('Termination',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('We reserve the right to terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms.',textAlign: TextAlign.center),
              const SizedBox(height:10),
              Text('Changes to Terms',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('We may update these Terms at any time without notice. It is your responsibility to review these Terms periodically.',textAlign: TextAlign.center),
              const SizedBox(height:10),
              Text('Contact Information',style: _heading(),),
              const SizedBox(height: 10,),
              RichText(textAlign: TextAlign.center,text: const TextSpan(children: [
                   TextSpan(text: 'If you have any questions about these Terms, please contact us at ',style: TextStyle(color: Colors.black,)
            ),TextSpan(text: 'dilshadazim910@gmail.com.',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,))])),
              const SizedBox(height: 20,),
              const Text('Thank you for using TaskMate!',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
            ],
          ),
        ),
      )),
    );
  }
}

_heading(){
  return const TextStyle(fontSize: 20,fontWeight: FontWeight.w700);
}