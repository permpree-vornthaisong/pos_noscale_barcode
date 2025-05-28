import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/cashier_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:provider/provider.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  bool staff = true;
  bool admin = false;
  @override
  Widget build(BuildContext context) {
    final cashiers = Provider.of<cashier_provider>(context, listen: false);
    final systems = Provider.of<system_provider>(context, listen: false);
    //bool staff = true;
    // bool admin = false;

    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Row(children: [
                Text(
                  "เพิ่มพนักงาน",
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
            Visibility(
              visible: systems.get_all()[0].role == "admin" || systems.get_all()[0].role == "master",
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    'STAFF',
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: staff,
                      onChanged: (bool? value) {
                        setState(() {
                          staff = true;
                          admin = false;
                        });
                      },
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                ],
              ),
            ),
            Visibility(
              visible: systems.get_all()[0].role == "master",
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    'ADMIN',
                    style: GoogleFonts.sarabun(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: admin,
                      onChanged: (bool? value) {
                        setState(() {
                          staff = false;
                          admin = true;
                        });
                      },
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 120,
                          child: Text(
                            "รหัสพนักงาน",
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
                      ]),
                      Row(children: [
                        Container(
                          width: 120,
                          child: Text(
                            "ชื่อ",
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
                            controller: _controller2,
                            decoration: const InputDecoration(
                              labelText: '',
                            ),
                          ),
                        ),
                      ]),
                      /*   TextField(
                        controller: _controller3,
                        decoration: const InputDecoration(
                          labelText: '',
                        ),
                      ),*/
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty) {
                            cashiers.add_staff(
                              context,
                              _controller1.text,
                              _controller2.text,
                              staff ? "staff" : (admin ? "admin" : ""),
                            );
                            setState(() {
                              _controller1.text = "";
                              _controller2.text = "";
                            });
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
                            'Submit',
                            style: GoogleFonts.sarabun(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontStyle: FontStyle.normal,
                            ),
                          )),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
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
