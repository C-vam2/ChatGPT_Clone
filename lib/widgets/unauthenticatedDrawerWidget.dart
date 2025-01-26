import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/chatProvider.dart';
import '../view/settingsView.dart';
import '../view/signUpView.dart';

/// A drawer widget displayed for unauthenticated users with options like "New Chat", "Terms", "Privacy", and "Settings".

class UnauthenticatedDrawer extends StatelessWidget {
  const UnauthenticatedDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, value, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  'assets/images/new.svg',
                  color: Colors.white,
                  height: 20,
                  width: 20,
                ),
                title: Text(
                  "New Chat",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                onTap: () async {
                  await value.newChat("");
                  Scaffold.of(context).closeDrawer();
                },
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Color(0xff2f2f2f),
              ),
              ListTile(
                  dense: true,
                  title: Text(
                    "Terms",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  )),
              ListTile(
                  dense: true,
                  title: Text(
                    "Privacy",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  )),
              ListTile(
                dense: true,
                title: Text(
                  "Settings",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsView(),
                  ));
                },
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, bottom: 10),
                child: Text(
                  "Save your chat history,share chats,and personalize your experience.",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignupView(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.65, 10)),
                  child: Text(
                    "Log in or sign up",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ],
      );
    });
  }
}
