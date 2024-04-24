import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //craeting controllers
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  //creating login fun
  void login(String email, pass) async {
    try {
      Response response = await post(
        Uri.parse("https://reqres.in/api/register"),
        body: {
          'email': email,
          'password': pass,
        },
      );
      if (response.statusCode == 200) {
        //to print data using GET
        var data = jsonDecode(response.body.toString());
        print(data);
        print("account created");
      } else {
        print("please check password");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Sign Up"),
        ),
        backgroundColor: Colors.purple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: "email",
              ),
              controller: emailCon,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "password",
              ),
              controller: passCon,
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                login(emailCon.text.toString(), passCon.text.toString());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.pink[100],
                ),
                child: const Center(
                  child: Text("Sign Up"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
