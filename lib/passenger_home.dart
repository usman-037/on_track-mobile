import 'package:flutter/material.dart';

class PassengerHome extends StatelessWidget {
  const PassengerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['userName'];
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 202,
                  decoration: const BoxDecoration(color: Color(0xFF2BB45A)),
                ),
              ),
              Positioned(
                left: 28,
                top: 58,
                child: Container(
                  width: 87,
                  height: 87,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFAF2F2),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 126,
                top: 30,
                child: Container(
                  width: 226,
                  height: 143,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0x009747FF)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 20,
                        child: SizedBox(
                          width: 186,
                          height: 69,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: SizedBox(
                                  width: 186,
                                  height: 69,
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Dela Gothic One',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                    child: Text(
                                      '$userName',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 20,
                        top: 109,
                        child: SizedBox(
                          width: 186,
                          height: 34,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: SizedBox(
                                  width: 186,
                                  height: 16.75,
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Dela Gothic One',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                    child: Text(
                                      'Route Number Here',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 1.75,
                top: 286,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button click here
                    //Navigator.pushReplacementNamed(context, '/registerbusroute');
                    Navigator.pushNamed(context, '/generateqrcode',
                        arguments: {'userName': userName, 'femail': femail});
                  },
                  child: Container(
                    width: 119,
                    height: 119,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEDEDED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/icons/qrcode.png'), // Replace with your image path
                          width:
                              50, // Adjust the width according to your preference
                          height:
                              50, // Adjust the height according to your preference
                        ),
                        const Positioned(
                          left: 23,
                          top: 73,
                          child: SizedBox(
                            width: 96,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                              child: Text(
                                'Get \nQR Code',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 1.75,
                top: 434,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 119,
                    height: 119,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEDEDED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/icons/routechange.png'), // Replace with your image path
                          width:
                              50, // Adjust the width according to your preference
                          height:
                              50, // Adjust the height according to your preference
                        ),
                        const Positioned(
                          left: 23,
                          top: 73,
                          child: SizedBox(
                            width: 96,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                              child: Text(
                                'Request\nRoute Change',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 37,
                          top: 14,
                          child: Container(
                            width: 46,
                            height: 46,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 1.75,
                top: 286,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button click here
                    Navigator.pushNamed(context, '/registerbusroute');
                  },
                  child: Container(
                    width: 119,
                    height: 119,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEDEDED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/icons/bus.png'), // Replace with your image path
                          width:
                              50, // Adjust the width according to your preference
                          height:
                              50, // Adjust the height according to your preference
                        ),
                        const Positioned(
                          left: 12,
                          top: 67,
                          child: SizedBox(
                            width: 96,
                            height: 39,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                              child: Text(
                                'Register\nBus Route',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 36,
                          top: 25,
                          child: Container(
                            width: 47,
                            height: 34,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 1.83,
                                  top: 1.83,
                                  child: Container(
                                    width: 43.33,
                                    height: 30.33,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 1.75,
                top: 434,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button click here
                    //Navigator.pushReplacementNamed(context, '/registerbusroute');
                  },
                  child: Container(
                    width: 119,
                    height: 119,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEDEDED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/icons/search.png'), // Replace with your image path
                          width:
                              50, // Adjust the width according to your preference
                          height:
                              50, // Adjust the height according to your preference
                        ),
                        Positioned(
                            left: 5,
                            top: 66,
                            child: SizedBox(
                              width: 109,
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Color(0xFF1E1E1E),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                child: Text(
                                  'Access Lost &\nFound Portal',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                        Positioned(
                          left: 41,
                          top: 17,
                          child: Container(
                            width: 37,
                            height: 37,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 1.75,
                top: 582,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button click here
                    //Navigator.pushReplacementNamed(context, '/registerbusroute');
                  },
                  child: Container(
                    width: 119,
                    height: 119,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEDEDED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/icons/edit.png'), // Replace with your image path
                          width:
                              50, // Adjust the width according to your preference
                          height:
                              50, // Adjust the height according to your preference
                        ),
                        Positioned(
                          left: 12,
                          top: 66,
                          child: SizedBox(
                            width: 96,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                              child: Text(
                                'Edit\nProfile',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 38,
                          top: 16,
                          child: Container(
                            width: 44,
                            height: 44,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 1.75,
                top: 582,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button click here
                    //Navigator.pushReplacementNamed(context, '/registerbusroute');
                  },
                  child: Container(
                    width: 119,
                    height: 119,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEDEDED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/icons/message.png'), // Replace with your image path
                          width:
                              50, // Adjust the width according to your preference
                          height:
                              50, // Adjust the height according to your preference
                        ),
                        Positioned(
                          left: 5,
                          top: 75,
                          child: SizedBox(
                            width: 109,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                              child: Text(
                                'Report Issue',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 36,
                          top: 12,
                          child: Container(
                            width: 48,
                            height: 48,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 105,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: const Color(0xFF18582E),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                  child: Text(
                    'On Track',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                left: 48,
                top: 68,
                child: Container(
                  width: 48,
                  height: 48,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 4.5,
                top: 227,
                child: Container(
                  width: 217,
                  height: 31,
                  child: const Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 217,
                          height: 31,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Color(0xFF2BB45A),
                              fontSize: 20,
                              fontFamily: 'Dela Gothic One',
                              fontWeight: FontWeight.bold,
                              height: 0,
                            ),
                            child: Text(
                              'Home',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
