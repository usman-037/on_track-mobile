import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/guardianSignUp.dart';
import 'package:ontrack/hosteliteSignUp.dart';
import 'package:ontrack/signup.dart';

class ChooseAccount extends StatefulWidget {
  const ChooseAccount({super.key});

  @override
  State<ChooseAccount> createState() => _ChooseAccountState();
}

class _ChooseAccountState extends State<ChooseAccount> {
  List<String> role = ['Student/Faculty', 'Hostelite', 'Guardian'];
  List<int> routes = [];
  List<String> stops = [];
  String? selectedRole;
  int? selectedRoute;
  String? selectedStop;
  late String code;
  var fnameController = new TextEditingController();
  var femailController = new TextEditingController();
  var fpasswordController = new TextEditingController();
  var retypepasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: Stack(
          children: [
            Positioned(
              top: -50,
              left: -35,
              right: -50,
              child: Container(
                alignment: Alignment.topCenter,
                height: 253,
                width: 452,
                decoration: ShapeDecoration(
                  color: Color(0xFF03314B),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 6.8,
              top: MediaQuery.of(context).size.height / 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGradientText(
                      'ON', [Color(0xFFB0C5D0), Colors.blueGrey]),
                  _buildGradientText(
                      'TRACK', [Color(0xFFA9EAFF), Color(0xFF08C4FF)]),
                ],
              ),
            ),
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Select Role",
                        fillColor: const Color(0xFFE3E2E2),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: role
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (item) => setState(() => selectedRole = item),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedRole == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please fill in all the fields')),
                          );
                        } else if(selectedRole=="Hostelite"){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) {
                                return HosteliteSignUp();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(
                                    begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation =
                                animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                        else if(selectedRole=="Guardian"){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) {
                                return GuardianSignUp();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(
                                    begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation =
                                animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                        else if(selectedRole=="Student/Faculty"){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) {
                                return Mysignup();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(
                                    begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation =
                                animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Color(0xFF03314B),
                        padding: EdgeInsets.all(13.0),
                      ),
                      child: Text(
                        'NEXT',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGradientText(String text, List<Color> colors) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 50,
          fontFamily: 'FasterOne',
          color: Colors.white,
        ),
      ),
    );
  }
}
