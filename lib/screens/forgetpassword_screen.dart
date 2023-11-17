import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/screens/reset_password.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/screens/signup_screen.dart';
import 'package:todo/utilities/user_data.dart';
// import 'package:todo/screens/otp_screen.dart';
import 'package:todo/widgets/custom_widgets.dart';

class forgetpassword_screen extends StatefulWidget {
  const forgetpassword_screen({super.key});

  @override
  State<forgetpassword_screen> createState() => _forgetpassword_screenState();
}

class _forgetpassword_screenState extends State<forgetpassword_screen> {
  TextEditingController email = TextEditingController();
  final _formkey = GlobalKey<FormState>();



  Future<void> sendotp() async {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      var result = await UserData.resetPassword(email: email.text.trim());
      print(result);
      if (result == true) {
        print('send link !');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => reset_password_screen(),
            ));
        // context.go('/reset_password_screen');
      } else if (result is String) {
        String errorCode = result;
        print("----------------------------" + errorCode);

        if (errorCode == "invalid-email") {
          CustomSnackBar.showSnackBar(
              context, "Ok", () => null, "Invalid Email");
        } else if (errorCode == "too-many-requests") {
          CustomSnackBar.showSnackBar(
              context, "Ok", () => null, "Something Went Wrong");
        } else if (errorCode == "network-request-failed") {
          CustomSnackBar.showSnackBar(
              context, "Ok", () => null, "Pleace Check Your Internet ");
        } else if (errorCode == "user-not-found") {
          CustomSnackBar.showSnackBar(context, "Create", () {
            return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => signup_screen(),
              ));
            // return context.go('/signup_screen');
          }, "Account Not Found ");
        } else {
          CustomSnackBar.showSnackBar(
            context,
            "Email Not Found ",
            () {
              return Navigator.push(
              context,
                MaterialPageRoute(
                  builder: (context) => signin_screen(),
                ),
              );
              // context.go('/signin_screen');
            },
            "Create an Account",
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 490,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: <Widget>[
                      SvgPicture.asset('assets/images/reset_password.svg'),
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                themeprovider.toggleTheme();
                              },
                              icon:
                                  // ? Icon(
                                  //     Icons.dark_mode_outlined,
                                  //     size: 30,
                                  //   )
                                  // :
                                  Icon(
                                themeprovider.getThemeIcon(),
                                size: 25,
                              )))
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      autofocus: true,
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
                      height: 10,
                    ),
                    CustomElevatedButton(
                      function: sendotp,
                      message: "Send Link",
                      // function: (p0) {
                      //    Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => OtpForm(),
                      //             ));
                      // },
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
