import 'package:flutter/services.dart';

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../extensions/extensions.dart';

///Helper Class resbonsible for sharing images for printing docs or sharing widgets as images (Qr)

abstract class ShareHelper {
  ///used for sharing widgets as Images
  static Future<void> captureAndShare({
    required RenderRepaintBoundary boundary,
  }) async {
    ui.Image image = await boundary.toImage(pixelRatio: 5);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    String mime = 'image/png';
    final XFile xfile =
        XFile.fromData(pngBytes, mimeType: mime, name: '${Random()}.png');

    await Share.shareXFiles(
      [xfile],
    );
  }

  ///Calculate the duration between two dates
  static Duration calculateDifference(DateTime startDate, String? startTime,
      DateTime endDate, String? endTime) {
    DateFormat timeFormat = DateFormat("hh:mm a");

    DateTime startDateTime;
    DateTime endDateTime;

    if (startTime != '') {
      DateTime parsedStartTime = timeFormat.parse(startTime!);
      startDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        parsedStartTime.hour,
        parsedStartTime.minute,
      );
    } else {
      startDateTime =
          DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
    }

    if (endTime != '') {
      DateTime parsedEndTime = timeFormat.parse(endTime!);
      endDateTime = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        parsedEndTime.hour,
        parsedEndTime.minute,
      );
    } else {
      endDateTime = DateTime(endDate.year, endDate.month, endDate.day, 0, 0);
    }

    return endDateTime.difference(startDateTime);
  }

  static printDoc(List<List<dynamic>> data, List<String> headers,
      [List<Uint8List>? images]) async {
    final doc = pw.Document();
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    if (Get.context!.isArabic) {
      headers = headers.reversed.toList();
    }
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.ClipRRect(
            verticalRadius: 8.r,
            horizontalRadius: 8.r,
            child: pw.Table(
              defaultColumnWidth: const pw.FlexColumnWidth(),
              border: pw.TableBorder.symmetric(
                outside: pw.BorderSide.none,
              ),
              children: [
                // Header
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#2D2D2D'),
                  ),
                  children: headers.map((header) {
                    return pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                        vertical: 12.0.w,
                        horizontal: 6.w,
                      ),
                      child: pw.Text(
                        header.tr,
                        textDirection: Get.context!.isArabic
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 16,
                          color: PdfColors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                ...List.generate(data.length, (rowIndex) {
                  List<dynamic> row = data[rowIndex];
                  if (Get.context!.isArabic) {
                    row = row.reversed.toList();
                  }
                  return pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      decoration: pw.BoxDecoration(
                        color: rowIndex % 2 == 0
                            ? PdfColor.fromHex('#F5F5F5')
                            : PdfColors.white,
                      ),
                      children: List.generate(
                        row.length,
                        (index) {
                          final isApproved = row[index] == 'Approved'.tr;
                          final isRejected = row[index] == 'Rejected'.tr;
                          final isPending = row[index] == 'Pending'.tr;
                          final isAbsent = row[index] == 'Absent'.tr;
                          final isPresent = row[index] == 'Present'.tr;
                          final isLate = row[index] == 'Late'.tr;
                          final isLink = row[index].startsWith('http');
                          return pw.Padding(
                            padding: pw.EdgeInsets.symmetric(
                              vertical: 12.0.w,
                              horizontal: 6.w,
                            ),
                            child: Get.context!.isArabic &&
                                        index == row.length - 1 &&
                                        images != null ||
                                    !Get.context!.isArabic &&
                                        index == 0 &&
                                        images != null
                                ? pw.Align(
                                    alignment: Get.context!.isArabic
                                        ? pw.Alignment.centerRight
                                        : pw.Alignment.centerLeft,
                                    child: pw.Container(
                                      height: 32.h,
                                      width: 20.w,
                                      decoration: pw.BoxDecoration(
                                        borderRadius:
                                            pw.BorderRadius.circular(8.r),
                                        image: pw.DecorationImage(
                                          image: pw.MemoryImage(
                                            images[rowIndex],
                                            // for backend
                                            //  controller.getRequestedUser(controller.requestModels[index]).profilePic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : pw.Text(
                                    row[index],
                                    textDirection: Get.context!.isArabic
                                        ? pw.TextDirection.rtl
                                        : pw.TextDirection.ltr,
                                    style: pw.TextStyle(
                                      fontSize: 14.sp,
                                      font: arabicFont,
                                      color: isRejected || isAbsent
                                          ? PdfColor.fromHex('#DF1C1C')
                                          : isApproved || isPresent
                                              ? PdfColor.fromHex('#008000')
                                              : isPending || isLate
                                                  ? PdfColor.fromHex('#FF814A')
                                                  : isLink
                                                      ? PdfColors.blue
                                                      : PdfColor.fromHex(
                                                          '#2D2D2D'),
                                    ),
                                  ),
                          );
                        },
                      ));
                }),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
