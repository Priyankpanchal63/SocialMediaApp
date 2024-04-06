import 'package:demo_social/bloc/auth_cubit.dart';
import 'package:demo_social/screen/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = "/sign_in_screen";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _email = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    context.read<AuthCubit>().signInWithEmail(email: _email, password: _password);
  }

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
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
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (prevState, currentState) {
                if (currentState is AuthError) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                      content: Text(
                        currentState.message,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }

                if (currentState is AuthSignIn) {
                  if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verify your Email"),
                      ),
                    );
                  }
                  // Navigator.of(context)
                  // .pushReplacementNamed(PostScreen.routeName);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("LinkUp",style: TextStyle(fontSize: 75,fontWeight: FontWeight.w200),),
                        const SizedBox(height: 15,),
                        const Text("Sign in",style: TextStyle(fontSize: 30,color: Colors.grey,fontWeight: FontWeight.normal),),
                        const SizedBox(height: 15,),
                        // Email TextFormField
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _email = value!.trim();
                          },
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelText: "Enter email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Provide Email";
                            }
                            if (value.length < 4) {
                                  return "Please Provide Longer Email...";
                            }
                            return null;
                          },
                        ),
                        // Password TextFormField
                        SizedBox(height: 15),
                        TextFormField(
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            _password = value!.trim();
                          },
                          onFieldSubmitted: (_) => _submit(),
                          decoration:  InputDecoration(
                            icon: Icon(Icons.password),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelText: "Enter Password",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Provide Password";
                            }
                            if (value.length < 5) {
                              return "Please Provide Longer Password...";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        // Log In Button
                        ElevatedButton(
                          onPressed: () => _submit(),
                          child: const Text("Log In",style: TextStyle(fontWeight: FontWeight.w300),),
                        ),
                        // Sign Up Instead Button
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(SignUpScreen.routeName),
                          child: const Text("Sign Up Instead",style: TextStyle(fontWeight: FontWeight.w300)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
