import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:provider/provider.dart';

class delect_staff extends StatefulWidget {
  const delect_staff({super.key});

  @override
  State<delect_staff> createState() => _delect_staffState();
}

class _delect_staffState extends State<delect_staff> {
  final TextEditingController _controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cashiers = Provider.of<cashier_provider>(context, listen: false);
    final systems = Provider.of<system_provider>(context, listen: false);

    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      height: 200,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 60, 20),
        child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 60, 0),
            child: Row(children: [
              Text(
                "ลบพนักงาน",
                style: GoogleFonts.sarabun(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.normal,
                ),
              ),
            ]),
          ),
          Row(
            children: [
              Container(
                width: 120,
                child: Text(
                  "รหัส",
                  style: GoogleFonts.sarabun(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller1,
                  decoration: const InputDecoration(
                    labelText: '',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                  child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_controller1.text.isNotEmpty) {
                      List<String> DATA = cashiers.findNameById(_controller1.text);
                      if (DATA[1] == "false") {
                        _showSnackbar("ไม่เจอรหัสพนักงาน");

                        setState(() {
                          _controller1.text = "";
                        });
                      } else {
                        if (systems.get_all()[0].role == "master") {
                          // master case  return
                          if (DATA[2] == "master") {
                            _showSnackbar("ลบไม่สำเสร็จ master ลบ master ไม่ได้");
                            setState(() {
                              _controller1.text = "";
                            });
                            // ลบไม่ได้ sdf
                          } else if (DATA[2] == "admin") {
                            cashiers.delect_by_id(context, DATA[2]);
                            _showSnackbar("ลบ ${DATA[2] + " " + DATA[0] + " " + DATA[1]} สำเสร็จ");
                            setState(() {
                              _controller1.text = "";
                            });

                            // ลบได้
                          } else if (DATA[2] == "staff") {
                            _showSnackbar("ลบ ${DATA[2] + " " + DATA[0] + " " + DATA[1]} สำเสร็จ");
                            setState(() {
                              _controller1.text = "";
                            });
                            // ลบได้
                          }
                        } else if (systems.get_all()[0].role == "admin") {
                          // admin case  return

                          if (DATA[2] == "master") {
                            _showSnackbar("ลบไม่สำเสร็จ admin ลบ master ไม่ได้");
                            setState(() {
                              _controller1.text = "";
                            });
                          } else if (DATA[2] == "admin") {
                            _showSnackbar("ลบไม่สำเสร็จ admin ลบ admin ไม่ได้");
                            setState(() {
                              _controller1.text = "";
                            });
                            // ลบไม่ได้
                          } else if (DATA[2] == "staff") {
                            _showSnackbar("ลบ ${DATA[2] + " " + DATA[0] + " " + DATA[1]} สำเสร็จ");
                            setState(() {
                              _controller1.text = "";
                            });
                          }
                        } else {
                          // staff case none return
                        }
                      }
                    } else {
                      _showSnackbar("กรุณากรอก ข้อมูล");
                    }
                  },
                  child: Container(
                    height: 100,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 19, 56, 87),
                    ),
                    child: Center(
                        child: Text(
                      'delect',
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                  ),
                ),
              ))
            ],
          ),
        ]),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
