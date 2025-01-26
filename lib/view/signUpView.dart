import 'package:chatgpt/utils.dart';
import 'package:chatgpt/view/signInView.dart';
import 'package:chatgpt/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A StatefulWidget that represents the Signup view of the application.
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  /// Initializes the text controllers when the widget is created.
  @override
  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  bool isLoading = false;

  /// Disposes the text controllers to free resources when the widget is removed.
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  /// Builds the Signup view UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                color: Color(0xff4aa081),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      color: Colors.black,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Create an account",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _emailController,
                            cursorColor: Color(0xff4aa081),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Email address*',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0.7, color: Colors.grey),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0.7, color: Color(0xff4aa081)),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              floatingLabelStyle: const TextStyle(
                                color: Color(
                                    0xff4aa081), // Label color when focused
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: TextField(
                                  controller: _firstNameController,
                                  cursorColor: Color(0xff4aa081),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'First Name',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0.7, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0.7, color: Color(0xff4aa081)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                      color: Color(
                                          0xff4aa081), // Label color when focused
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: TextField(
                                  controller: _lastNameController,
                                  cursorColor: Color(0xff4aa081),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Last Name",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.7, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.7,
                                            color: Color(0xff4aa081)),
                                        borderRadius: BorderRadius.circular(7)),
                                    floatingLabelStyle: const TextStyle(
                                      color: Color(0xff4aa081),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: _passwordController,
                                cursorColor: Color(0xff4aa081),
                                obscureText: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Password",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.7, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.7, color: Color(0xff4aa081)),
                                      borderRadius: BorderRadius.circular(7)),
                                  floatingLabelStyle: const TextStyle(
                                    color: Color(
                                        0xff4aa081), // Label color when focused
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Color(0xff4aa081),
                                    borderRadius: BorderRadius.circular(7)),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final emailAddress = _emailController.text;
                                    final password = _passwordController.text;
                                    final firstName = _firstNameController.text;
                                    final lastName = _lastNameController.text;

                                    if (!Utils.isValidEmail(emailAddress)) {
                                      Utils.showSnackBar(
                                          "Enter valid email address", context);
                                      return;
                                    }
                                    if (!Utils.isValidPassword(password)) {
                                      Utils.showSnackBar(
                                          "Password's length must me more than 5 characters.",
                                          context);
                                      return;
                                    }

                                    if (!Utils.isValidName(firstName) ||
                                        !Utils.isValidName(lastName)) {
                                      Utils.showSnackBar(
                                          "Your first name and last name should contain atleast 2 characters.",
                                          context);
                                      return;
                                    }
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final response = await AuthServices
                                        .createUserWithEmailAndPassword(
                                            emailAddress,
                                            password,
                                            firstName,
                                            lastName);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (response == "success") {
                                      Navigator.of(context).pop();
                                    } else {
                                      Utils.showSnackBar(response, context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff4aa081),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0),
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => SigninView(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "SignIn",
                                      style:
                                          TextStyle(color: Color(0xff4aa081)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
