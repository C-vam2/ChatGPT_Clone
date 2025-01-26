import 'package:chatgpt/database/database.dart';
import 'package:chatgpt/models/conversationModel.dart';
import 'package:chatgpt/providers/chatProvider.dart';
import 'package:chatgpt/widgets/profileCardWidget.dart';
import 'package:chatgpt/widgets/shimmerLoader.dart';
import 'package:chatgpt/widgets/unauthenticatedDrawerWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  late Future<List<ConversationModel>> futureConversation;
  @override
  void initState() {
    // TODO: implement initState
    if (FirebaseAuth.instance.currentUser != null) {
      futureConversation =
          MongoDB.getConversations(FirebaseAuth.instance.currentUser!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        backgroundColor: Color(0xff0d0d0d),
        child: FirebaseAuth.instance.currentUser != null
            ? Column(
                children: [
                  Container(
                    // color: Colors.red,
                    padding:
                        EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 5, left: 5),
                          width: MediaQuery.of(context).size.width * 0.57,
                          decoration: BoxDecoration(
                            color: Color(0xff242424),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(right: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  child: SvgPicture.asset(
                                    "assets/images/search.svg",
                                    height: 20,
                                    width: 20,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  onSubmitted: (val) {},
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<ChatProvider>(
                            builder: (context, value, child) {
                          return IconButton(
                              onPressed: () async {
                                print('a');
                                await value.newChat(
                                    FirebaseAuth.instance.currentUser!.uid);
                                Scaffold.of(context).closeDrawer();
                              },
                              icon: SvgPicture.asset(
                                'assets/images/new.svg',
                                color: Colors.white,
                                height: 20,
                                width: 20,
                              ));
                        })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Consumer<ChatProvider>(
                              builder: (context, value, child) {
                            return Container(
                              color: value.currConversationId == ""
                                  ? Color(0xff2f2f2f)
                                  : null,
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  "assets/images/logo.svg",
                                  height: 20,
                                  width: 20,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "ChatGPT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                dense: true,
                              ),
                            );
                          }),
                          Container(
                            child: ListTile(
                              leading: SvgPicture.asset(
                                "assets/images/explore.svg",
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Explore GPTs",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              dense: true,
                            ),
                          ),
                          Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Color(0xff2f2f2f),
                          ),
                          FutureBuilder(
                            future: futureConversation,
                            builder: (context, snapshot) {
                              // Display loading indicator while waiting for the future
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  child: ShimmerLoader(
                                      screenSize: MediaQuery.of(context).size),
                                );
                              }

                              // Handle error case
                              if (snapshot.hasError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: Text(
                                      "Unable to retrieve chats !!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }

                              // Handle the case when data is available
                              if (snapshot.hasData) {
                                final data = snapshot.data!;

                                // Display message when there are no chats
                                if (data.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "No chats available.",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "Chats",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      dense: true,
                                    ),
                                    ...data
                                        .map((e) => Consumer<ChatProvider>(
                                                builder:
                                                    (context, value, child) {
                                              return ListTile(
                                                tileColor:
                                                    value.currConversationId ==
                                                            e.convId
                                                        ? Color(0xff2f2f2f)
                                                        : null,
                                                dense: false,
                                                title: Text(
                                                  e.title
                                                          .substring(0, 1)
                                                          .toUpperCase() +
                                                      e.title.substring(1),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                trailing: Text(
                                                  formatDateTime(
                                                    e.timestamp.toString(),
                                                  ),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                onTap: () async {
                                                  if (value.chats.isEmpty) {
                                                    value.setConvId(e.convId);
                                                    value.setChat(e.chats);
                                                    print('1');
                                                  } else {
                                                    print('1.5');
                                                    await value.newChat(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid);
                                                    value.setConvId(e.convId);
                                                    value.setChat(e.chats);
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            }))
                                        .toList()
                                        .reversed,
                                  ],
                                );
                              }

                              // Fallback for unexpected states
                              return Container();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  ProfileCardWidget(),
                ],
              )
            : UnauthenticatedDrawer(),
      ),
    );
  }

  String formatDateTime(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    String formattedDate = DateFormat('dd MMM').format(dateTime);
    return formattedDate;
  }
}
