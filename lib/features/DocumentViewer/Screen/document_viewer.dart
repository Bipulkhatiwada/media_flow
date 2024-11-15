import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class DocumentViewerScreen extends StatefulWidget {
  @override
  // ignore: 
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
        // Skip inaccessible directories/files
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
      appBar: AppBar(
        title: Text(
          'PDF Files',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<List<String>>(
        valueListenable: pdfFiles,
        builder: (context, files, _) {
          if (files.isEmpty) {
            return Center(
              child: Text(
                'No PDF files found',
                style: TextStyle(color: Colors.green),
              ),
            );
          }

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              String filePath = files[index];
              String fileName = path.basename(filePath);

              return ListTile(
                title: Text(
                  fileName,
                  style: TextStyle(color: Colors.green),
                ),
                leading: Image.asset(
                'assets/images/pdf.png',
                  height: 30,
                  width: 30,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(pdfPath: filePath),
                    ),
                  );
                },
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

  PDFViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDF Viewer',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      backgroundColor: Colors.black,
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