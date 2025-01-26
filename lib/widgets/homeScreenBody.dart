import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/models/imageModel.dart';
import 'package:chatgpt/providers/chatProvider.dart';
import 'package:chatgpt/providers/imageProvider.dart';
import 'package:chatgpt/services/api_services.dart';
import 'package:chatgpt/utils.dart';
import 'package:chatgpt/widgets/selectImageWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../models/chatModel.dart';
import 'inputMessageWidget.dart';
import 'introHompage.dart';

class HomeScreenBody extends StatefulWidget {
  final Size screenSize;
  final String model;
  const HomeScreenBody(
      {super.key, required this.screenSize, required this.model});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody>
    with WidgetsBindingObserver {
  late ChatProvider chatProvider;

  late FocusNode _focusNode;

  late ScrollController _scrollController;
  bool isLoading = false;
  bool isTyping = false;

  late TextEditingController _textEditingController;

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController(
      onAttach: (position) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent + 100,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeIn);
        });
      },
    );
    scrollToBottom();
    WidgetsBinding.instance.addObserver(this);
    _focusNode = FocusNode();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (FirebaseAuth.instance.currentUser != null) {
      if (state == AppLifecycleState.detached) {
        chatProvider.newChat(FirebaseAuth.instance.currentUser!.uid);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);
    return Consumer<ChatProvider>(builder: (context, value, child) {
      return SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: value.chats.isEmpty
                    ? IntroHomepage(
                        textEditingController: _textEditingController)
                    : Consumer<ChatProvider>(builder: (context, value, child) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            if (value.chats.isNotEmpty) {
                              scrollToBottom();
                            }
                          },
                        );
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: value.chats.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (value.chats[index].urls !=
                                                          null &&
                                                      value.chats[index].urls!
                                                          .isNotEmpty)
                                                  ? SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.65,
                                                      child: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: GridView.builder(
                                                          reverse: true,
                                                          gridDelegate:
                                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                                            maxCrossAxisExtent:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35, // Adjust as needed
                                                            mainAxisSpacing: 5,
                                                            crossAxisSpacing: 5,
                                                          ),
                                                          shrinkWrap: true,

                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          // Prevents scroll conflicts
                                                          itemCount: value
                                                              .chats[index]
                                                              .urls!
                                                              .length,
                                                          itemBuilder: (context,
                                                              index2) {
                                                            return ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  InstaImageViewer(
                                                                child: Image
                                                                    .network(
                                                                  value
                                                                      .chats[
                                                                          index]
                                                                      .urls![index2],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: double
                                                                      .infinity,
                                                                  width: double
                                                                      .infinity,
                                                                  errorBuilder:
                                                                      (context,
                                                                          child,
                                                                          loadingProgress) {
                                                                    return Icon(
                                                                      Icons
                                                                          .error_outline,
                                                                      color: Colors
                                                                          .white,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                alignment:
                                                    Alignment.centerRight,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff181818),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Text(
                                                    value.chats[index].user,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    maxLines: null,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    (isLoading &&
                                            index == value.chats.length - 1)
                                        ? Container(
                                            alignment: Alignment.centerLeft,
                                            width: 40,
                                            // color: Colors.red,
                                            child: SpinKitPulse(
                                              color: Colors.white,
                                              size: 20.0,
                                            ),
                                          )
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: (index ==
                                                                value.chats
                                                                        .length -
                                                                    1 &&
                                                            isTyping)
                                                        ? Container(
                                                            child:
                                                                DefaultTextStyle(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              child:
                                                                  AnimatedTextKit(
                                                                animatedTexts: [
                                                                  TyperAnimatedText(
                                                                      value
                                                                          .chats[
                                                                              index]
                                                                          .gpt!,
                                                                      speed: Duration(
                                                                          microseconds:
                                                                              500))
                                                                ],
                                                                isRepeatingAnimation:
                                                                    false,
                                                                repeatForever:
                                                                    false,
                                                                totalRepeatCount:
                                                                    1,
                                                                onFinished: () {
                                                                  setState(() {
                                                                    isTyping =
                                                                        false;
                                                                  });
                                                                  scrollToBottom();
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        : Text(
                                                            value.chats[index]
                                                                .gpt!,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            maxLines: null,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }),
              ),
              Consumer<SelectImageProvider>(builder: (context, value, child) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: widget.screenSize.height *
                          (value.selectedImage.isEmpty ? 0.2 : 0.35)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.screenSize.width * 0.025,
                        vertical: 10),
                    width: widget.screenSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SelectImageWidget(),
                        InputMessageWidget(
                            widget: widget,
                            focusNode: _focusNode,
                            textEditingController: _textEditingController),
                        Consumer2<ChatProvider, SelectImageProvider>(
                            builder: (context, value2, value3, child) {
                          return Container(
                            // color: Colors.red,
                            alignment: Alignment.center,
                            height: 45,
                            child: GestureDetector(
                              onTap: () async {
                                var message = _textEditingController.text;
                                if (message.isEmpty) {
                                  Utils.showSnackBar(
                                      "Text Input can not be empty", context);
                                  return null;
                                }

                                if (value3.count !=
                                    value3.selectedImage.length) {
                                  return null;
                                }

                                _focusNode.unfocus();
                                _textEditingController.clear();
                                if (value3.selectedImage.isNotEmpty) {
                                  value3.isSent = false;
                                  await _sendVisionMessage(
                                      message, value3.selectedImage, value2);
                                  value3.clearImage();
                                  value3.isSent = true;
                                } else {
                                  await _sendMessage(
                                      message, widget.model, value2);
                                }

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent +
                                        200,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeOut,
                                  );
                                });
                              },
                              child: Container(
                                height: widget.screenSize.width * 0.085,
                                width: widget.screenSize.width * 0.085,
                                decoration: BoxDecoration(
                                  color: (value3.count !=
                                          value3.selectedImage.length)
                                      ? Color(0xff272727)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.arrow_upward_sharp,
                                  color: (value3.count !=
                                          value3.selectedImage.length)
                                      ? Color(0xff696969)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                );
              }),
            ]),
      );
    });
  }

  _sendMessage(String message, String modelId, ChatProvider value) async {
    Chat chat = Chat(user: message, timestamp: DateTime.now(), model: modelId);
    value.addChat(chat);
    setState(() {});
    await _getChat(message, modelId, value);
  }

  _sendVisionMessage(
      String message, List<ImageModel> images, ChatProvider value) async {
    List<String> urls = [];
    for (var element in images) {
      urls.add(element.url);
    }
    Chat chat = Chat(
        user: message,
        timestamp: DateTime.now(),
        model: "gpt-4-turbo-2024-04-09",
        urls: urls);
    value.addChat(chat);
    setState(() {});
    await _getVisionChat(message, images, value);
  }

  Future<void> _getChat(
      String message, String modelId, ChatProvider value) async {
    setState(() {
      isLoading = true;
    });

    String response = await ApiServices.getResponse(message, modelId);

    int n = value.chats.length;
    if (response == 'error') {
      value.chats.removeLast();
    } else {
      value.chats[n - 1].gpt = response;
    }
    setState(() {
      isLoading = false;
      isTyping = true;
    });
  }

  Future<void> _getVisionChat(
      String message, List<ImageModel> images, ChatProvider value) async {
    setState(() {
      isLoading = true;
    });

    String response = await ApiServices.getVisionResponse(message, images);

    int n = value.chats.length;
    if (response == 'error') {
      value.chats.removeLast();
    } else {
      value.chats[n - 1].gpt = response;
    }
    setState(() {
      isLoading = false;
      isTyping = true;
    });
  }
}
