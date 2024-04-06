import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_social/screen/create_post_screen.dart';
import 'package:demo_social/widget/post_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_social/screen/chat_screen.dart';
import 'package:demo_social/screen/sign_in_screen.dart';
import 'dart:io';
import '../modals/post_modal.dart';

class PostScreen extends StatefulWidget {
  static const String routeName = "/post_screen";

  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          //Add post(pick image and go to create post screen)
          IconButton(
              onPressed: () async {
                //TODO:= 1.Get image

                final ImagePicker imagePicker = ImagePicker();

                final XFile? xFile = await imagePicker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50);

                if (xFile != null) {
                  Navigator.of(context).pushNamed(CreatePostScreen.routName,
                    arguments: File(xFile.path),
                  );
                }
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              )),

          //Log out(navigate back to sign in screen)

          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
              )),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("posts").orderBy("timeStamp").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(child: Text("Oops,something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting ) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot doc = snapshot.data!.docs[index];

              final Post post = Post.fromSnapshot(doc);

              return PostItem(post);

            },
          );
        },
      ),
    );
  }
}
