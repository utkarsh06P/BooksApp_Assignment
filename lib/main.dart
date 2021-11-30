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

  void initState()
  {
    super.initState();
    this.fetchUser();
  }
  fetchUser() async
  {
    var url = "https://run.mocky.io/v3/f3feef1c-9bfa-43fd-b2a0-bbe9abadb4f6";
    var response = await http.get(Uri.parse(url));

    if(response.statusCode == 200)
      {
        var items = json.decode(response.body)['clients'];
        setState(() {
          users = items;
        });
      }
    else
      {
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
  Widget getBody()
  {
    return ListView.builder(  itemCount: users.length , itemBuilder: (content, index){
      return getCard(users[index]);
    });
  }
  Widget getCard(item)
  {

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
            children: <Widget>[

             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Text( name.toString() , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.bold),
                 ),
                 const SizedBox( height: 10,),
                 Text(id.toString() , style: const  TextStyle(fontSize: 12 , color: Colors.grey),
                 ),
                 const SizedBox( height: 10,),
                 Text( company.toString() , style: const TextStyle(fontSize: 16 , color: Colors.lightBlueAccent , fontWeight: FontWeight.bold), ),
                 const SizedBox( height: 8,),
                 Text(  orderId.toString() , style: const TextStyle(fontSize: 16 , color: Colors.grey , fontWeight: FontWeight.bold), ),
                 Row(
                   children: <Widget>[
                     Text( invoicePending.toString() , style: const TextStyle(fontSize: 16 , color: Colors.grey , fontWeight: FontWeight.bold), ),
                     const SizedBox( width: 8,),
                     Text( invoicePending.toString() , style: const TextStyle(fontSize: 16 , color: Colors.grey , fontWeight: FontWeight.bold), ),
                   ],
                 )
               ],
             ),
            ],
          ),
        ),
      ),
    );
  }

}

