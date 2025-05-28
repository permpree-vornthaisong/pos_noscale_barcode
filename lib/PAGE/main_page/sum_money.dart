import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class sum_mone extends StatefulWidget {
  const sum_mone({super.key});

  @override
  State<sum_mone> createState() => _sum_moneyState();
}

class _sum_moneyState extends State<sum_mone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
              child: Text(
            "  รายการทั้งหมด",
            style: GoogleFonts.sarabun(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontStyle: FontStyle.normal,
            ),
          )),
          Expanded(
              child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    "2000.00" + "  ฿ ",
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontStyle: FontStyle.normal,
                    ),
                  )))
        ],
      ),
    );
  }
}
