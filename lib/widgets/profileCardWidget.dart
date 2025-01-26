import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/settingsView.dart';

/// A widget that displays a profile card with the user's name and a profile icon.
class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SettingsView()));
        },
        leading: Container(
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
                    fontSize: 16),
              ),
            )),
        title: Text(
          FirebaseAuth.instance.currentUser!.displayName ?? "Random name",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
