import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_display_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/filter_numname_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/tab_timer_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/display_data/showdialog_search/serach.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:provider/provider.dart';

class key_display extends StatefulWidget {
  const key_display({super.key});

  @override
  State<key_display> createState() => _key_displayState();
}

class _key_displayState extends State<key_display> {
  bool state_bar = true;
  bool state_key = false;

  @override
  Widget build(BuildContext context) {
    final filter_num_name_provider filter_num_names = Provider.of<filter_num_name_provider>(context, listen: false);
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    return Consumer2<data_display_provider, TabTimerProvider>(builder: (context, data_displays, TabTimers, child) {
      return Container(
        child: Row(
          children: [
            Visibility(
              visible: state_bar,
              child: GestureDetector(
                onTap: () {
                  filter_num_names.update_state("num");
                  data_products.info(context);
                  setState(() {
                    state_bar = false;
                    state_key = true;
                  });
                },
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: state_bar ? Colors.amberAccent : Color.fromARGB(255, 255, 255, 255),
                  width: systems.get_all()[0].language == "thai" ? 140 : 180,
                  margin: EdgeInsets.all(5),
                  child: Row(children: [
                    Center(
                      child: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    Center(
                      child: Text(
                        (systems.get_all()[0].language == "thai"
                            ? thai_text().tab_keyboad_type_name + (!TabTimers.getTransactions()[0].state ? " ENG" : " TH")
                            : eng_text().tab_keyboad_type_name + (!TabTimers.getTransactions()[0].state ? " ENG" : " TH")),
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Visibility(
              visible: state_key,
              child: GestureDetector(
                onTap: () {
                  filter_num_names.update_state("name");
                  data_products.info(context);
                  setState(() {
                    state_bar = true;
                    state_key = false;
                  });
                },
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: state_key ? Colors.amberAccent : Color.fromARGB(255, 255, 255, 255),
                  width: 120,
                  margin: EdgeInsets.all(5),
                  child: Row(children: [
                    Center(
                      child: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    Center(
                      child: Text(
                        systems.get_all()[0].language == "thai" ? thai_text().tab_keyboad_type_num : eng_text().tab_keyboad_type_num,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SearchData(),
                      );
                    },
                  );
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                      child: Text(
                    " " + data_displays.get_all()[0].name,
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  )),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    data_displays.get_all()[0].price +
                        " " +
                        (systems.get_all()[0].language == "thai" ? thai_text().tab_unit_monney + " " : eng_text().tab_unit_monney + " "),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  )),
            ),
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