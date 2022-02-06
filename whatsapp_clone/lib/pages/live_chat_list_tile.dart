// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


class ChatUserListTile extends StatelessWidget {
  final name;
  final lastMessage;
  final pictureUrl;
  final unseenMessageCount;
  final Function()? clickAction;
  const ChatUserListTile({ Key? key, required this.name, this.lastMessage, required this.pictureUrl, this.unseenMessageCount, required this.clickAction }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          //tileColor: Colors.white,
          onTap: clickAction,
          leading: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(radius: 34,foregroundImage: NetworkImage(pictureUrl),),
                      alignment: Alignment.center,
                    ),
          title: Text(name,style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 17
          ),),
          subtitle: Text(lastMessage??""),
          trailing: unseenMessageCount==0? null : ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              color: Colors.grey[200],
              height: 30,width: 30,
              alignment: Alignment.center,
              child: Text(
                "${unseenMessageCount??0}",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
        Divider(height: 1,)
      ],
    );
  }
}











//list tile with stateful widget

// class ChatUserListTile extends StatefulWidget {
//   final name;
//   final lastMessage;
//   final pictureUrl;
//   final unseenMessageCount;
//   final Function()? clickAction;
//   const ChatUserListTile({required this.name, required this.lastMessage,required this.pictureUrl, Key? key, required this.clickAction, required this.unseenMessageCount}) : super(key: key);

//   @override
//   _ChatUserListTileState createState() => _ChatUserListTileState();
// }

// class _ChatUserListTileState extends State<ChatUserListTile> {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 20),
//       tileColor: Colors.white,
//       onTap: widget.clickAction,
//       leading: Container(
//                   height: 46,
//                   width: 46,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.green,
//                   ),
//                   child: CircleAvatar(radius: 34,foregroundImage: NetworkImage(widget.pictureUrl),),
//                   alignment: Alignment.center,
//                 ),
//       title: Text(widget.name,style: TextStyle(
//         fontWeight: FontWeight.w600, fontSize: 17
//       ),),
//       subtitle: Text(widget.lastMessage),
//       trailing: ClipRRect(
//         borderRadius: BorderRadius.circular(30),
//         child: Container(
//           color: Colors.grey[200],
//           height: 30,width: 30,
//           alignment: Alignment.center,
//           child: Text(
//             widget.unseenMessageCount,
//             style: TextStyle(
//               backgroundColor: Colors.grey[200],
//               fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
