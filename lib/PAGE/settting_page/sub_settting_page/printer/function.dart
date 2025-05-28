import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/edit_bill_provider.dart';
import 'package:pos_noscale_barcode/PAGE/settting_page/sub_settting_page/system/function.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

Future<void> image_logo_in(context) async {
  await requestStoragePermission();

  try {
    Directory directory2 = Directory('/storage/');
    List<FileSystemEntity> contents = directory2.listSync();

    if (contents[0].toString() != "emulated") {
      Directory directory = Directory((contents[0] as Directory).path + '/POS_APP/input/Img');

      String imagePath = path.join(directory.path, 'logo.jpg');

      List<int> imageBytes = await File(imagePath).readAsBytes();
      String base64Image = base64Encode(imageBytes);

      Provider.of<edit_bill_provider>(context, listen: false).update_state_PICTURE(base64Image);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('logo'),
        ),
      );
    }
  } catch (e) {
    print(e.toString());
  }
}
