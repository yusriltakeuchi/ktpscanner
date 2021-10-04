import 'package:flutter/material.dart';
import 'package:nik_validator/nik_validator.dart';

class NIKItem extends StatelessWidget {
  final NIKModel? nik;
  const NIKItem({
    Key? key,
    required this.nik,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          _textItem(title: "NIK", value: nik?.nik),
          const Divider(color: Colors.black),
          _textItem(title: "Kode Unik", value: nik?.uniqueCode),
          const Divider(color: Colors.black),
          _textItem(title: "Jenis Kelamin", value: nik?.gender),
          const Divider(color: Colors.black),
          _textItem(title: "Usia", value: nik?.age),
          const Divider(color: Colors.black),
          _textItem(title: "Ulang Tahun", value: nik?.nextBirthday),
          const Divider(color: Colors.black),
          _textItem(title: "Provinsi", value: nik?.province),
          const Divider(color: Colors.black),
          _textItem(title: "Kabupaten/Kota", value: nik?.city),
          const Divider(color: Colors.black),
          _textItem(title: "Kecamatan", value: nik?.subdistrict),
          const Divider(color: Colors.black),
          _textItem(title: "Kode Pos", value: nik?.postalCode),
        ],
      ),
    );
  }

  Widget _textItem({required String? title, required String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title!,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Expanded(
          child: Text(
            value!,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        )
      ],
    );
  }
}
