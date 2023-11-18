import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class home_shimmer extends StatelessWidget {
  const home_shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(.25),
          highlightColor: Colors.grey.withOpacity(.6),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      maxRadius: 30,
                      minRadius: 30,
                      backgroundColor: Colors.grey.withOpacity(.9),
                    ),
                    Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.9),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    CircleAvatar(
                      maxRadius: 30,
                      minRadius: 30,
                      backgroundColor: Colors.grey.withOpacity(.9),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      width: 160,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.9),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Container(
                      height: 50,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.9),
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.9),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.9),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.9),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.9),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 500,
                  width: 700,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.9),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 110,
                            width: 650,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.9),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black, width: 2)
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                           Container(
                            height: 110,
                            width: 650,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.9),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black, width: 2)
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                           Container(
                            height: 110,
                            width: 650,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.9),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black, width: 2)
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                           Container(
                            height: 110,
                            width: 650,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.9),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black, width: 2)
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    ));
  }
}
