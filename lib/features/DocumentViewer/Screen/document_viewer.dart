import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class DocumentViewerScreen extends StatefulWidget {
  const DocumentViewerScreen({super.key});

  @override
  _DocumentViewerScreen createState() => _DocumentViewerScreen();
}

class _DocumentViewerScreen extends State<DocumentViewerScreen> {
  final ValueNotifier<List<String>> pdfFiles = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    requestPermissionsAndFetchFiles();
  }

  Future<void> requestPermissionsAndFetchFiles() async {
    PermissionStatus permissionStatus;

    if (await Permission.manageExternalStorage.isGranted) {
      permissionStatus = PermissionStatus.granted;
    } else {
      permissionStatus = await Permission.manageExternalStorage.request();
    }

    if (permissionStatus.isGranted) {
      var rootDirectory = Directory('/storage/emulated/0/Download');
      await getFiles(rootDirectory);
    } else {
      debugPrint("Permission denied");
    }
  }

  Future<void> getFiles(Directory rootDirectory) async {
    try {
      List<String> pdfList = [];
      var files = rootDirectory.listSync(recursive: true);

      for (var file in files) {
        try {
          if (file is File && file.path.endsWith('.pdf')) {
            pdfList.add(file.path);
          } else if (file is Directory) {
            await getFiles(file);
          }
        } catch (e) {
          debugPrint('Access denied: ${file.path}');
        }
      }

      pdfFiles.value = pdfList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A1A1A),
        title:  Text(
          'PDF Files',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: pdfFiles,
        builder: (context, files, _) {
          if (files.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                   SizedBox(height: 16.h),
                  Text(
                    'No PDF files found',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              String filePath = files[index];
              String fileName = path.basename(filePath);

              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Image.asset(
                        'assets/images/pdf.png',
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                    title: Text(
                      fileName,
                      maxLines: 2,
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 32,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerScreen(pdfPath: filePath),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          path.basename(pdfPath),
          style:  TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PDFView(
        filePath: pdfPath,
        onRender: (pages) {
          debugPrint("Total Pages: $pages");
        },
        onPageChanged: (page, total) {
          debugPrint("Page changed: $page/$total");
        },
        pageFling: false,
        autoSpacing: false,
      ),
    );
  }
}