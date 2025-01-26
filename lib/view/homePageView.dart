import 'package:chatgpt/providers/chatProvider.dart';
import 'package:chatgpt/view/signUpView.dart';
import 'package:chatgpt/widgets/drawer.dart';
import 'package:chatgpt/widgets/homeScreenBody.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the home page of the application, providing a UI to interact with ChatGPT.
class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<String> modelIds = ["gpt-4o-mini", "gpt-4", "gpt-3.5-turbo"];
  bool isLoading = false;
  late final SharedPreferences prefs;

  /// Fetches and initializes the selected model ID from SharedPreferences.
  _getModelId() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getModelId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            backgroundColor: Color(0xff0d0d0d),
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return Scaffold(
                drawer: SideDrawer(),
                appBar: AppBar(
                  backgroundColor: Color(0xff0d0d0d),
                  elevation: 0,
                  surfaceTintColor: Color(0xff0d0d0d),
                  leading: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: SvgPicture.asset(
                        "assets/images/icon.svg",
                        color: Colors.white,
                        height: 20,
                        width: 20,
                      ),
                    );
                  }),
                  title: Text(
                    "ChatGPT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  actions: [
                    snapshot.hasData
                        ? Consumer<ChatProvider>(
                            builder: (context, value, child) {
                            return GestureDetector(
                              onTap: () async {
                                if (value.chats.isEmpty) {
                                  null;
                                }
                                await value.newChat(
                                    FirebaseAuth.instance.currentUser!.uid);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: SvgPicture.asset(
                                  'assets/images/new.svg',
                                  color: value.chats.isEmpty
                                      ? Color(0xff5e5e5e)
                                      : Colors.white,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            );
                          })
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: snapshot.hasData
                          ? GestureDetector(
                              onTap: () {
                                modelIds.isEmpty
                                    ? null
                                    : showMenu(
                                        context: context,
                                        color: Color(0xff242424),
                                        constraints: BoxConstraints(
                                            maxHeight: screenSize.height * 0.25,
                                            maxWidth: screenSize.width * 0.4),
                                        position: RelativeRect.fromLTRB(
                                            screenSize.width * 0.7,
                                            screenSize.height * 0.075,
                                            screenSize.width * 0.075,
                                            screenSize.height * 0.7),
                                        items: modelIds
                                            .map(
                                              (e) => PopupMenuItem(
                                                onTap: () {
                                                  prefs.setString("model", e);
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      );
                              },
                              child: SizedBox(
                                width: 80,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        prefs.getString('model') ??
                                            "gpt-4o-mini",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down_outlined),
                                  ],
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupView(),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 1),
                              ),
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                  ],
                ),
                backgroundColor: Color(0xff0d0d0d),
                body: Consumer<ChatProvider>(builder: (context, value, child) {
                  return HomeScreenBody(
                    screenSize: screenSize,
                    model: prefs.getString('model') ?? "gpt-4o-mini",
                  );
                }),
              );
            });
  }
}
