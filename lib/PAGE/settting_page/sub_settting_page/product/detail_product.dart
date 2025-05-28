import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:provider/provider.dart';

class detail_product extends StatefulWidget {
  const detail_product({super.key});

  @override
  State<detail_product> createState() => _detail_productState();
}

class _detail_productState extends State<detail_product> {
  @override
  Widget build(BuildContext context) {
    final systems = Provider.of<system_provider>(context, listen: false);

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(2),
                height: 50,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().product_id : eng_text().product_id),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(2),
                height: 50,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().product_name : eng_text().product_name),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(2),
                height: 50,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().product_price : eng_text().product_price),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(2),
                height: 50,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().product_unit : eng_text().product_unit),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(2),
                height: 50,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().product_type : eng_text().product_type),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(2),
                height: 50,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Text(
                    (systems.get_all()[0].language == "thai" ? thai_text().product_other : eng_text().product_other),
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )),
            ],
          ),
          Expanded(child: Container(child: Consumer<data_product_provider>(builder: (context, datas, child) {
            print("haha");
            return Container(
                alignment: AlignmentDirectional.center,
                child: ListView.builder(
                    itemCount: datas.get_all_setting().length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          _delect_index(context, index);
                        },
                        onTap: () {
                          _chance_price(context, index);
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(2),
                                height: 50,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Center(
                                  child: Text(
                                    datas.get_all_setting()[index].id,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(2),
                                height: 50,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Center(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      datas.get_all_setting()[index].name,
                                      style: GoogleFonts.sarabun(
                                        textStyle: Theme.of(context).textTheme.displayLarge,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(2),
                                height: 50,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Center(
                                  child: Text(
                                    datas.get_all_setting()[index].price,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(2),
                                height: 50,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Center(
                                  child: Text(
                                    datas.get_all_setting()[index].unit,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(2),
                                height: 50,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Center(
                                  child: Text(
                                    datas.get_all_setting()[index].type,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(2),
                                height: 50,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Center(
                                  child: Text(
                                    datas.get_all_setting()[index].other,
                                    style: GoogleFonts.sarabun(
                                      textStyle: Theme.of(context).textTheme.displayLarge,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      );
                    }));
          })))
        ],
      ),
    );
  }

  void _delect_index(context, int index) {
    final data_products = Provider.of<data_product_provider>(context, listen: false);
    final type_datas = Provider.of<type_data_provider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 200,
            height: 200,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  child: Center(
                    child: Text(
                      "ลบสินค้านี้",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          await data_products.delect_index(context, index);
                          await data_products.reset_data(context);

                          await data_products.info(context);
                          await data_products.info_setting(context);
                          await type_datas.info(context);

                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Container(
                                color: Colors.amber,
                                width: 140,
                                height: 80,
                                child: Center(
                                    child: Text(
                                  " ยืนยัน ",
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )))))),
              ],
            ),
          ),
        );
      },
    );
  }

  void _chance_price(context, int index) {
    final data_products = Provider.of<data_product_provider>(context, listen: false);
    final TextEditingController _textController4 = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 200,
            height: 200,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                    child: TextField(
                      controller: _textController4,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "ใส่จำนวนเงิน",
                      ),
                      onChanged: (value) {
                        // อัพเดทข้อความที่ผู้ใช้พิมแล้วเพื่อให้ hint หายไป
                      },
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          await data_products.change_price(context, (data_products.get_all_setting()[index].id), _textController4.text);
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Container(
                                color: Colors.amber,
                                width: 140,
                                height: 80,
                                child: Center(
                                    child: Text(
                                  " ยืนยัน ",
                                  style: GoogleFonts.sarabun(
                                    textStyle: Theme.of(context).textTheme.displayLarge,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontStyle: FontStyle.normal,
                                  ),
                                )))))),
              ],
            ),
          ),
        );
      },
    );
  }
}
