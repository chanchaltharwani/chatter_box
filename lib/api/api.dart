import 'dart:developer';
import 'dart:io';

import 'package:chatter_box/models/Message.dart';
import 'package:chatter_box/models/chat_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  //for Authenications
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for storing self information
  static late ChatUser me;

  //for accesing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accesing  firestore storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //to return current user
  static User get user => auth.currentUser!;

// check if user is exist or not
  static Future<bool> userExist() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  //for getting current user info

  static Future<void> getSelfInfo() async {
    return (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data:${user.data()!}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    }));
  }

  //for creating new  user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: user.uid,
        name: auth.currentUser!.displayName.toString(),
        email: user.email.toString(),
        about: "Helloo, i m using chatter box",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for update data
  static Future<void> updateUserInfo() async {
    (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about}));
  }

  //update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path?.split('.').last;
    log('Extensions:$ext');
    //storafge file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferd: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'image': me.image}));
  }

  //******Chat screen related apis**************

//chats (collections) --> conversation_id (doc) --> messages (collection) --> message (doc)
  //useful for getting conversion id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting all messagesof a specific conversions from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  //for sending message

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    // message sending time (also used as id )
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot> getLastMessage(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
  }
}
