import 'package:chatter_box/api/api.dart';
import 'package:chatter_box/helper/my_date_util.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/Message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);

  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  //sender or another user message
  Widget _blueMessage() {
    //updated last read messages if sender and recivers are different
    if(widget.message.read.isNotEmpty){
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            //message ocntent
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .05, vertical: mq.height * .02),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //border curved
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        //show time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .05),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  //sender or another user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: mq.width * .04),
            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            SizedBox(
              width: 4,
            ),
            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            //message ocntent
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .05, vertical: mq.height * .02),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen), //border curved
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
