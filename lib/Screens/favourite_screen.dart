import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw1/Screens/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/basic_model.dart';
import '../../main.dart';
import 'home_screen.dart';

class favourite_screen extends StatefulWidget {
  const favourite_screen({Key? key, bool? like}) : super(key: key);

  @override
  State<favourite_screen> createState() => _favourite_screenState();
}

class _favourite_screenState extends State<favourite_screen> {

  bool isload = false;
  bool isloadmore = false;
  Basic? fav;
  List<Datum> favouriteData = [];

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  getAllData() async {
    if(favlist.isNotEmpty)
      {
        final prefs = await SharedPreferences.getInstance();
        favlist = prefs.getStringList('favid')!;
        favourite = favlist.join(",");
      }
    final http.Response response = await http.get(
      favlist.isEmpty
          ? Uri.parse(
          "https://expresstemplate.in/mix_drawing/webservice/bookmark.php?code=en")
          : Uri.parse(
          "$favourite_page_Url$favourite"),
    );

     if (response.statusCode == 200) {

      final dcode = jsonDecode(response.body);

      if(dcode["code"] == 400)
      {
        setState(() {
          favlist = [];
          isload = true;
        });
        print(isload);
      }
      else
      {
        setState(() {
          isloadmore = false;
          isload = true;
          fav = Basic.fromJson(jsonDecode(response.body));
          favouriteData = fav!.data!;
        });
      }
    }
    else {
      throw Exception('Failed to update data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: GoBack, child: Scaffold(
      body: Container(
        color: const Color(0xFF0B1222),
        height: double.infinity,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
            child: isload
                ? favlist.isEmpty
                ? const Center(
              child: Text(
                "No Data Found",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
                : ListView.builder(
              itemCount: favouriteData.length,
              itemBuilder: (context, index) {
                int revindex =  favouriteData.length -1 - index;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => edit_page( name: favouriteData[revindex].name!,
                                id: int.parse(favouriteData[revindex].tId!),
                                like: true)
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
                              image: const AssetImage("Assete/bg.png")),
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 160,
                              width: 120,
                              alignment: Alignment.bottomCenter,
                              margin:
                              const EdgeInsets.only(left: 15, top: 17),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(16)),
                              child:
                              CachedNetworkImage(
                                imageUrl: "$Base_Url_image${favouriteData[revindex].images}",
                                placeholder: (context, url) =>  CircularProgressIndicator(color: const Color(0xFF192033),),
                                errorWidget: (context, url, error) =>  Icon(Icons.error),
                              )
                            ),
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0,
                                      top: 10,
                                      bottom: 5,
                                      left: 0),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
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
                                              BorderRadius
                                                  .circular(12),
                                              color: Colors.white30),
                                          child: IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  for (var i = 0; i < favlist.length; i++) {
                                                    if (favlist[i] == favouriteData[revindex].tId) {
                                                      int item = i;
                                                      favlist.removeAt(item);
                                                    }
                                                  }
                                                });
                                                final prefs = await SharedPreferences.getInstance();
                                                await prefs.setStringList('favid', favlist);
                                                favourite == "" || favlist.isEmpty ? null : getAllData();
                                              },
                                              icon: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red)),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          favouriteData[revindex].name!,
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
                                              BorderRadius
                                                  .circular(16),
                                              color: Colors.white),
                                          child: Text(
                                            "${favouriteData[revindex].step!} Steps",
                                            style: TextStyle(
                                                color: allclr[index %
                                                    allclr.length],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                fontFamily:
                                                "ProductRegular"),
                                          ),
                                        ),
                                        // SizedBox(height: 10),
                                      ]),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              },
            )
                : const Center(
              child: const CircularProgressIndicator(),
            )),
      ),
    ));
  }

  Future<bool> GoBack()
  {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
       return home_screen();
      },));
      return Future.value();
  }
}
