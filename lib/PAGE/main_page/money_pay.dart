import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/bill_provider.dart';
import 'package:pos_noscale_barcode/PAGE/main_page/tabbar_type/prompt_pay.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/product/showdialog_component/add_product.dart';
import 'package:provider/provider.dart';
/*
class money_pay extends StatefulWidget {
  const money_pay({super.key});

  @override
  State<money_pay> createState() => _money_payState();
}

class _money_payState extends State<money_pay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

                bills.update_Qrcode_state(false);
                bills.update_Money_state(true);
                bills.update_pay_money("0.00");
                await _pay_money();
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                color: Colors.black,
                child: Icon(
                  Icons.attach_money_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                prompt_pay(context);
                final bill_provider bills = Provider.of<bill_provider>(context, listen: false);
                bills.update_Qrcode_state(true);
                bills.update_Money_state(false);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                color: Colors.black,
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

Future<void> pay_money(context) async {
  final TextEditingController _textController4 = TextEditingController();
  final bill_provider bills = Provider.of<bill_provider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          height: 200,
          width: 200,
          child: Column(children: [
            TextField(
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

                bills.update_pay_money(double.parse(value).toStringAsFixed(2));
              },
            ),
            Container(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                child: Center(
                  child: Container(
                    width: 160,
                    height: 50,
                    child: Center(
                        child: Text(
                      "ยืนยัน",
                      style: GoogleFonts.sarabun(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.greenAccent),
                  ),
                ),
              ),
            )
          ]),
        ),
      );
    },
  );
}
