import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/main.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/utilities/firebase_database.dart';
import 'package:todo/utilities/sharedprefence.dart';
import 'package:todo/utilities/user_data.dart';
import 'package:todo/widgets/custom_widgets.dart';

class signup_screen extends StatefulWidget {
  const signup_screen({Key? key});
  @override
  _signup_screenState createState() => _signup_screenState();
}

class _signup_screenState extends State<signup_screen> {
  final _formkey1 = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();

  Future<void> movetosignup() async {
    print("Success");
    if (_formkey1.currentState != null && _formkey1.currentState!.validate()) {
      var result = await FirebaseStore.createuser(email.text, pass.text.trim());
      if (result == true) {
        var SharedPref = await SharedPreferences.getInstance();
        SharedPref.setBool(splash_screenState.KEYLOGIN, true);
        await UserData.userdata(
            FirebaseAuth.instance.currentUser!.uid, email.text, name.text);

        // context.go('/');

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const home_screen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );

        print("Succes");
      } else if (result is String) {
        String errorCode = result;
        if (errorCode == "invalid-email") {
          CustomSnackBar.showSnackBar(
              context, "ok", () => {}, "Please Enter a Valid Email");
        } else if (errorCode == "email-already-in-use") {
          CustomSnackBar.showSnackBar(
              context, "ok", () => {}, "User Already Exist");
        } else if (errorCode == 'weak-password') {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "Weak Password");
        } else if (errorCode == 'network-request-failed') {
          CustomSnackBar.showSnackBar(
              context, "Ok", () => null, "Pleace Check Your Internet ");
        }

        // .then((value) async {
        // SharedPreference.saveCredentials(email.text, pass.text)
        //     .then((value) => Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => adiconst home_screen(),
        //         )));
        // });
      } else {
        // context.go('/signup_screen');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => signin_screen(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formkey1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 550,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Stack(
                      children: <Widget>[
                        SvgPicture.asset('assets/images/sign_up.svg'),
                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  themeprovider.toggleTheme();
                                },
                                icon: Icon(
                                  themeprovider.getThemeIcon(),
                                  size: 25,
                                )))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          labelText: "Name",
                          hintText: "Aditya Chauhan",
                          controller: name,
                          sur: Icon(
                            Icons.abc_outlined,
                            size: 35,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name can not be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          labelText: "Email",
                          hintText: "aditya123@gmail.com",
                          controller: email,
                          sur: Icon(
                            Icons.email_outlined,
                            size: 30,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email can not be empty";
                            } else if (!value.contains('@')) {
                              return "Please Enter a Valid Email";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          labelText: "Password",
                          hintText: "Aditya123@2266",
                          controller: pass,
                          obscureText: true,
                          sur: Icon(
                            Icons.password_outlined,
                            size: 30,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can not be empty";
                            } else if (value.length < 6) {
                              return "Password Should Be Greater Then 6 Digits";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          labelText: "Confirm Password",
                          hintText: "Aditya123@2266",
                          controller: cpass,
                          obscureText: true,
                          sur: Icon(
                            Icons.password_outlined,
                            size: 30,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can not be empty";
                            } else if (value.length < 6) {
                              return "Password Should Be Greater Then 6 Digits";
                            } else if (value != pass.text) {
                              return "Password Match Failed";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomElevatedButton(
                          message: "Sign Up",
                          function: movetosignup,
                        ),
                        //  Elevated button
                        // ElevatedButton(
                        //   onPressed: () {
                        //     movetosignup();
                        //   },
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         MaterialStateProperty.all<Color>(Colors.blue),
                        //     shape: MaterialStateProperty.all(
                        //       const RoundedRectangleBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(10)),
                        //       ),
                        //     ),
                        //     padding: MaterialStateProperty.all(
                        //       const EdgeInsets.only(
                        //           left: 140, right: 140, top: 12, bottom: 12),
                        //     ),
                        //     elevation: MaterialStateProperty.all(1),
                        //   ),
                        //   child: const Text(
                        //     "Sign Up",
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Or"),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                            ),
                            const Text("Create a new account ? "),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => signin_screen(),
                                    ));
                              },
                              child: const Text("Sign In"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
