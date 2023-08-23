

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatter_box/models/Message.dart';
import 'package:chatter_box/models/chat_users.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../Widgets/message_card.dart';
import '../api/api.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  // Create an instance of the Logger class
  final ChatUser user;

  ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];
  final logger = Logger();

  //for handling message tect change
  final _textController = TextEditingController();

  // for storing value of showing or hiding emoji
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: (){
            if(_showEmoji){
              setState(() {

                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            }
            
            else{
              return Future.value(true);
            }
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: _appBar(),
              ),
              backgroundColor: Color.fromARGB(255, 234, 248, 255),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: APIs.getAllMessages(widget.user),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            //if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const SizedBox();

                            //if some or all data is loaded then show it
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;

                              _list = data
                                      ?.map((e) => Message.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                    itemCount: _list.length,
                                    padding: EdgeInsets.only(top: mq.height * 0),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      //return Text('Name: ${list[index]}');
                                      return MessageCard(
                                        message: _list[index],
                                      );
                                    });
                              } else {
                                return Center(
                                    child: Text(
                                  "Say Hii! 👋",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ));
                              }
                          }
                        }),
                  ),
                  _chatInput(),
                  //emoji on keyboard emoji button click and vice versa
                  if(_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(

                      textEditingController: _textController,
                      config: Config(
                        bgColor: Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),

                      ),
                    ),
                  )
                  //emoji code
                ],
              )),
        ),
      ),
    );
  }

  // custome  app bar
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),
          //for show user profile
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  CircleAvatar(child: Icon(Icons.person)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          //
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //for show user name
              Text(
                widget.user.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 3,
              ),
              //last seenm show
              Text(
                "Last seen not availble",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //bottom chat inpur field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .03),
      child: Row(
        children: [
          //input Field and buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)), //elevation: ,
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 26,
                      )),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: (){
                      setState(() {
                        if(_showEmoji)
                        _showEmoji = !_showEmoji;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Type Something....',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  //adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ), //send message button
          MaterialButton(
            shape: CircleBorder(),
            padding: EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 10),
            color: Colors.green,
            onPressed: () {

              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
               // logger.d(widget.user);
              }
            },
            minWidth: 0,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }


}
