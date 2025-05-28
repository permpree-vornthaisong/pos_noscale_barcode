import 'package:flutter/material.dart';

class edit_bill {
  bool head = false;
  bool name = false;
  bool address = false;
  bool phone = false;

  bool tax = false;
  bool sn = false;
  bool id_bill = false;

  bool customer = false;
  bool text1 = false;
  bool text2 = false;

  bool pic = false;
  String form = "1";
  String PICTURE = "";

  String HEADS = "";
  String NAMES = "";
  String ADDRESSS = "";
  String PHONSE = "";

  String TAXS = "";
  String SNS = "";

  String ID_BILLS = "";

  String CUSTOMERS = "";
  String TEXT1S = "";
  String TEXT2S = "";

  edit_bill({
    required this.form,
    required this.PICTURE,
    required this.pic,

    ///////////
    required this.head,
    required this.name,
    required this.address,
    required this.phone,
    required this.tax,
    required this.sn,
    required this.id_bill,
    required this.customer,
    required this.text1,
    required this.text2,

    ///////////////////////////////

    required this.HEADS,
    required this.NAMES,
    required this.ADDRESSS,
    required this.PHONSE,
    required this.TAXS,
    required this.SNS,
    required this.ID_BILLS,
    required this.CUSTOMERS,
    required this.TEXT1S,
    required this.TEXT2S,
  });
}


/*

       _HEADS.text = edit_bills.get_all()[0].HEADS;
          _NAMES.text = edit_bills.get_all()[0].NAMES;
          _ADDRESSS.text = edit_bills.get_all()[0].ADDRESSS;

          _PHONSE.text = edit_bills.get_all()[0].PHONSE;

          _TAXS.text = edit_bills.get_all()[0].TAXS;
          _SNS.text = edit_bills.get_all()[0].SNS;
          _ID_BILLS.text = edit_bills.get_all()[0].ID_BILLS;
          _CUSTOMERS.text = edit_bills.get_all()[0].CUSTOMERS;
          _TEXT1S.text = edit_bills.get_all()[0].TEXT1S;
          _TEXT2S.text = edit_bills.get_all()[0].TEXT2S;


*/