import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw1/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/step_model.dart';
import 'home_screen.dart';

class edit_page extends StatefulWidget {
  String? name;
  int? id;
  bool? like;

  edit_page({
    this.name,
    this.id,
    this.like,
  });

  @override
  State<edit_page> createState() => _edit_pageState();
}

class _edit_pageState extends State<edit_page> {
  bool isload = false;
  StepData? step;
  List<StepDatum> stepdata = [];
  int steps = 0;

  @override
  void initState() {
    super.initState();
    EditScreen();
  }

  EditScreen() async {
    final http.Response response = await http.get(
      Uri.parse("$Detail_page_Url${widget.id}"),
    );
    if (response.statusCode == 200) {
      setState(() {
        isload = true;
        step = StepData.fromJson(jsonDecode(response.body));
        stepdata = step!.data!;
      });
    } else {
      throw Exception('Failed to update data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: GoBack,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF192033),
            elevation: 0,
            toolbarHeight: 65,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return home_screen(like: widget.like);
                  },
                ));
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              iconSize: 30,
            ),
            title: Text(
              "${widget.name}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                  fontFamily: "RecoletaRegular",
                  fontSize: 22),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(1),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      widget.like == false
                          ? favlist.add(widget.id.toString())
                          : null;
                      for (var i = 0; i < favlist.length; i++) {
                        if (favlist[i] == widget.id.toString()) {
                          int item = i;
                          widget.like == true ? favlist.removeAt(item) : null;
                        }
                      }
                      widget.like = widget.like == false ? true : false;

                      print(favlist);
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setStringList('favid', favlist);
                  },
                  child: Container(
                      // height: 10,
                      width: 45,
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        widget.like == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                        size: 30,
                      )),
                ),
              )
            ],
          ),
          body: isload == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0B1222),
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Expanded(
                        child:  Container(
                          height: 350,
                          width: 500,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(15),
                          child: CachedNetworkImage(
                            imageUrl: "$Detail_page_Image_Url${stepdata[steps].image}",
                            placeholder: (context, url) =>  CircularProgressIndicator(color: const Color(0xFF192033),),
                            errorWidget: (context, url, error) =>  Icon(Icons.error),
                          )
                        ),
                       ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 40, right: 40, bottom: 35),
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xffECECEC)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (steps>=1) {
                                      steps = 0 < steps ? steps - 1 : steps;
                                    }
                                    else
                                    {
                                      print("NULL");
                                    }
                                  });
                                },
                                child: (steps>=1) ? Container(
                                  height: 45,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff25223E),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ) : Container(
                                  height: 45,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color:Colors.transparent,
                                      borderRadius: BorderRadius.circular(8)),
                                )
                              ),
                              Container(
                                height: 45,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: const Color(0xff25223E),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Text(
                                  "Steps\n${steps + 1}/${stepdata.length}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (steps == stepdata.length-1) {
                                      print("NULL");
                                    }
                                    else
                                      {
                                        steps = stepdata.length - 1 > steps
                                            ? steps + 1
                                            : steps;
                                      }
                                  });
                                },
                                child: (steps == stepdata.length-1) ? Container( height: 45,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8)),) :
                                Container(
                                  height: 45,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff25223E),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }

  Future<bool> GoBack() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return home_screen(like: widget.like);
      },
    ));
    return Future.value();
  }
}
