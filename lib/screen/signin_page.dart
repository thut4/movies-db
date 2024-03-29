import 'package:datshin/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  StateMachineController? controller;
  bool loading = false;
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffD6E2EA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: size.height / 6,
                child: RiveAnimation.asset(
                  "assets/images/animated_login_character.riv",
                  stateMachines: const ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                        artboard, "Login Machine");
                    if (controller == null) return;

                    artboard.addController(controller!);
                    isChecking = controller?.findInput("isChecking");
                    isHandsUp = controller?.findInput("isHandsUp");
                    trigSuccess = controller?.findInput("trigSuccess");
                    trigFail = controller?.findInput("trigFail");
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    if (isChecking != null) {
                      isChecking!.change(false);
                    }
                    if (isHandsUp == null) return;

                    isHandsUp!.change(false);
                  }, // to
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  onChanged: (value) {
                    if (isChecking != null) {
                      isChecking!.change(false);
                    }
                    if (isHandsUp == null) return;

                    isHandsUp!.change(true);
                  },
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      child: const Text("Register/Login")),
              ElevatedButton(
                  onPressed: () {
                    _loginGoogle();
                  },
                  child: const Text('Login with Google'))
            ],
          ),
        ),
      ),
    );
  }

  _snackbar(String desc) {
    Get.snackbar("Error", desc,
        backgroundColor: Colors.redAccent, snackPosition: SnackPosition.BOTTOM);
  }

  _register() async {
    loading = true;
    bool error = false;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      error = true;
      if (e.code == 'weak-password') {
        _snackbar("Weak Password");
      } else if (e.code == 'email-already-used') {
        _snackbar("Email ALready Registered");
      }
    } catch (e) {
      _snackbar(e.toString());
    } finally {
      loading = false;
      if (!error) {
        _login();
      } else {
        setState(() {});
      }
    }
  }

  _login() async {
    bool isError = false;
    setState(() {});
    // loading = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      isError = true;
      if (e.code == 'user-not-found') {
        _register();
      } else if (e.code == 'wrong-password') {
        _snackbar("Wrong Password");
      } else {
        _snackbar(e.code);
      }
    } finally {
      if (!isError) {
        loading = false;
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          _snackbar("Please Check your verification!");
          setState(() {});
        } else {
          Get.off(() => const HomePage());
        }
      } else {
        setState(() {});
      }
    }
  }

  _loginGoogle() async {
    await signInWithGoogle();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.off(() => const HomePage());
    }
  }
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleSignInAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuth?.accessToken,
      idToken: googleSignInAuth?.idToken);
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
