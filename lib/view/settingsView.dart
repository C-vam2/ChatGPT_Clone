import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SettingsView allows users to manage their profile and settings, including logout functionality.

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.black,
      body: FirebaseAuth.instance.currentUser != null
          ? Container(
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(400),
                      ),
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(400),
                          ),
                          child: Center(
                            child: Text(
                              FirebaseAuth.instance.currentUser!.displayName!
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                    title: Text(
                      FirebaseAuth.instance.currentUser!.displayName ??
                          "Random Name",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Email",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      FirebaseAuth.instance.currentUser!.email!,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Phone number",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "+91xxxxxxxxxx",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/images/upgrade.svg',
                      color: Colors.white,
                    ),
                    title: Text(
                      "Upgrade to Plus",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('model');
                      final res = await FirebaseAuth.instance.signOut();
                      print("signout==>");
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red[200],
                    ),
                    trailing: Container(
                        height: 25,
                        width: 25,
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Container()),
                    title: Text(
                      "Sign out",
                      style: TextStyle(color: Colors.red[200]),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Text(
                "Log in or sign up to update settings.",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
