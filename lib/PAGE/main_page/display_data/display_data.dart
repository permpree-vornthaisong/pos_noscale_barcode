import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_display_provider.dart';
import 'package:provider/provider.dart';

class display_data extends StatefulWidget {
  const display_data({super.key});

  @override
  State<display_data> createState() => _display_dataState();
}

class _display_dataState extends State<display_data> {
  @override
  Widget build(BuildContext context) {
    return Consumer<data_display_provider>(builder: (context, data_displays, child) {
      return Container(
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Container(
                    child: Text(
                  " " + data_displays.get_all()[0].name,
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                )),
              ),
            )),
            Expanded(
                child: Container(
              alignment: AlignmentDirectional.centerEnd,
              //color: Colors.black45,
              margin: EdgeInsets.all(2),
              child: Container(
                  child: Text(
                data_displays.get_all()[0].price + " ฿ ",
                style: GoogleFonts.sarabun(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.normal,
                ),
              )),
            ))
          ],
        ),
      );
    });
  }
}


/*

Consumer<threme_state_provider>(builder: (context, threme_states, child) {
              return Container(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    
                  ));
            }),

*/



/*
  Container(
      child: Row(
        children: [
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.all(5),
              child: Container(
                  child: Text(
                " M150",
                style: GoogleFonts.sarabun(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontStyle: FontStyle.normal,
                ),
              )),
            ),
          )),
          Expanded(
              child: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.black45,
            margin: EdgeInsets.all(5),
            child: Container(
                child: Text(
              " 20.00 ฿",
              style: GoogleFonts.sarabun(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 60,
                fontWeight: FontWeight.w300,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontStyle: FontStyle.normal,
              ),
            )),
          ))
        ],
      ),
    );



*/