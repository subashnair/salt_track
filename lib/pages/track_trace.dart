
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salt_track/services/login_call.dart';
import 'package:intl/intl.dart';
import 'package:salt_track/constants.dart';
import 'dart:ui' as ui;

class Tracker extends StatefulWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  String user_id='';
  String user_name='';
  String storerKey='';
  String awb_nr='';
  String track_num='';
  String order_num='';
  Map data={} ;
  Order order = Order();

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    user_id =data['userid'];
    storerKey = user_id.toUpperCase();
    final fieldText = TextEditingController();
    void clearText() {
      fieldText.clear();
    }
    void navigateScreen() {
      Navigator.pushReplacementNamed(context, '/login', ) as bool;
    }
    void Alert(String messageString)
    {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Warning!'),
          content: Text(messageString),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    void clearData() {
      order = Order();
      track_num='';
      awb_nr='';
      user_name='';
      order_num='';
      setState(() { });
    }
    void renderData() async {
      Tracking instance = Tracking();
      try {
        order = await instance.getTrack(user_id, track_num);
      } catch(e) {
        Alert('Track Number# $track_num Not Found');
         clearData();
       // print('$e');
      }
      user_name = order.customer!.firstName;
      awb_nr = order.airwayBillNumber;
      order_num = order.orderNumber;
      setState(() { });
    }

    List<DataRow> _rowGenerate()
    {
        return List<DataRow>.generate(
          order.statuses?.length??0, (int index) => DataRow(
              color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                    if (index.isOdd) return Colors.lightBlue.withOpacity(0.3);
                    return null; // Use default value for other states and odd rows.
                  }),
              cells: <DataCell>[
                DataCell(SizedBox(width:  60,child: Text(order.statuses![index].status,
                  style: const TextStyle(fontSize: 11 ), ))),
                DataCell(SizedBox(width: 110,child: Text(order.statuses![index].detail,
                  style: const TextStyle(fontSize: 10 ), ))),
                DataCell(SizedBox(width:  80,child: Text(DateFormat.yMd().add_jm().format(order.statuses![index].timeStamp),
                  style: const TextStyle(fontSize: 11 ), ))),
              ]
          ),
        );
      }
      List<DataColumn> _colGenerate()
      {
       return [
            DataColumn(label: Text('Status', style: kTableHeaderTextStyle,),),
            DataColumn(label: Text('Detail', style: kTableHeaderTextStyle,),),
            DataColumn(label: Text('Time', style: kTableHeaderTextStyle,),)
            ].toList();
    }
    return Scaffold(
      backgroundColor: Colors.blueGrey[20],
      appBar: AppBar(
        title: Text('Track Order : $storerKey'),
        backgroundColor: Colors.lightBlue,
        iconTheme: IconThemeData(),
      ),

      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Padding(
            padding: const EdgeInsets.all(25.0),
            child:Container(
              width: 200,
              child:  TextField(
                decoration: InputDecoration(
                    hintText: 'Enter Track Number',
                    focusColor: Colors.green,
                    suffixIcon: IconButton(icon: Icon(Icons.clear),onPressed: clearText)),
                controller: fieldText,
                onSubmitted: (value) {
                track_num=value;
                renderData();
              },
            ),
          )),
          Container(
            child: Card(
              child: Padding (
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                  //color: Colors.lightGreen,
                  child : Table(
                  columnWidths: {
                        0: FixedColumnWidth(85.0),// fixed to 100 width
                        1: FlexColumnWidth(200),
                        2: FixedColumnWidth(65.0),
                        3: FixedColumnWidth(50.0),//fixed to 100 width
                     },
                    children: [
                      TableRow(
                        children: [
                          TableCell(child: Text('AWB Nr:', style: TextStyle (fontWeight:FontWeight.bold,fontSize: 14))),
                          TableCell(child: Text(this.awb_nr, style: TextStyle(fontSize: 14))),
                          TableCell(child: Text('Order#:', style: TextStyle (fontWeight:FontWeight.bold, fontSize: 14))),
                          TableCell(child: Text(this.order_num, style: TextStyle(fontSize: 14)))
                        ]
                      ),
                      TableRow(
                          children: [
                            TableCell(child: Text('')),
                            TableCell(child: Text('')),
                            TableCell(child: Text('')),
                            TableCell(child: Text(''))
                          ]
                      ),
                      TableRow(
                        children: [
                            TableCell(child: Text('Customer:', style: TextStyle (fontWeight:FontWeight.bold))),
                            TableCell(child: Text(this.user_name) ),
                            TableCell(child: Text('')),
                            TableCell(child: Text(''))
                        ]),
                      ]),
                  ),
                  ),
              elevation: 7,
              shadowColor: Colors.lightBlue,
              margin: EdgeInsets.all(10),
              shape:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white)
              ),
            ),
          ),
          SizedBox( height: 15,),
          Expanded(
              child: Card (
                child:DataTable(
                     headingRowColor: MaterialStateProperty.all<Color>(Colors.indigo),
                     headingRowHeight: 35,
                     headingTextStyle: TextStyle( color: Colors.white),
                     columns: _colGenerate(),
                     rows: _rowGenerate()
                  ),
                elevation: 8,
                shadowColor: Colors.green,
                margin: EdgeInsets.all(10),
                shape:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)
            )
          )
          ),
          SizedBox( height: 75,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            //  SizedBox( width: 150,),
              OutlinedButton(
                onPressed: () {
                  clearData();
                },
                child: const Text('Clear'),
              ),
              SizedBox(
                width: 5,
              ) ,
              OutlinedButton.icon(
                onPressed: () {
                  navigateScreen();
                },
                icon: const Icon(Icons.logout),
                label: Text('Logout'),
              )
            ],
          ),
          SizedBox( height: 25,)
        ],
      )
    );
  }
}
