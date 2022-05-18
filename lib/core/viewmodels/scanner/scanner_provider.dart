import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ktpscanner/ui/constant/constant.dart';
import 'package:nik_validator/nik_validator.dart';
import 'package:provider/provider.dart';

class ScannerProvider extends ChangeNotifier {
  ///=========================
  /// This is property field 
  ///=========================
  
  /// Image result from image picker
  File? _image;
  File? get image => _image;
  /// Define image size from image picker
  Size? _imageSize;
  Size? get imageSize => _imageSize;

  List<TextElement>? _textElements;
  List<TextElement>? get textElements => _textElements;

  /// Text detector engine
  TextRecognizer? _textDetector;
  
  /// List of nik gained from scanner
  List<NIKModel?>? _nik;
  List<NIKModel?>? get nik => _nik;

  /// Event handling
  bool _onSearch = false;
  bool get onSearch => _onSearch;
  
  ///=========================
  /// This is function logic 
  ///=========================

  /// Instance provider
  static ScannerProvider instance(BuildContext context)
  => Provider.of(context, listen: false);
  
  void scan(ImageSource source) async {
    final _picker = ImagePicker();
    final XFile? _xImage = await _picker.pickImage(source: source, imageQuality: 100);
    if (_xImage != null) {

      /// For iOS it will have some issue in image,
      /// so we rotating the image to get fixed
      _image = Platform.isIOS 
        ? await FlutterExifRotation.rotateImage(path: _xImage.path) 
        : File(_xImage.path);
      /// Start recognize image result
      recognizeImage();
    }
  }

  /// Recognize image from image_picker 
  /// and parse to find NIK
  void recognizeImage() async {
    setOnSearch(true);

    _textDetector = TextRecognizer();
    _getImageSize(_image);

    /// Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_image!.path);
    /// Retrieving the RecognisedText from the InputImage
    final text = await _textDetector?.processImage(inputImage);

    RegExp regEx = RegExp(nikPattern);
    _nik = [];
    _textElements = [];

    /// Finding matching value with NIK pattern and store to list
    for (TextBlock block in text!.blocks) {
      for (TextLine line in block.lines) {

        String _text = line.text.trim().replaceAll(" ", "");
        if (regEx.hasMatch(_text)) {

          /// Parsing raw text and find NIK Informations
          var _result = await parse(regEx.stringMatch(_text)!);
          if (_result != null) {
            _nik?.add(_result);
          }

          for (TextElement element in line.elements) {
            _textElements?.add(element);
          }
        }
      }
    }
    setOnSearch(false);
  }

  /// Parsing NIK Informations
  Future<NIKModel?>? parse(String text) async {
    NIKModel result = await NIKValidator.instance.parse(nik: text);
    if (result.valid == true) {
      return result;
    }
    return null;
  }

  void _getImageSize(File? imageFile) async {
    final completer = Completer<Size>();

    final Image image = Image.file(imageFile!);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size size = await completer.future;
    _imageSize = size;
    notifyListeners();
  }

  /// Copy list of NIK from result
  void copyNIK(BuildContext context) {
    if (_nik != null && _nik!.isNotEmpty) {
      String? text = "";
      for (var _item in _nik!) {
        text = text! + "${_item?.nik}\n";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Berhasil menyalin nomor NIK",
          ),
          backgroundColor: Colors.green,
        )
      );
    }
  }

  /// It will called from dispose screen
  void disposing() {
    _textDetector?.close();
    notifyListeners();
  }

  /// Set event search
  void setOnSearch(bool value) {
    _onSearch = value;
    notifyListeners();
  }
}