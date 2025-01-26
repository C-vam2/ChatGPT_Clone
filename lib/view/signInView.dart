import 'package:chatgpt/utils.dart';
import 'package:chatgpt/view/homePageView.dart';
import 'package:chatgpt/view/signUpView.dart';
import 'package:chatgpt/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A StatefulWidget for user sign-in functionality
class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool isLoading = false; // Tracks loading state during sign-in

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(); // Initialize email controller
    _passwordController =
        TextEditingController(); // Initialize password controller
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                color: Color(0xff4aa081),
              )
            : Container(
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
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Welcome back",
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
                              labelText: 'Email',
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
                          TextField(
                            controller: _passwordController,
                            cursorColor: Color(0xff4aa081),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 0.7, color: Colors.grey),
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
                          SizedBox(
                            height: 16,
                          ),
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
                                if (emailAddress.isEmpty || password.isEmpty) {
                                  Utils.showSnackBar(
                                      "Enter valid credentials", context);
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                final response = await AuthServices
                                    .signInWithEmailAndPassword(
                                        emailAddress, password);
                                setState(() {
                                  isLoading = false;
                                });
                                if (response == "success") {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePageView()));
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
                                "Sign in",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SignupView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(color: Color(0xff4aa081)),
                                ),
                              )
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
