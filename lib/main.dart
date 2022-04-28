import 'dart:convert';

import 'package:flutter/material.dart';
import './Services/Services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EFE Task',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'EFE Task'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? currency;
  bool? dialcode;
  bool? flag;
  bool? sumbitPressed;
  void initState() {
    super.initState();
    currency = false;
    dialcode = false;
    flag = false;
    sumbitPressed = false;
  }

  List<String> columns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 100, top: 70),
            child: Row(
              children: [
                Text("currency: "),
                Checkbox(
                    value: currency,
                    onChanged: (value) {
                      setState(() {
                        currency = value;
                        sumbitPressed = false;
                      });
                    }),
                Text("dialcode: "),
                Checkbox(
                    value: dialcode,
                    onChanged: (value) {
                      setState(() {
                        dialcode = value;
                        sumbitPressed = false;
                      });
                    }),
                Text("flag: "),
                Checkbox(
                    value: flag,
                    onChanged: (value) {
                      setState(() {
                        flag = value;
                        sumbitPressed = false;
                      });
                    }),
                TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    setState(() {
                      sumbitPressed = true;
                      columns = [];
                      if (currency ?? false) {
                        columns.add('currency');
                      }
                      if (dialcode ?? false) {
                        columns.add('dialcode');
                      }
                      if (flag ?? false) {
                        columns.add('flag');
                      }
                      print('columns: '  + columns.join(",").toString());
                    });
                  },
                )
              ],
            ),
          ),
          columns.join(",") == "" && !(sumbitPressed ?? true)
              ? Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text("Press submit to get countries"))
              : Expanded(
                  child: FutureBuilder<String>(
                  future: Service.getCountriesInfo(columns.join(",")),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      List<Card> cards = [];
                      (json.decode(snapshot.data ?? "[]")["data"] ?? []).forEach((el) {
                        cards.add(Card(
                            child: ListTile(
                                title: Text(el['name'] ?? ""),
                                subtitle: Text("currency: " +
                                    (el['currency'] ?? "") +
                                    "\ndialcode: " +
                                    (el['dialcode'] ?? "")),
                                trailing: el['flag'] == null? null: SvgPicture.network(
                                  el['flag'] ?? "",
                                  semanticsLabel: 'Flag',
                                  width: 80,
                                ))));
                      });

                      return ListView(
                        padding: EdgeInsets.all(8),
                        children: cards,
                      );
                    } else {
                      return Text('');
                    }
                  },
                ))
        ],
      ),
    );
  }
}
