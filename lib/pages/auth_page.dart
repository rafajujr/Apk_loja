import 'package:flutter/material.dart';
import 'package:shop/components/auht_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(159, 29, 6, 238),
            Color.fromARGB(169, 243, 0, 0),
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        ),
        Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    //cascade operation
                    transform: Matrix4.rotationZ(-0.123)..translate(-12.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(
                              0,
                              2,
                            ),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(237, 250, 123, 5)),
                    child: const Text(
                      'Loja Ben Toys',
                      style: TextStyle(
                          fontSize: 45,
                          fontFamily: 'Anton',
                          color: Color.fromARGB(255, 255, 255, 255),
                          shadows: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Color.fromARGB(80, 0, 0, 0),
                                offset: Offset(
                                  0,
                                  2,
                                ))
                          ]),
                    ),
                  ),
                  const AuhtForm(),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
