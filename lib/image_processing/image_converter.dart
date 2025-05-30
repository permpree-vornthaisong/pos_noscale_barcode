// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/widgets.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:bitmap/bitmap.dart';
// import 'package:image/image.dart' as img;

// /// คลาสสำหรับจัดการกับการโหลดรูปภาพ การบีบอัด และการแปลงเป็น Bitmap โดยใช้ flutter_image_compress.
// class ImageConverter {
//   static Future<Bitmap?> loadImageAsBitmap(
//     ImageProvider imageProvider, {
//     int? targetWidth,
//     int quality = 90,
//   }) async {
//     try {
//       debugPrint("ImageConverter: กำลังแปลง ImageProvider เป็น Uint8List...");
//       final Uint8List? originalBytes =
//           await _getUint8ListFromImageProvider(imageProvider);

//       if (originalBytes == null || originalBytes.isEmpty) {
//         debugPrint(
//             "ImageConverter: ไม่สามารถดึง Uint8List จาก ImageProvider ได้.");
//         return null;
//       }

//       final img.Image? originalImg = img.decodeImage(originalBytes);
//       if (originalImg == null) {
//         debugPrint(
//             "ImageConverter: ไม่สามารถถอดรหัสรูปภาพต้นฉบับเพื่อหาขนาดได้.");
//         return null;
//       }

//       int minWidth = targetWidth ?? originalImg.width;
//       int minHeight = targetWidth != null
//           ? (minWidth / (originalImg.width / originalImg.height)).round()
//           : originalImg.height;

//       debugPrint(
//           "ImageConverter: กำลังบีบอัดรูปภาพด้วย minWidth: $minWidth, minHeight: $minHeight, quality: $quality");

//       final Uint8List? compressedBytes =
//           await FlutterImageCompress.compressWithList(
//         originalBytes,
//         minWidth: minWidth,
//         minHeight: minHeight,
//         quality: quality,
//       );

//       if (compressedBytes == null || compressedBytes.isEmpty) {
//         debugPrint(
//             "ImageConverter: การบีบอัดรูปภาพส่งคืนข้อมูลว่างเปล่าหรือเป็น null.");
//         return null;
//       }

//       final img.Image? finalImg = img.decodeImage(compressedBytes);
//       if (finalImg == null) {
//         debugPrint(
//             "ImageConverter: ไม่สามารถถอดรหัสรูปภาพที่บีบอัดแล้ว เพื่อหาขนาดสุดท้ายได้.");
//         return null;
//       }

//       debugPrint(
//           "ImageConverter: ขนาดรูปภาพที่บีบอัดแล้ว: ${finalImg.width}x${finalImg.height}");

//       return Bitmap.fromHeadless(
//           finalImg.width, finalImg.height, compressedBytes);
//     } catch (e) {
//       debugPrint(
//           "ImageConverter: เกิดข้อผิดพลาดในระหว่างการประมวลผลรูปภาพ: $e");
//       return null;
//     }
//   }

//   static Future<Uint8List?> _getUint8ListFromImageProvider(
//       ImageProvider imageProvider) async {
//     final Completer<Uint8List?> completer = Completer();
//     final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
//     ImageStreamListener? listener;

//     listener = ImageStreamListener(
//       (ImageInfo imageInfo, bool synchronousCall) async {
//         final ui.Image image = imageInfo.image;
//         final ByteData? byteData =
//             await image.toByteData(format: ui.ImageByteFormat.png);

//         if (byteData != null) {
//           completer.complete(byteData.buffer.asUint8List());
//         } else {
//           completer.complete(null);
//         }
//         if (listener != null) {
//           stream.removeListener(listener);
//         }
//       },
//       onError: (Object exception, StackTrace? stackTrace) {
//         debugPrint(
//             "ImageConverter: Error loading image from ImageProvider to Uint8List: $exception");
//         completer.complete(null);
//         if (listener != null) {
//           stream.removeListener(listener);
//         }
//       },
//     );

//     stream.addListener(listener);
//     return completer.future;
//   }
// }
