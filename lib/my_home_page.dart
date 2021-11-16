// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myxotestgame/custome_dialog.dart';
import 'package:myxotestgame/game_button.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;
  int nt = 3, ntt = 1;
  double screen = 0;
  double hscreen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    int ntt = nt * nt, i = 1;
    player1 = [];
    player2 = [];
    activePlayer = 1;
    var gameButton = <GameButton>[];
    while (i <= ntt) {
      gameButton.add(GameButton(id: i));
      i++;
    }
    print("Number of nt = $nt");
    return gameButton;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();

      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
              context: context,
              builder: (_) => new CustomDialog("Game Tied",
                  "Press the reset button to start again.", resetGame));
        } else {
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = [];
    var list = new List.generate(nt * nt, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p) => p.id == cellID);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    var winner = -1;

    for (var i = 1; i < nt * nt; i++) {
      if (player1.contains(i) && player1.contains(i + i)) {}
    }
    //row 1
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("Player 1 Won",
                "Press the reset button to start again.", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("Player 2 Won",
                "Press the reset button to start again.", resetGame));
      }
    }

    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  Container buildReset() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: screen * 0.75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () {
          resetGame();
        },
        child: Text("Reset"),
      ),
    );
  }

  Container buildDimention(double screen) => Container(
      decoration: BoxDecoration(
          color: Colors.white54, borderRadius: BorderRadius.circular(25)),
      margin: EdgeInsets.only(top: 10),
      width: screen * 0.75,
      //height: screen * 0.15,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (String string) {
          nt = int.parse(string);
          if (nt <= 0) {
            nt = 3;
            showDialog(
                context: context,
                builder: (_) => new CustomDialog("Dimention must in Positive",
                    "Press the reset button to start again.", resetGame));
          } else {
            resetGame();
          }
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter Number of Dimention XO',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.green)),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    hscreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("XO"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: buttonsList.length,
              itemBuilder: (context, i) => SizedBox(
                width: 100.0,
                height: hscreen * 0.80,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(onPrimary: Colors.black),
                    onPressed: buttonsList[i].enabled
                        ? () => playGame(buttonsList[i])
                        : null,
                    child: Text(
                      buttonsList[i].text,
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: nt, //ค่ารับเข้าจำนวนเมตริก
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5),
            ),
          ),
          buildDimention(screen),
          buildReset()
        ],
      ),
    );
  }
}
