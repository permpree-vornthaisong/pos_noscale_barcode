import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/data_pruduct_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/filter_numname_provider.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/system_provider.dart';
import 'package:pos_noscale_barcode/TEXT/TEXT.dart';
import 'package:provider/provider.dart';

class SearchData extends StatefulWidget {
  const SearchData({Key? key}) : super(key: key);

  @override
  State<SearchData> createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Set the initial value for the text controller

    _textController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    // Dispose of the text controller to prevent memory leaks
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter_num_name_provider filter_num_names = Provider.of<filter_num_name_provider>(context, listen: false);
    final data_product_provider data_products = Provider.of<data_product_provider>(context, listen: false);
    final system_provider systems = Provider.of<system_provider>(context, listen: false);

    return Container(
      height: 200,
      width: 500,
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              _textController.text = value.toString();
              filter_num_names.update_data(_textController.text);
              //    print(filter_num_names.get_data_filter());
              data_products.info(context);
              filter_num_names.update_data("");
            },
            controller: _textController,
            style: GoogleFonts.sarabun(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 25,
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 0, 0, 0),
              fontStyle: FontStyle.normal,
            ),
            decoration: InputDecoration(
              hintText: systems.get_all()[0].language == "thai" ? thai_text().tab_type_for_find : eng_text().tab_type_for_find,
              // You can add more customization options here
            ),
          ),
        ),
        /* GestureDetector(
            onTap: () {
              filter_num_names.update_data("");
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pop();
              });
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.amber,
            ))*/
      ]),
    );
  }
}
