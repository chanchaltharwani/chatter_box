import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatter_box/api/api.dart';
import 'package:chatter_box/helper/my_date_util.dart';
import 'package:chatter_box/models/Message.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_users.dart';
import '../screens/ChatScreen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
            onTap: () {
              //for navigating to chat screen

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            user: widget.user,
                          )));
            },
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .3),
                    child: CachedNetworkImage(
                      width: mq.height * .055,
                      height: mq.height * .055,
                      imageUrl: widget.user.image,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          CircleAvatar(child: Icon(Icons.person)),
                    ),
                  ),

                  title: Text(widget.user.name), //last message
                  subtitle: Text(
                    _message != null ? _message!.msg : widget.user.about,
                    maxLines: 1,
                  ), //last message time

                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&  _message!.fromId != APIs.user.uid
                          ? Container(
                              width: 16,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : Text(
                    MyDateUtil.getLastMessageTime(context: context, time:  _message!.sent),

                              style: TextStyle(color: Colors.black54),
                            ),
                );
              },
            )));
  }
}
