import 'package:demo_social/modals/chat_modal.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

   final ChatModal chatModal;
   final String  currentUserID;

  const ChatBubble(this.chatModal,this.currentUserID,{super.key});
  @override

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft:const Radius.circular(15),
          topRight:const Radius.circular(15),
          bottomLeft: chatModal.userID == currentUserID ?const Radius.circular(15):Radius.zero,
          bottomRight: chatModal.userID == currentUserID ? Radius.zero :const Radius.circular(15),
        ),
      ),
      child: Column(
          crossAxisAlignment: chatModal.userID == currentUserID ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text("By${chatModal.username}",style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            SizedBox(height: 5),
            Text(chatModal.message,style:const TextStyle(color: Colors.black),
            ),
          ],
      ),
    );
  }
}
