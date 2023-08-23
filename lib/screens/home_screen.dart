import 'package:chatter_box/models/chat_users.dart';
import 'package:chatter_box/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Widgets/chat_user_card.dart';
import '../api/api.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUser> _list = [];

  //foe storing search items
  final List<ChatUser> _SearchList = [];

  //for storing serach status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //hiding keybpard
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //is search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: (){
          if(_isSearching){
            setState(() {

              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }
          else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          appBar: AppBar(
            leading: Icon(Icons.home),
            title: _isSearching ? TextField(

              decoration: InputDecoration(
                border: InputBorder.none,hintText: 'Name,Email...'
              ),
              autofocus: true,
              style: TextStyle(fontSize: 18,letterSpacing: 0.5),
              onChanged: (val){
                //serach logic
                _SearchList.clear();
                for(var i in _list){
                  if(i.name.toLowerCase().contains(val.toLowerCase())||
                      i.email.toLowerCase().contains(val.toLowerCase())){
                    _SearchList.add(i);
                  }
                  setState(() {
                    _SearchList;
                  });
                }
              },

            ):Text(
              "Chatter box",
            ),
            actions: [
              //search button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: Icon(Icons.more_vert))
            ],
          ),
          // floatingActionButton to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
          body:
          StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  // return const Center(
                  //     child: CircularProgressIndicator());

                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                            [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:  _isSearching ? _SearchList.length: _list.length,
                          padding: EdgeInsets.only(top: mq.height * 0),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            //return Text('Name: ${list[index]}');
                            return ChatUserCard(
                              user:_isSearching ?  _SearchList[index]: _list[index],
                            );
                          });
                    } else {
                      return Center(
                          child: Text(
                        "No connection found",
                        style: TextStyle(fontSize: 20),
                      ));
                    }
                }
              }),
        ),
      ),
    );
  }
}
