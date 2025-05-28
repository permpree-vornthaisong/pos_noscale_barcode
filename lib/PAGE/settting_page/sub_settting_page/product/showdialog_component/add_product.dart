import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/type_data_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/drop_down_type.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/function.dart';
import 'package:pos_noscale_barcode/colour.dart';
import 'package:provider/provider.dart';

class ADD extends StatefulWidget {
  const ADD({Key? key}) : super(key: key);

  @override
  State<ADD> createState() => _ADDState();
}

class _ADDState extends State<ADD> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();
  final TextEditingController controller6 = TextEditingController();
  bool state = true;
  bool checkBoxValue1 = true;
  bool checkBoxValue2 = false;
  bool checkBoxValue3 = false;

  @override
  Widget build(BuildContext context) {
    /*   final type_datas = Provider.of<type_data_provider>(context, listen: false);
    type_datas.info_select("");
    type_datas.update_type_select(type_datas.get_all()[0].type);*/
    return SingleChildScrollView(
      child: Stack(children: [
        Container(
          width: 600,
          height: 500,
          color: Color.fromARGB(255, 223, 223, 223),
          child: Row(children: [
            Container(width: 30),
            Container(
              // width: 450,
              height: 480,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextField(controller1, "รหัสสินค้า"),
                  buildTextField(controller2, "ชื่อสินค้า"),
                  buildTextField(controller3, "ราคา"),
                  buildTextField(controller4, "อื่นๆ"),
                  type_select("ชนิด"),
                ],
              ),
            ),
            /* Container(
              margin: EdgeInsets.all(5),
              child: Visibility(
                visible: state,
                child: Column(children: [
                  Container(
                    height: 60,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(
                      "เลือกชนิด",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Container(width: 150, height: 300, child: bartype()),
                  Container(
                    height: 70,
                  ),
                ]),
              ),
            ),*/
            Column(children: [
              Container(
                height: 100,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(211, 56, 97, 131),
                ),
                width: 70,
                height: 300,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      child: Text(
                        "KG",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Adjust the spacing between text and checkboxes
                    Transform.scale(
                      scale: 2.2,
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Checkbox(
                            value: checkBoxValue1,
                            onChanged: (bool? value) {
                              setState(() {
                                checkBoxValue1 = value!;
                                checkBoxValue2 = false;
                                checkBoxValue3 = false;
                              });
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.amber,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Adjust the spacing between checkboxes and text
                    Container(
                      child: Text(
                        "p",
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Adjust the spacing between text and checkboxes
                    Transform.scale(
                      scale: 2.2,
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Checkbox(
                            value: checkBoxValue2,
                            onChanged: (bool? value2) {
                              setState(() {
                                checkBoxValue2 = value2!;
                                checkBoxValue1 = false;
                                checkBoxValue3 = false;
                              });
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.amber,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Adjust the spacing between text and checkboxes

                    Expanded(child: Container()),
                  ],
                ),
              ),
              Container(
                height: 70,
              ),
            ])
          ]),
        ),
        Positioned(
          left: 30,
          top: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Container(
                  margin: EdgeInsets.all(0.5),
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.amber,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            right: 30,
            top: 20,
            child: InkWell(
              onTap: () async {
                final type_datass = Provider.of<type_data_provider>(context, listen: false);

                try {
                  if (controller1.text.isNotEmpty &&
                      controller2.text.isNotEmpty &&
                      controller3.text.isNotEmpty &&
                      // controller4.text.isNotEmpty &&
                      type_datass.get_type_scelect().isNotEmpty) {
                    await add_product_sqlite(context, controller1.text, controller2.text, controller3.text, controller4.text,
                        type_datass.get_type_scelect(), checkBoxValue1, checkBoxValue2);
                    type_datass.update_type_select("");
                    type_datass.info_select("");
                    type_datass.update_type_select(type_datass.get_all()[0].type);

                    Navigator.pop(context);
                  }

                  // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black,
                ),
                child: Container(
                  margin: EdgeInsets.all(0.5),
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.amber,
                  ),
                  child: Center(
                    child: Text(
                      "ยืนยัน",
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
              ),
            )),
        Container(
          height: 80,
          width: 600,
          // color: Colors.black,
          child: Center(
            child: Text(
              "เพิ่มสินค้า",
              style: GoogleFonts.sarabun(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 0, 0, 0),
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget buildTextField(TextEditingController controller, String data) {
    return Container(
      //  width: 620,
      child: Row(children: [
        Container(
          child: Text(
            data,
            style: GoogleFonts.sarabun(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 0, 0, 0),
              fontStyle: FontStyle.normal,
            ),
          ),
          width: 120,
        ),
        Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(0.1),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: data == "รหัสสินค้า" || data == "ราคา" ? TextInputType.number : null, // Numeric keyboard
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget type_select(String data) {
    final type_datas = Provider.of<type_data_provider>(context, listen: false);
    // type_datas.info_select("");
    String selectedType = ""; //type_datas.get_all()[0].type;

    return Row(children: [
      Container(
        child: Text(
          "เลือกชนิด",
          style: GoogleFonts.sarabun(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 0, 0, 0),
            fontStyle: FontStyle.normal,
          ),
        ),
        width: 120,
      ),
      Container(
        color: Color.fromARGB(255, 43, 19, 19),
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        width: 300,
        //  width: 600,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.all(0.8),
          child: Consumer<type_data_provider>(builder: (context, type_datas, child) {
            List<String> types = type_datas.get_all().map((item) => item.type).toList();
            types.add('');
            if (type_datas.get_type_scelect().isEmpty) {
              selectedType = ""; //type_datas.get_all().isEmpty ? "" : type_datas.get_all()[0].type
            } else {
              selectedType = type_datas.get_type_scelect();
            }
            return DropdownButton<String>(
              value: selectedType,

              ///   hint: Text('----'),
              onChanged: (String? newValue) {
                type_datas.update_type_select(newValue!);
              },
              items: types.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    "  " + value,
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ),
    ]);
  }

  Widget bartype() {
    final type_datas = Provider.of<type_data_provider>(context, listen: false);
    return Container(
      width: 100,
      height: 50,
      child: Consumer<type_data_provider>(builder: (context, type_datas, child) {
        if (type_datas.DATA_Select().isNotEmpty) {
          return Container(
            alignment: AlignmentDirectional.center,
            child: Container(
              child: ListView.builder(
                //  scrollDirection: Axis.horizontal,
                itemCount: type_datas.get_all().length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller6.text = type_datas.DATA_Select()[index].type;
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Dark_threme.BG_shadow,
                      ),
                      child: Center(
                          child: Text(
                        type_datas.DATA_Select()[index].type,
                        style: GoogleFonts.sarabun(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                        ),
                      )),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.all(5),
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Dark_threme.BG_shadow,
            ),
            child: Center(
                child: Text(
              "ไม่มีชนิดสินค้านี้",
              style: GoogleFonts.sarabun(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255),
                fontStyle: FontStyle.normal,
              ),
            )),
          );
        }
      }),
    );
  }
}


/*



  Widget type_select(TextEditingController controller, String data) {
    final type_datas = Provider.of<type_data_provider>(context, listen: false);
    // type_datas.info_select("");
    return Container(
      width: 600,
      child: Row(children: [
        Container(
          child: Text(
            data,
            style: GoogleFonts.sarabun(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 25,
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 0, 0, 0),
              fontStyle: FontStyle.normal,
            ),
          ),
          width: 120,
        ),
        Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          width: 150,
          child: Padding(
            padding: const EdgeInsets.all(0.1),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  onChanged: (value) {
                    type_datas.info_select(value);
                  },
                  controller: controller,
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer<type_data_provider>(builder: (context, type_datas, child) {
          if (type_datas.DATA_Select().isNotEmpty) {
            return Container(
              alignment: AlignmentDirectional.center,
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    state = !state;
                  });
                },
                child: Container(
                  child: Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Dark_threme.BG_shadow,
                    ),
                    child: Center(
                        child: Text(
                      "ชนิด",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(5),
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Dark_threme.BG_shadow,
              ),
              child: Center(
                  child: Text(
                "ไม่มีชนิดสินค้านี้",
                style: GoogleFonts.sarabun(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontStyle: FontStyle.normal,
                ),
              )),
            );
          }
        }),
      ]),
    );
  }
*/