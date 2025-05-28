import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/Scale_provider/main_scale_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:provider/provider.dart';

class scale_main extends StatefulWidget {
  const scale_main({super.key});

  @override
  State<scale_main> createState() => _scale_mainState();
}

class _scale_mainState extends State<scale_main> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ScaleProvider, system_provider>(builder: (context, Scales, systems, child) {
      return systems.get_all()[0].weight_mode
          ? Container(
              height: 90,
              child: Row(children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 120,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Scales.get_stable() ? Colors.greenAccent : Colors.white54),
                  child: Center(
                    child: Text(
                      "Stable",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 255, 255, 255), // Text color
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Scales.TARE(!Scales.get_tare());
                    // print(Scales.get_tare());
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: 120,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Scales.get_tare() ? Colors.greenAccent : Colors.white54),
                    child: Center(
                      child: Text(
                        "Tare",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255), // Text color
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: systems.get_all()[0].format_input == "jhs",
                  child: GestureDetector(
                    onTap: () {
                      Scales.zero_state(true);
                      // print(Scales.get_tare());
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      width: 120,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5), color: Scales.get_zero() ? Colors.greenAccent : Colors.white54),
                      child: Center(
                        child: Text(
                          "Zero",
                          style: GoogleFonts.sarabun(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 255, 255, 255), // Text color
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    Scales.get_data(),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 80,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 255, 255, 255), // Text color
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Text(
                  " kg      ",
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 255, 255, 255), // Text color
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ]),
              color: Colors.black,
            )
          : Container();
    });
  }
}
