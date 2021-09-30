import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ktpscanner/core/viewmodels/scanner/scanner_provider.dart';
import 'package:ktpscanner/ui/constant/constant.dart';
import 'package:ktpscanner/ui/widgets/components/nik/nik_item.dart';
import 'package:ktpscanner/ui/widgets/painter/text_painter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void scanImage(ImageSource source) {
    final scannerProv = ScannerProvider.instance(context);
    scannerProv.scan(source);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KTP Scanner"),
        actions: [
          Consumer<ScannerProvider>(
            builder: (context, scannerProv, _) {
              
              if (scannerProv.nik == null || scannerProv.nik!.isEmpty) {
                return const SizedBox();
              }
              return IconButton(
                icon: const Icon(Icons.copy, color: Colors.white),
                onPressed: () => scannerProv.copyNIK(context), 
              );
            },
          )
        ],
      ),
      floatingActionButton: _floatingMenu(),
      body: const HomeBody(),
    );
  }

  Widget _floatingMenu() {
    return SpeedDial(
      icon: Icons.camera_alt_sharp,
      backgroundColor: Colors.blue,
      visible: true,
      curve: Curves.bounceIn,
      elevation: 4,
      children: [
        SpeedDialChild(
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.camera_alt_sharp, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          onTap: () => scanImage(ImageSource.camera),
          label: 'Kamera',
          labelStyle: const TextStyle(
            color: Colors.white
          ),
          labelBackgroundColor: Colors.blue,
          elevation: 4
        ),
        SpeedDialChild(
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.image, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          onTap: () => scanImage(ImageSource.gallery),
          label: 'Galeri',
          labelStyle: const TextStyle(
            color: Colors.white
          ),
          labelBackgroundColor: Colors.blue,
          elevation: 4
        ),
      ],
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({ Key? key }) : super(key: key);
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void disposingTextDetector() {
    ScannerProvider.instance(context).disposing();
  }
  
  @override
  void dispose() {
    super.dispose();
    disposingTextDetector();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageResultWidget(),
        _nikResultWidget()
      ],
    );
  }

  Widget _nikResultWidget() {
    return Consumer<ScannerProvider>(
      builder: (context, scannerProv, _) {

        if (scannerProv.onSearch == true) {
          return SizedBox(
            height: deviceHeight(context) / 2,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (scannerProv.nik == null) {
          return const SizedBox();
        }

        if (scannerProv.nik!.isEmpty) {
          return SizedBox(
            height: deviceHeight(context) / 2,
            child: const Center(
              child: Text(
                "DATA GAGAL DITEMUKAN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15
                )
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: scannerProv.nik?.length,
            itemBuilder: (context, index) {
              
              final nik = scannerProv.nik![index];
              return NIKItem(nik: nik);
            },
          ),
        );
      },
    );
  }

  Widget _imageResultWidget() {
    return Consumer<ScannerProvider>(
      builder: (context, scannerProv, _) {
        return Container(
          width: deviceWidth(context),
          height: deviceHeight(context) * 0.3,
          color: Colors.grey,
          child: scannerProv.image != null && scannerProv.imageSize != null && scannerProv.textElements != null
            ? Container(
                height: deviceHeight(context) * 0.3,
                color: Colors.black,
                child: scannerProv.textElements!.isNotEmpty
                  ? CustomPaint(
                      foregroundPainter: TextDetectorPainter(
                        scannerProv.imageSize!,
                        scannerProv.textElements!,
                      ),
                      child: AspectRatio(
                        aspectRatio: scannerProv.imageSize!.aspectRatio,
                        child: Image.file(scannerProv.image!, fit: BoxFit.contain),
                      ),
                    )
                  : Image.file(scannerProv.image!, fit: BoxFit.contain),
              )
            : const SizedBox(),
        );
      },
    );
  }

}