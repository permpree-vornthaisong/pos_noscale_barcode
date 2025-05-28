import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_MODEL/edit_bill.dart';
import 'package:pos_noscale_barcode/A_MODEL/threme_state.dart';
import 'package:pos_noscale_barcode/A_SQLITE/sqlite.dart';
import 'package:provider/provider.dart';

class edit_bill_provider with ChangeNotifier {
  List<edit_bill> edit_bills = [
    edit_bill(
        form: "0",
        PICTURE: //data:image/jpeg;base64,
            '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',
        pic: true,
        head: true, //
        name: true, //
        address: true, //
        phone: true, //
        tax: true, //
        sn: true, //
        id_bill: true, //
        customer: true, //*
        text1: true, //
        text2: true, //
        HEADS: "HEADS",
        NAMES: "NAMES",
        ADDRESSS: "ADDRESSS1//ADDRESSS2//ADDRESSS3//ADDRESSS4",
        PHONSE: "PHONSE",
        TAXS: "TAXS",
        SNS: "SNS",
        ID_BILLS: "ID_BILLS",
        CUSTOMERS: "CUSTOMERS",
        TEXT1S: "TEXT1S",
        TEXT2S: "TEXT2S")
  ];

  List<edit_bill> get_all() {
    return edit_bills;
  }

  void add_data(edit_bill data) {
    edit_bills.add(data);
    notifyListeners();
  }

  void update_state_form(String data) {
    edit_bills[0].form = data;
    notifyListeners();
  }

  /*
          head: true,
        name: true,
        address: true,
        phone: true,
        tax: true,
        sn: true,
        id_bill: true,
        customer: true,
        text1: true,
        text2: true,
  
  */
  void update_state_pic(bool data) {
    edit_bills[0].pic = data;
    notifyListeners();
  }

  void update_state_head(bool data) {
    edit_bills[0].head = data;
    notifyListeners();
  }

  void update_state_name(bool data) {
    edit_bills[0].name = data;
    notifyListeners();
  }

  void update_state_address(bool data) {
    edit_bills[0].address = data;
    notifyListeners();
  }

  void update_state_phone(bool data) {
    edit_bills[0].phone = data;
    notifyListeners();
  }

  void update_state_tax(bool data) {
    edit_bills[0].tax = data;
    notifyListeners();
  }

  void update_state_sn(bool data) {
    edit_bills[0].sn = data;
    notifyListeners();
  }

  void update_state_id_bill(bool data) {
    edit_bills[0].id_bill = data;
    notifyListeners();
  }

  void update_state_customer(bool data) {
    edit_bills[0].customer = data;
    notifyListeners();
  }

  void update_state_text1(bool data) {
    edit_bills[0].text1 = data;
    notifyListeners();
  }

  void update_state_text2(bool data) {
    edit_bills[0].text2 = data;
    notifyListeners();
  }

/*
     HEADS: "HEADS",
        NAMES: "NAMES",
        ADDRESS: "ADDRESS",
        PHONSE: "PHONSE",
        TAXS: "TAXS",
        SNS: "SNS",
        ID_BILLS: "ID_BILLS",
        CUSTOMERS: "CUSTOMERS",
        TEXT1S: "TEXT1S",
        TEXT2S: "TEXT2S"
*/

  void update_state_PICTURE(String data) {
    edit_bills[0].PICTURE = data;
    notifyListeners();
  }

  void update_state_HEAD(String data) {
    edit_bills[0].HEADS = data;
    notifyListeners();
  }

  void update_state_NAME(String data) {
    edit_bills[0].NAMES = data;
    notifyListeners();
  }

  void update_state_ADDRESSS(String data) {
    edit_bills[0].ADDRESSS = data;
    notifyListeners();
  }

  void update_state_PHONSE(String data) {
    edit_bills[0].PHONSE = data;
    notifyListeners();
  }

  void update_state_TAX(String data) {
    edit_bills[0].TAXS = data;
    notifyListeners();
  }

  void update_state_SNS(String data) {
    edit_bills[0].SNS = data;
    notifyListeners();
  }

  void update_state_ID_BILLS(String data) {
    edit_bills[0].ID_BILLS = data;
    notifyListeners();
  }

  void update_state_CUSTOMERS(String data) {
    edit_bills[0].CUSTOMERS = data;
    notifyListeners();
  }

  void update_state_TEXT1(String data) {
    edit_bills[0].TEXT1S = data;
    notifyListeners();
  }

  void update_state_TEXT2(String data) {
    edit_bills[0].TEXT2S = data;
    notifyListeners();
  }

  void update_detailed(edit_bill data) {
    edit_bills[0] = data;
    notifyListeners();
  }

  void clear_all() {
    edit_bills.clear();
    notifyListeners();
  }

  Future<void> prepare_data(context) async {
    final localDatabase = LocalDatabase();
    List<Map<String, dynamic>> _wholeDataList = [];
    final edit_bill_provider edit_bills = Provider.of<edit_bill_provider>(context, listen: false);

    _wholeDataList = await localDatabase.readall_edit_bill();
    if (_wholeDataList.length == 0) {
      //          form: edit_bills.get_all()[0].form,
      await localDatabase.adddata_edit_bill(
          form: edit_bills.get_all()[0].form,
          PICTURE: edit_bills.get_all()[0].PICTURE,
          pic: edit_bills.get_all()[0].pic,
          head: edit_bills.get_all()[0].head,
          name: edit_bills.get_all()[0].name,
          address: edit_bills.get_all()[0].address,
          phone: edit_bills.get_all()[0].phone,
          tax: edit_bills.get_all()[0].tax,
          sn: edit_bills.get_all()[0].sn,
          id_bill: edit_bills.get_all()[0].id_bill,
          customer: edit_bills.get_all()[0].customer,
          text1: edit_bills.get_all()[0].text1,
          text2: edit_bills.get_all()[0].text2,
          HEADS: edit_bills.get_all()[0].HEADS,
          NAMES: edit_bills.get_all()[0].NAMES,
          ADDRESSS: edit_bills.get_all()[0].ADDRESSS,
          PHONSE: edit_bills.get_all()[0].PHONSE,
          TAXS: edit_bills.get_all()[0].TAXS,
          SNS: edit_bills.get_all()[0].SNS,
          ID_BILLS: edit_bills.get_all()[0].ID_BILLS,
          CUSTOMERS: edit_bills.get_all()[0].CUSTOMERS,
          TEXT1S: edit_bills.get_all()[0].TEXT1S,
          TEXT2S: edit_bills.get_all()[0].TEXT2S);
    } else {
      _data_product(_wholeDataList, context);
    }
  }

  void _data_product(List<Map<String, dynamic>> dataList, context) {
    final edit_bill_provider edit_bills = Provider.of<edit_bill_provider>(context, listen: false);
    edit_bills.clear_all();
    for (Map<String, dynamic> data in dataList) {
      print(data);
      String form = data['form'] ?? '';
      String PICTURE = data['PICTURE'] ?? '';
      bool pic = data['pic'] == 1;

      bool head = data['head'] == 1;
      bool name = data['name'] == 1;
      bool address = data['address'] == 1;
      bool phone = data['phone'] == 1;
      bool tax = data['tax'] == 1;
      bool sn = data['sn'] == 1;
      bool id_bill = data['id_bill'] == 1;

      bool customer = data['customer'] == 1;
      bool text1 = data['text1'] == 1;
      bool text2 = data['text2'] == 1;

      String HEADS = data['HEADS'] ?? '';
      String NAMES = data['NAMES'] ?? '';
      String ADDRESSS = data['ADDRESSS'] ?? '';
      String PHONSE = data['PHONSE'] ?? '';
      String TAXS = data['TAXS'] ?? '';

      String SNS = data['SNS'] ?? '';
      String ID_BILLS = data['ID_BILLS'] ?? '';
      String CUSTOMERS = data['CUSTOMERS'] ?? '';
      String TEXT1S = data['TEXT1S'] ?? '';
      String TEXT2S = data['TEXT2S'] ?? '';

      edit_bill GG = edit_bill(
          form: form,
          PICTURE: PICTURE,
          pic: pic,
          head: head,
          name: name,
          address: address,
          phone: phone,
          tax: tax,
          sn: sn,
          id_bill: id_bill,
          customer: customer,
          text1: text1,
          text2: text2,
          HEADS: HEADS,
          NAMES: NAMES,
          ADDRESSS: ADDRESSS,
          PHONSE: PHONSE,
          TAXS: TAXS,
          SNS: SNS,
          ID_BILLS: ID_BILLS,
          CUSTOMERS: CUSTOMERS,
          TEXT1S: TEXT1S,
          TEXT2S: TEXT2S);
      edit_bills.add_data(GG);
    }
  }
}
