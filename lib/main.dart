import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

//*******Start of Initializing **************/
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new firstScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String,WidgetBuilder>{
        '/newExpense':(context)=>newExpense(),
        '/viewExpense':(context)=>viewExpense(),
        '/categories':(context)=>categories()
      },
    );
  }
}
//*******End of Initializing **************/

//*******Start of Home Page **************/
class firstScreen extends StatefulWidget{
  firstScreenShow createState()=> firstScreenShow();
}

class firstScreenShow extends State<firstScreen>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Home Page"),),
      body: 
      new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 12.0
        ),
        
        child: new Column(
            children: [
              new Row(
                children:[
                  FlatButton(
                    child: Text("New Expense",
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.pushNamed(context, '/newExpense');
                    },
                  )
                ]), 
                new Row(
                children:[
                 FlatButton(
                    child: Text("View Expense",
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.pushNamed(context, '/viewExpense');
                    },
                  )
                ]), 
                new Row(
                children:[
                 FlatButton(
                    child: Text("Categories",
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.pushNamed(context, '/categories');
                    },
                  )
                ]), 
          ],),

      )
    );
  }

}
//*******End of Home Page **************/

//*******Start of New Expense Page **************/
class newExpense extends StatefulWidget{
  newExpenseShow createState()=> newExpenseShow();
}

class newExpenseShow extends State<newExpense>{

  String expTitle = "";
  double expAmount = 0.0;
  DateTime _dateTime = DateTime.now();
  // var listDrop = ["Gas","Mileage","Repairs"];
  var listDrop = <String>[];
  var currentItemSelected = "Gas";

  @override
  void initState(){
    getData();
  }

  getData() async{
    String url = 'https://expenseflutterapp.000webhostapp.com/expense/combofill.php';
    var res = await http.get(Uri.encodeFull(url),headers:{"Accept":"application/json"});
    var responsebody = json.decode(res.body.toString());
    for(int i=0;i<responsebody.length;i++){
      listDrop.add(responsebody[i]['category_name'].toString());
    }
    print(listDrop);
    // currentItemSelected = listDrop[0];
  }

  insertExpenseData() async{
    String url = 'https://expenseflutterapp.000webhostapp.com/expense/insertExpense.php';
    var res = await http.post(Uri.encodeFull(url),headers:{"Accept":"application/json"},
    body:{
      'title':expTitle,
      'amount':expAmount.toString(),
      'date':_dateTime.toString(),
      'category':currentItemSelected,
    });
    var responsebody = json.decode(res.body);
    print(responsebody);
     if(responsebody==true){
      // print(responsebody);
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text('Item Added'),
          );
      });
    }else if(responsebody == false){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text('Item Not Added'),
          );
      });
    }

  }

  
  @override
  Widget build(BuildContext context) {
  
    return new Scaffold(
      appBar: AppBar(title: Text("New Expense"),centerTitle: true),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text("Add A New Expense",
              style: TextStyle(
              fontSize:30,
              fontWeight: FontWeight.bold,
              ),),
              new TextField(
                decoration: new InputDecoration(
                  hintText: "Enter Title of Expense",
                ),
                onChanged: (String title){
                  setState((){
                    expTitle = title;
                  });
                },
              ),
              
              new TextField(
                decoration: new InputDecoration(
                  hintText: "Amount of Expense"
                ),
                onChanged: (String amount){
                  setState((){
                    expAmount = double.parse(amount);
                  });
                },
              ),
              DropdownButton<String>(
                hint: Text('Choose a Category'),
                items: listDrop.map((String dropDownStringItem){
                  return DropdownMenuItem<String>(
                    value:dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),

                onChanged: (String newValueSelected){
                  setState((){
                    currentItemSelected = newValueSelected;
                  });
                },

                value:currentItemSelected,
                
              ),
              new FlatButton(
                child: Text("Add Expense"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      if( expTitle != "" && expAmount != 0.0){
                        insertExpenseData();
                        // Navigator.pushNamed(context, '/newExpense');
                      }
                      else{
                        showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 1), () {
                              // Navigator.pushNamed(context, '/newExpense');
                            });
                            return AlertDialog(
                              title: Text('Fields Empty'),
                            );
                        });
                      } 
                    },
              )
            ],
          ),
        ),
      )
    );
  }
}
//*******End of New Expense Page **************/

//*******Start of View Expense Page **************/
class viewExpense extends StatefulWidget{
  viewExpenseShow createState()=> viewExpenseShow();
}

class viewExpenseShow extends State<viewExpense>{

  getData() async{
    String url = 'https://expenseflutterapp.000webhostapp.com/expense/viewExpenses.php';
    var res = await http.get(Uri.encodeFull(url),headers:{"Accept":"application/json"});
    var responsebody = json.decode(res.body);
    return responsebody;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Expenses"),centerTitle: true),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          List snap = snapshot.data;

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text("Error Fetching Data"),
            );
          }

          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context,index){
              return ListTile(
                title: Text("Expense Title: ${snap[index]['expense_title']}"),
                subtitle: Text("Expense Amount: ${snap[index]['expense_amount']}\n"+
                "Expense Date:${snap[index]['expense_date']}\n"+"Category Name:${snap[index]['category_name']}"),
              );
            },
          );
        },
      )
    );
  }
}
//*******End of View Expense Page **************/

//*******Start of Categories Page **************/
class categories extends StatefulWidget{
  categoriesShow createState()=> categoriesShow();
}

class categoriesShow extends State<categories>{

  String status = "";

  getData() async{
    String url = 'https://expenseflutterapp.000webhostapp.com/expense/viewCategories.php';
    var res = await http.get(Uri.encodeFull(url),headers:{"Accept":"application/json"});
    var responsebody = json.decode(res.body);
    return responsebody;
  }

  insertData(String categoryName) async{
    String url = 'https://expenseflutterapp.000webhostapp.com/expense/insertCategory.php?catyname='+categoryName+'';
    var res = await http.get(Uri.encodeFull(url),headers:{"Accept":"application/json"});
    var responsebody = json.decode(res.body);
    
    if(responsebody==true){
      // print(responsebody);
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text('Item Added'),
          );
      });
    }else if(responsebody == false){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text('Item Not Added'),
          );
      });
    }
  }

  Future<void> addData(BuildContext context) {
    String categoryname = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                labelText: 'Category Name', hintText: 'eg. gas'),
                onChanged: (value) {
                  categoryname = value;
                },
              )),
              new Text(status)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                // Navigator.of(context).pop(teamName);
                if(categoryname != ""){
                  insertData(categoryname);
                  // Navigator.pushNamed(context, '/categories');
                  // Navigator.of(context).pop(true);
                }
                else{
                  showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 5), () {
                        // Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Text('Field Empty'),
                      );
                  });
                } 
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Categories"),
      actions: <Widget>[
          RaisedButton(
            onPressed: () {
                addData(context);
                // print(status);
            },
            child: Text("+ Add Category ",
            style: TextStyle(fontSize: 16),
          ),
          // shape: RectangluarBorder(side: BorderSide(color: Colors.white)),
        ),
      ],),
      body: 
      new Container(
        child: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              List snap = snapshot.data;

              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.hasError){
                return Center(
                  child: Text("Error Fetching Data"),
                );
              }

              return ListView.builder(
                itemCount: snap.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text("Category Name: ${snap[index]['category_name']}"),
                  );
                },
              );
            },
          )
      )
    );
  }
}
//*******End of Categories Page **************/
