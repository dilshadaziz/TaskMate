import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon : const Icon(CupertinoIcons.back),onPressed: (){
        Get.back();
      },),title: const Text('About Us'),titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),centerTitle: true,surfaceTintColor: Colors.white),
      body:  SafeArea(child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome to TaskMate!',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('TaskMate is the result of a vision to make your day more productive. We strive to provide a streamlined task management experience, allowing you to effortlessly organize upcoming events, tasks, and other essential details.',textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              Text('Mission',style: _heading(),),
              const SizedBox(height: 10,),
              const Text('Our mission is to empower individuals like you to take control of your day, enhance productivity, and achieve your goals.',textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              Text('Key Features',style: _heading(),),
              const SizedBox(height: 10,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Task Management: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  Expanded(child: Text('Easily add, edit, and organize your tasks for efficient day-to-day management.',textAlign: TextAlign.start,)),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Category Session :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  Expanded(child: Text(' Customize your experience by categorizing tasks into different types, ensuring a tailored approach to productivity.',textAlign: TextAlign.start,)),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('User-Friendly Interface:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  Expanded(child: Text(' We prioritize a clean and intuitive design to make navigation a breeze.',textAlign: TextAlign.start,)),
                ],
              ),
              const SizedBox(height:10),
              Text('Contact Us',style: _heading(),),
              const SizedBox(height: 10,),
               RichText(textAlign: TextAlign.center,text: const TextSpan(children: [
                 TextSpan(text: 'We value your feedback and are here to assist you. If you have any questions, suggestions, or just want to say hello, reach out to us at ',style: TextStyle(color: Colors.black,)
          ),TextSpan(text: 'dilshadazim910@gmail.com.',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,))])),
              const SizedBox(height: 20,),
              const Text('Thank you for choosing TaskMate to make your day more productive and organized!',textAlign: TextAlign.center,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
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


