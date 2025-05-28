import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';
import 'package:provider/provider.dart';

void prompt_pay(context, double T_sum_money) {
  final system_provider systems = Provider.of<system_provider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Color.fromARGB(0, 110, 111, 112), // กำหนดสีพื้นหลังเป็นสีน้ำเงิน

          content: Container(
            height: 500,
            width: 500,
            color: Colors.white,
            child: Center(
              child: QRCodeGenerate(
                promptPayId: systems.get_all()[0].number_prompt_pay,
                amount: T_sum_money,
                height: 500,
                width: 500,
              ),
            ),
          ));
    },
  );
}
