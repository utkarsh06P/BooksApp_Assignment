import 'package:booksappassignment/search_page.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primaryColor: primary,
      ),
      home: const IndexPage(),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;
  List _searchedusers = [];
  DateTime pickedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  void initState() {
    super.initState();
    this.fetchUser();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  fetchUser() async
  {
    var url = "https://run.mocky.io/v3/f3feef1c-9bfa-43fd-b2a0-bbe9abadb4f6";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['clients'];
      setState(() {
        users = items;
      });
    }
    else {
      setState(() {
        users = [];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listing Users"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView.builder(
        itemCount: users.length + 1, itemBuilder: (content, index) {
      return index == 0 ? _searchBar() :getCard(users[index - 1]);
    });
  }

  _searchBar()
  {
    return  Padding(padding: const EdgeInsets.all(16),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search.....'
      ),
      onChanged: (text)
      {
        text  = text.toLowerCase();
        setState(() {
          users = users.where((note) {
            var noteTitle = note.item['name'].toLowerCase();
            return noteTitle.contains(text);
          }).toList();
        });
      },
    ),
    );
  }

  Widget getCard(item) {
    var name = item['name'];
    var id = item['id'];
    var company = item['company'];
    var orderId = item['orderId'];
    var invoicepaid = item['invoicepaid'];
    var invoicePending = item['invoicePending'];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name.toString(),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10,),
                  Text(id.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10,),
                  Text(company.toString(), style: const TextStyle(fontSize: 16,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold),),
                  const SizedBox(height: 8,),
                  Text(orderId.toString(), style: const TextStyle(fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),),
                  Row(
                    children: <Widget>[
                      Text(invoicePending.toString(), style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),),
                      const SizedBox(width: 8,),
                      Text(invoicePending.toString(), style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (context) => buildSheet(),
                    shape: const  RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                      elevation: 4
                    );
                  },
                  child: const Text('Set Meet'),
              ),
            ],
          ),
        ),
      ),
    );


  }
  Widget buildSheet() => SingleChildScrollView(
    // mainAxisSize: MainAxisSize.min,
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:  const EdgeInsets.all(12.0),
                child:  Text('Schedule the Meet' , style: TextStyle(fontSize: 28 , fontWeight: FontWeight.bold, color: Colors.grey.shade900),),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(onPressed: () {}, child:const Text('Confirm')),
              ),
            ],
          ),
        ),

         Container(
             //color: Colors.grey,
             height: 500,
             width: 400,
             decoration:const  BoxDecoration(
               borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20),),
               color: Colors.grey
             ),
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.fromLTRB(16.0, 16 , 16 , 6),
                   child: ListTile(
                     title: Text("Date: ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}"  , style: TextStyle(fontWeight: FontWeight.bold ,  fontSize: 18),),
                     trailing: Icon(Icons.keyboard_arrow_down),
                     onTap: _pickDate,
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(16.0, 0, 16 , 6),
                   child: ListTile(
                     title: Text("Time: ${time.hour}:${time.minute}"  , style: TextStyle(fontWeight: FontWeight.bold ,  fontSize: 18),),
                     trailing: Icon(Icons.keyboard_arrow_down),
                     onTap: _pickTime,
                   ),
                 ),
                const  Padding(
                   padding: EdgeInsets.all(16.0),
                   child:  Text('Is anyone else coming?' , style: TextStyle(fontWeight: FontWeight.bold ,  fontSize: 28),),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: ElevatedButton(onPressed: () {}, child:const Text('Add')),
                 ),

               ],
             ))
      ],
    ),
  );
  _pickDate() async
  {
      DateTime? date = await showDatePicker(context: (context), initialDate: pickedDate, firstDate: DateTime(DateTime.now().year - 5), lastDate:DateTime(DateTime.now().year +5 5) );

      if(date!=null)
        {
          setState(() {
            pickedDate = date;
          });
        }
  }

  _pickTime() async
  {
    TimeOfDay? t = await showTimePicker(context: context, initialTime: time);

    if(t!=null)
    {
      setState(() {
        time = t;
      });
    }
  }
}
