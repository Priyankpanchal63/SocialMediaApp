import 'package:demo_social/bloc/auth_cubit.dart';
import 'package:demo_social/screen/chat_screen.dart';
import 'package:demo_social/screen/create_post_screen.dart';
import 'package:demo_social/screen/post_screen.dart';
import 'package:demo_social/screen/sign_in_screen.dart';
import 'package:demo_social/screen/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //check authState
  Widget _buildHomeScreen(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
        builder: (context,snapshot){

        if(snapshot.hasData){
           if(snapshot.data!.emailVerified){
           return const PostScreen();
           }

          return const SignInScreen();
        }
        else{
          return const SignInScreen();
        }

    },
    );
  }

  @override
  Widget build(BuildContext context) {

    return  BlocProvider<AuthCubit>(
      create: (context)=>AuthCubit(),
      child: MaterialApp(
      
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
      
      
        home: _buildHomeScreen(),
      
        routes: {
          SignUpScreen.routeName:(context) =>const SignUpScreen(),
          SignInScreen.routeName:(context) =>const SignInScreen(),
          PostScreen.routeName:(context)=> const PostScreen(),
          CreatePostScreen.routName:(context)=>const CreatePostScreen(),
          ChatScreen.routeName:(context)=>const ChatScreen(),
        },
      ),
    );
  }
}

