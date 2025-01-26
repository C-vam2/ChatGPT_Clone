import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../controllers/imageController.dart';
import '../models/imageModel.dart';
import '../providers/imageProvider.dart';
import '../view/signInView.dart';
import '../view/signUpView.dart';

/// A widget that allows the user to select an image. If the user is not logged in,
/// it prompts them to sign up or log in. If logged in, the image is picked and uploaded.
class SelectImageWidget extends StatelessWidget {
  const SelectImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectImageProvider>(builder: (context, value, child) {
      return GestureDetector(
        onTap: () async {
          if (FirebaseAuth.instance.currentUser == null) {
            showModalBottomSheet(
              backgroundColor: Color(0xff0d0d0d),
              context: context,
              builder: (context) {
                return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.325,
                    child: Column(
                      children: [
                        ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 20, right: 20, top: 5),
                          child: Text(
                            "Sign up or log in to analyze images for free",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignupView(),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            child: Text(
                              "Sing up",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SigninView(),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff2f2f2f)),
                            child: Text(
                              "Log in",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ));
              },
            );
          } else {
            final res = await PickImage.pickImageFromGallery();
            if (res != null) {
              value.addImage(ImageModel(image: res, state: "loading", url: ""));
              final resultUrl =
                  await value.uploadImage(res, value.selectedImage.length - 1);
              if (resultUrl == "error") {
                value.selectedImage.last.state = "error";
              }
              print(resultUrl);
            }
          }
        },
        child: SizedBox(
            height: 45,
            child: SvgPicture.asset(
              "assets/images/picture.svg",
              color: Colors.white,
            )),
      );
    });
  }
}
