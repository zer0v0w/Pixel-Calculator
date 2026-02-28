import 'dart:convert';

import 'package:flutter/material.dart';

import "package:google_fonts/google_fonts.dart";
import 'package:provider/provider.dart';

import 'package:http/http.dart' ;




void main() {
  runApp( ChangeNotifierProvider(      create: (context) => appsate(),
  child: MyApp(),));
}



enum op { add, div , mul, sub }


class appsate extends ChangeNotifier{
  double result = 0;
  String eq = "";

  bool isFirstNumber = true;
  double FirstNumber = 0;
  double SecNumber = 0;

  op operator = op.add;




  void AddNumber(double x){

    switch (isFirstNumber){

      case true:
          FirstNumber = x;
          isFirstNumber = false;
        break;
      case false:

          SecNumber = x;
          isFirstNumber = true;


        break;

    }

    notifyListeners();
  }

  void setOp(op x){
      operator = x;



      switch(operator){

        case op.add:
          eq = "+"; break;
        case op.div:
          eq = "/"; break;

        case op.mul:
          eq = "x"; break;

        case op.sub:
          eq = "-"; break;

      }

      notifyListeners();


  }

  Future<void> resultGet()async {
    MylovlyBack back = MylovlyBack();

    switch(operator){

      case op.add:

        result = await back.add(FirstNumber, SecNumber);
        print(operator) ;
        notifyListeners();

        break;
      case op.div:
        result = await  back.div(FirstNumber, SecNumber);
        notifyListeners();

        break;

      case op.mul:
        result = await   back.mul(FirstNumber, SecNumber);
        notifyListeners();

        break;

      case op.sub:
        result = await  back.sub(FirstNumber, SecNumber);
        notifyListeners();

        break;

    }
  }

  @override
  notifyListeners();

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'calc',
      home: const MyHomePage(),
    );
  }
}



class MylovlyBack {

  final String base = "http://localhost:8080";

  Future<double> sub (double first , double sec) async {
    final response = await get(Uri.parse("$base/calculator/subtract?firstNumber=$first&secoundNumber=$sec"));

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);
      return data;
    }
    else{
      print("${response.statusCode} + ${"$base/calculator/subtract?firstNumber=$first&secoundNumber=$sec"} ");
      return 0;
    }

  }

  Future<double> mul (double first , double sec) async {
    final response = await get(Uri.parse("$base/calculator/multiply?firstNumber=$first&secoundNumber=$sec"));

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);
      return data;
    }
    else{
      print("fail");
      return 0;
    }

  }

  Future<double> add (double first , double sec) async {
    final response = await get(Uri.parse("$base/calculator/add?firstNumber=$first&secoundNumber=$sec"));

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);
      print(data);
      return data;
    }
    else{
      print("${response.statusCode} + ${"$base/calculator/add?firstNumber=${first.toInt()}&secoundNumber=${sec.toInt()}"} ");
      return 0;
    }

  }

  Future<double> div (double first , double sec) async {
    final response = await get(Uri.parse("$base/calculator/divide?firstNumber=$first&secoundNumber=$sec"));

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);
      return data;
    }
    else{
      print("fail");
      return 0;
    }

  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.widthOf(context);
    final double height = MediaQuery.heightOf(context);

    final appsate state = appsate();



    final double result = context.watch<appsate>().result;
    final double FirstNumber = context.watch<appsate>().FirstNumber;
    final double SecNumber = context.watch<appsate>().SecNumber;
    final String eq = context.watch<appsate>().eq;


    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 0, 71, 255),

      body: Stack(
        children: [
          SizedBox(
            height: height*0.001,
            child: Column(children: [
              Image.asset("assets/bakc.png"),
              Image.asset("assets/bakc.png"),
            ],),
          ),
          Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [

              OutputView(result: result, eq:  eq , secNumber : SecNumber , firstNumber : FirstNumber,),
              Spacer(),
              SizedBox(width: width * 0.8, child: ButtonsDail()),


            ],
          ),
        ],
      )
    );
  }
}





class PixelButton extends StatefulWidget {

  final String textN;
  final op operator;
  final bool isNum;
  const PixelButton({super.key, required this.textN, required this.operator, required this.isNum});

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool state = true;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final  result = context.watch<appsate>();

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          state = false;
        });

      },

      onTapCancel: () {
        setState(() {
          state = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          state = true;
        });
        print("hl");


        switch(widget.isNum){

          case true:
            result.AddNumber(double.parse(widget.textN));

          case false:
          if(widget.textN == "="){
            result.resultGet();
          }
          else{
            result.setOp(widget.operator);
          }
        }

      },
      child: SizedBox(
        width: 120,
        height: 120,
        child: Center(
          child: Stack(
            fit: StackFit.expand,

            children: [
              Center(
                child: Image.asset(
                  state ? "assets/onBut.png" : "assets/offBut.png",
                ),
              ),
              Center(child: Text(widget.textN , style: GoogleFonts.tiny5(  color: state? Colors.white : Colors.grey , fontSize: state ? size.width * 0.08 : size.width * 0.07),)),

            ],
          ),
        ),
      ),
    );
  }
}



class OutputView extends StatelessWidget {
  final String eq ;
  final double result;
  final  double secNumber;
  final  double firstNumber;
  const OutputView({super.key, required this.result, required this.eq, required this.secNumber, required this.firstNumber});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.widthOf(context);
    final double height = MediaQuery.widthOf(context);

    final appsate state = context.watch<appsate>();
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      width: width,
      height: height/3,
      child: Stack(
        children: [
          Image.asset("assets/cacB.png" , scale: 0.5,),
          Padding(
            padding:  EdgeInsets.fromLTRB(96* (width*0.001) ,40* (width*0.0015),0,0),
            child: Row(children: [
              Text(firstNumber.toString() , style: GoogleFonts.tiny5(fontSize: 40 * (width*0.0015) , color: state.isFirstNumber? Colors.purpleAccent : Colors.purpleAccent.withAlpha(150) ),),
              Text(eq , style: GoogleFonts.tiny5(fontSize: 40 * (width*0.0015) , color: Colors.purpleAccent),),
              Text(secNumber.toString() , style: GoogleFonts.tiny5(fontSize: 40 * (width*0.0015) , color: !state.isFirstNumber? Colors.purpleAccent : Colors.purpleAccent.withAlpha(150)),),
            ],),
          ),
          Center(child: Text(result.toString() , style: GoogleFonts.tiny5(fontSize: 64 * (width*0.0015) , color: Colors.white),)),
        ],
      ),
    );
  }
}


class ButtonsDail extends StatelessWidget {


  const ButtonsDail({super.key,  });

  @override
  Widget build(BuildContext context) {
    final appsate state = context.watch<appsate>();

    return Column(
      children: [
        Row(
          children: [
            PixelButton(textN: "X", operator: op.mul, isNum: false , ),
            PixelButton(textN: "/", operator: op.div, isNum: false , ),
            PixelButton(textN: "+", operator: op.add, isNum: false , ),
          ],
        ),
        Row(
          children: [
            PixelButton(textN: "7", operator: op.add, isNum: true, ),
            PixelButton(textN: "8", operator: op.add, isNum: true, ),
            PixelButton(textN: "9", operator: op.add, isNum: true, ),
          ],
        ),
        Row(
          children: [
            PixelButton(textN: "4", operator: op.add, isNum: true, ),
            PixelButton(textN: "5", operator: op.add, isNum: true, ),
            PixelButton(textN: "6", operator: op.add, isNum: true, ),
          ],
        ),
        Row(
          children: [
            PixelButton(textN: "1", operator: op.add, isNum: true, ),
            PixelButton(textN: "2", operator: op.add, isNum: true, ),
            PixelButton(textN: "3", operator: op.add, isNum: true, ),

          ],
        ),
        Row(
          children: [
            PixelButton(textN: "-", operator: op.sub, isNum: false , ),
            PixelButton(textN: "0", operator: op.add, isNum: true, ),
            PixelButton(textN: "=", operator: op.add, isNum: false , ),
          ],
        ),
      ],
    );
  }
}


