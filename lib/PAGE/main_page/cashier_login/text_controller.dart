import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TEXT_LOGIN extends StatefulWidget {
  const TEXT_LOGIN({super.key});

  @override
  State<TEXT_LOGIN> createState() => _TEXT_LOGINState();
}

class _TEXT_LOGINState extends State<TEXT_LOGIN> {
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode2,
      controller: controller1,
      keyboardType: TextInputType.number,
      style: GoogleFonts.sarabun(
        textStyle: Theme.of(context).textTheme.displayLarge,
        fontSize: 30,
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(255, 0, 0, 0),
        fontStyle: FontStyle.normal,
      ),
      decoration: InputDecoration(
        hintStyle: GoogleFonts.sarabun(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontSize: 30,
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 0, 0, 0),
          fontStyle: FontStyle.normal,
        ),
      ),
      onSubmitted: (_) {
        setState(() {
          /*  _focusNode.requestFocus();
                            _focusNode2.unfocus();*/
        });

        // _focusNode.requestFocus();
/*
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Container();
                            },
                          );*/
      },
      onChanged: (value) {
        /*  setState(() {
                            controller1.text = controller1.text + value;
                            TEXT_TYPEs = "";
                          });*/

        // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
      },
    );
  }
}
