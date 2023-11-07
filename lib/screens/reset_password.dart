import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/widgets/custom_widgets.dart';

class reset_password_screen extends StatefulWidget {
  const reset_password_screen({super.key});

  @override
  State<reset_password_screen> createState() => _reset_password_screenState();
}

class _reset_password_screenState extends State<reset_password_screen> {
 
  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
          // height: MediaQuery.of(context).size.height - 150,
          // width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Ensure vertical centering
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            themeprovider.toggleTheme();
                          },
                          icon: Icon(
                            themeprovider.getThemeIcon(),
                            size: 25,
                          ))),
                  SvgPicture.asset('assets/images/sign_in.svg'),
                 const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Check Your mail !!",
                    style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    message: "Back To Sign In",
                    function: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => signin_screen(),
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
