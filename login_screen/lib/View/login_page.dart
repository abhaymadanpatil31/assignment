import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:http/http.dart' as http;
import "package:login_screen/View/AccountInform.dart";
import "package:login_screen/View/SignUpPage.dart";
import "package:login_screen/View/home.dart";
// import "package:login_screen/View/otpscreen.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LogicPageState();
}

class _LogicPageState extends State {
  // List<Map> credentialList = [
  //      username: ['kminchelle'],
  // ];
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordNameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///API Calling
  Future<bool> login() async {
    log("--------------------CALL TO LOGIN METHOD-----------------------");
    bool status = false;
    final url = Uri.parse('https://dummyjson.com/auth/login');

    final response = await http.post(
      url,
      body: {
        'username': _userNameController.text.trim(),
        "password": _passwordNameController.text.trim(),
      },
    );
    log("RESPONSE:${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("DATA:$data");
      status = true;
    } else {
      log('EXCEPTION: ${response.statusCode}');
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Page",
          style: GoogleFonts.quicksand(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(11.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.network(
                  "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes-thumbnail.png",
                  width: 90,
                  height: 90,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    hintText: "Enter the Username",
                    label: const Text(
                      "Enter Username",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    print("In UserName Validator");
                    if (value == null || value.isEmpty) {
                      return "Please Enter username";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordNameController,
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    label: const Text(
                      "Enter Password",
                    ),
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                  validator: (value) {
                    print("In UserName Validator");
                    if (value == null || value.isEmpty) {
                      // showSnakBar1();
                      return "Please Enter password";
                    } else {
                      // showSnakBar();
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    bool loginValidated = _formKey.currentState!.validate();
                    if (loginValidated) {
                      /// CALL TO API LOGIN()
                      bool status = await login();
                      if (status) {
                        const snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Login Successful",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      } else {
                        const snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Login Failed",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      const snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          "Enter Valid Data",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: Text(
                    "Don't have Account SignUp Here",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountInform()));
                  },
                  child: Text(
                    "Forgot Password",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
