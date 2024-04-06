import 'package:demo_social/bloc/auth_cubit.dart';
import 'package:demo_social/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {

  static  const String routeName="/sign_up_screen";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email="";
  String _username="";
  String _password="";

  late final FocusNode _usernameFocusNode;
  late final FocusNode _PasswordFocusNode;

  final _formKey=GlobalKey<FormState>();
  void _submit()
  {
    FocusScope.of(context).unfocus();
    if(!_formKey.currentState!.validate()){
      //Invalid!
      return ;
    }
    _formKey.currentState!.save();
    context.read<AuthCubit>().signUpWithEmail(
        email: _email,
        username: _username,
        password: _password);
    //TODO:- ADD email verification
  }

  @override
  void initState() {
    // TODO: implement initState
    _usernameFocusNode=FocusNode();
    _PasswordFocusNode=FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameFocusNode.dispose();
    _PasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: BlocConsumer<AuthCubit,AuthState>(
              listener: (prevState,currentState){
               
                if(currentState is AuthSignUp){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Email Verification link has been sent ,verify your Email and log in  "),
                  ),
                  );
                  // Navigator.of(context).pushReplacementNamed(PostScreen.routeName);
                }
                if(currentState is AuthError){
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                        content: Text(currentState.message,style: TextStyle(color: Theme.of(context).colorScheme.onError),
                        ),
                        duration:const Duration(seconds: 2) ,
                  ),
                  );
                }
              },
              builder: (context,state){
                if(state is AuthLoading){
                  return const Center(child: CircularProgressIndicator());
                }
                return Center(
                  child: SingleChildScrollView(

                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                    children: [
                      Text("Sing Up",style: TextStyle(fontSize: 30,color: Colors.grey,fontWeight: FontWeight.normal),),
                      SizedBox(height: 15,),
                      //Email
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        onSaved: (value){
                          _email=value!.trim();
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_usernameFocusNode),
                        decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelText: "Enter email"),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please Provide Email";
                          }
                          if(value.length<4)
                          {
                            return"Please Provide Longer Email...";
                          }
                          return null;
                        },
                      ),
                         SizedBox(height: 15),
                      //userName
                      TextFormField(
                        focusNode: _usernameFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_PasswordFocusNode),
                        onSaved: (value){
                          _username=value!.trim();
                        },
                        decoration: InputDecoration(
                            icon: Icon(Icons.account_circle_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelText: "Enter UserName"),

                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please Provide UserName";
                          }
                          if(value.length<4)
                          {
                            return"Please Provide Longer UserName...";
                          }
                          return null;
                        },

                      ),

                      //password
                       SizedBox(height: 15),
                      TextFormField(
                        focusNode: _PasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        onFieldSubmitted: (_) => _submit(),
                        onSaved: (value){
                          _password=value!.trim();
                        },
                        decoration: InputDecoration(
                            icon: Icon(Icons.password),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelText: "Enter Password"),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please Provide Password";
                          }
                          if(value.length<4)
                          {
                            return"Please Provide Longer Password...";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8,),
                      ElevatedButton(
                          onPressed: (){

                        _submit();

                        },
                          child: const Text("Sign Up",style: TextStyle(fontWeight: FontWeight.w300))),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(SignInScreen.routeName),
                        child: const Text("Sign In Instead",style: TextStyle(fontWeight: FontWeight.w300)),
                      ),
                    ],
                   ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
