import 'package:datshin/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datshin'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(
              height: 14,
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
    );
  }

  _snackbar(String desc) {
    Get.snackbar("Error", desc,
        backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
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
    loading = true;
    setState(() {});
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      isError = true;
      if (e.code == 'user-not-found') {
        _register();
      } else if (e.code == 'wrong-password') {
        _snackbar("Wrond Password");
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
      Get.off(() =>const HomePage());
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
