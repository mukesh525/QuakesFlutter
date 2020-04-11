import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'allquakes.dart';
import 'package:intl/intl.dart';

AllQuakes _data;

void main() async {
  _data = await getQuakes();
  // debugPrint(_data.features[0].properties.place);
  runApp(new MaterialApp(
    title: "Quakes",
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Quakes"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: _data == null ? 0 : _data.features.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, int position) {
            var format = new DateFormat.yMMMd("en_US").add_jm();
            if (position.isOdd) return new Divider();
            final index = position ~/
                2; // we are dividing position by 2 and returning integer result
            var date = new DateTime.fromMillisecondsSinceEpoch(
                _data.features[index].properties.time,
                isUtc: true);
            //creating row for list
            return new ListTile(
              title: new Text(
                "At ${format.format(date)}",
                style: new TextStyle(
                    fontSize: 19.5,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: new Text(
                _data.features[index].properties.place.toString(),
                style: new TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic),
              ),
              leading: new CircleAvatar(
                backgroundColor: Colors.red,
                child: new Text(
                  _data.features[index].properties.mag.toString(),
                  style: new TextStyle(
                      fontSize: 16.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              onTap: ()=>showOnTapMessage(context,_data.features[index].properties.title),

            );
          },
        ),
      ),
    );
  }
}


void showOnTapMessage(BuildContext context,String message){
  var alert = new AlertDialog(
    title: new Text("Quakes"),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Text("ok"))
    ],
  );
  showDialog(context: context,child: alert);

}

Future<AllQuakes> getQuakes() async {
  String url =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(url);
  AllQuakes quakes = new AllQuakes.fromJson(jsonDecode(response.body));
  return quakes;
}
