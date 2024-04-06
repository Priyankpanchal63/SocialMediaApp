import 'package:demo_social/modals/post_modal.dart';
import 'package:demo_social/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {

  final Post post;

  const PostItem(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {

        Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: post.postID);

      },

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(post.imageUrl),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            const SizedBox(height: 6),
            Text(post.userName,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6),
            const SizedBox(height: 6),
            Text(post.description,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5),
          ],
        ),
      ),
    );
  }
}