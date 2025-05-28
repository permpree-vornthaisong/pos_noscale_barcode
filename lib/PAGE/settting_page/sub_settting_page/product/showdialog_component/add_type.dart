import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/function.dart';
import 'package:pos_noscale_barcode/colour.dart';

class add_type extends StatefulWidget {
  const add_type({super.key});

  @override
  State<add_type> createState() => _add_typeState();
}

class _add_typeState extends State<add_type> {
  final TextEditingController controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 40, 40, 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "เพิ่มชนิดสินค้า",
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            TextField(
              controller: controller1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (controller1.text.isNotEmpty) {
                      add_type_sqlite(context, controller1.text);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Dark_threme.BG,
                    ),
                    child: Center(
                      child: Text(
                        "ยืนยัน",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
