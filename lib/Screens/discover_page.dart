import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/basic_model.dart';
import '../main.dart';
import 'edit_page.dart';

class discover_page extends StatefulWidget {
  bool? like;

  discover_page({this.like});

  @override
  State<discover_page> createState() => _discover_pageState();
}

class _discover_pageState extends State<discover_page> {
  bool isload = false;
  // bool isloadmore = false;
  Basic? basic;
  List<Datum> basicdata = [];

  @override
  void initState() {
    super.initState();
    getpref();
    getAllData();
  }

  getpref() async {
    final prefs = await SharedPreferences.getInstance();
    favlist = prefs.getStringList('favid')!;
    favourite = favlist.join(",");
  }

  getAllData() async {
    final http.Response response = await http.get(Uri.parse(discover_page_Url));

    if (response.statusCode == 200) {
      setState(() {
        // isloadmore = false;
        isload = true;
        basic = Basic.fromJson(jsonDecode(response.body));
        for (int i = 0; i < basic!.data!.length; i++) {
          bool isadd = false;
          for (int i1 = 0; i1 < favlist.length; i1++) {
            if (favlist[i1] == basic!.data![i].tId) {
              isadd = true;
              break;
            } else {
              isadd = false;
            }
          }
          basicdata.add(Datum(
              name: basic!.data![i].name,
              images: basic!.data![i].images,
              isfav: isadd,
              like: basic!.data![i].like,
              status: basic!.data![i].status,
              step: basic!.data![i].step,
              tId: basic!.data![i].tId,
              view: basic!.data![i].view));
          basicdata.sort((a, b) => a.name!.compareTo(b.name!)); // name sorting
        }
      });
    } else {
      throw Exception('Failed to update data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          body: Container(
            color: const Color(0xFF0B1222),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
                child: isload
                    ? ListView.builder(
                        itemCount: basicdata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 12),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => edit_page(
                                        name: basicdata[index].name!,
                                        id: int.parse(basicdata[index].tId!),
                                        like: basicdata[index].isfav,
                                      ),
                                    ));
                              },
                              child: Container(
                                height: 160,
                                width: double.infinity,
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: allclr[index % allclr.length],
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.06),
                                            BlendMode.dstATop),
                                        image:
                                            const AssetImage("Assete/bg.png")),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          height: 160,
                                          width: 120,
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              left: 15, top: 17),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16)),
                                          child: CachedNetworkImage(
                                            imageUrl: "$Base_Url_image${basicdata[index].images}",
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                              color: Color(0xFF192033),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0,
                                              top: 10,
                                              bottom: 5,
                                              left: 0),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.white30),
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          basicdata[index].isfav == false
                                                              ? favlist.add(basicdata[index].tId!)
                                                              : null;
                                                          for (var i = 0; i < favlist.length; i++) {
                                                            if (favlist[i] == basicdata[index].tId) {
                                                              int item = i;
                                                              basicdata[index].isfav == true
                                                                  ? favlist.removeAt(item)
                                                                  : null;
                                                            }
                                                          }
                                                          basicdata[index].isfav = basicdata[index].isfav == false
                                                              ? true
                                                              : false;
                                                        });
                                                        final prefs = await SharedPreferences.getInstance();

                                                        await prefs.setStringList('favid', favlist);
                                                      },
                                                      icon: basicdata[index].isfav == true || widget.like == false
                                                          ? const Icon(
                                                              Icons.favorite,
                                                              color: Colors.red)
                                                          : const Icon(
                                                              Icons.favorite_border,
                                                              color: Colors.white,
                                                            )),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  basicdata[index].name!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 0.3,
                                                      fontFamily:
                                                          "RecoletaRegular",
                                                      fontSize: 19),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  height: 35,
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: Colors.white),
                                                  child: Text(
                                                    "${basicdata[index].step!} Steps",
                                                    style: TextStyle(
                                                        color: allclr[index %
                                                            allclr.length],
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontFamily:
                                                            "ProductRegular"),
                                                  ),
                                                ),
                                                // SizedBox(height: 10),
                                              ]),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )),
          ),
        ));
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(16))),
            backgroundColor: const Color(0xFF0B1222),
            title: const Text(
              'Exit App',
              style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 0.7,
                  fontFamily: "ProductBold",
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            content: const Text(
              'Do you want to exit an App?',
              style: TextStyle(
                  fontSize: 18.5,
                  letterSpacing: 0.7,
                  fontFamily: "ProductRegular",
                  color: Colors.white),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF192033),
                      onPrimary: Colors.white,
                      shadowColor: const Color(0xFF192033),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(100, 40), //////// HERE
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'No',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "RecoletaRegular",
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFFA5E78),
                      // onPrimary: Colors.white,
                      shadowColor: const Color(0xFF192033),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(100, 40), //////// HERE
                    ),
                    onPressed: () => exit(0),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "RecoletaRegular",
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ) ?? false;
  }
}
