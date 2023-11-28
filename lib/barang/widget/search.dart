import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/barangcontroller.dart';
import 'addbarang/addbarang.dart';
import 'list/contentlist.dart';
import 'listsearch.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Getbarang b = Get.put(Getbarang());
  TextEditingController barang = TextEditingController();
  late String barcode;

  Widget sc() {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 15, right: 0, bottom: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            b.cari(cari: value);
          });
        },
        cursorColor: Colors.black,
        style: TextStyle(
          fontSize: 13,
        ),
        controller: barang,
        decoration: InputDecoration(
          hintText: "Cari barang",
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: WillPopScope(
      onWillPop: () async {
        if (mounted) {
          b.temu.clear();
          Get.back();
          return true;
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: sc(),
          ),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  GetBuilder<Getbarang>(
                    init: Getbarang(),
                    builder: (val) {
                      if(val.temu.isEmpty){
                        return Column(
                          children: [
                            for (var a in val.barang)
                              Expa(
                                kode: a['data']['bar'],
                                id: a['id'],
                                nama: a['data']['nama'],
                                harga: a['data']['harga'],
                                stock: a['data']['jumlah'],
                              ),
                          ],
                        );
                      }else if(val.temu.first['message'] != null){
                        return Center(
                          child: Container(
                            child: Text('Kosong'),
                          ),
                        );
                      }else{
                        return Column(
                          children: [
                            for (var a in val.temu)
                              Expa(
                                kode: a['data']['bar'],
                                id: a['id'],
                                nama: a['data']['nama'],
                                harga: a['data']['harga'],
                                stock: a['data']['jumlah'],
                              ),
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    )
    );
  }
}
