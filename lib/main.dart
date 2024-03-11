import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tictactoe/logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const Toe(),
    );
  }
}

class Toe extends StatefulWidget {
  const Toe({Key? key}) : super(key: key);

  @override
  _ToeState createState() => _ToeState();
}

class _ToeState extends State<Toe> {
  List<List<int>> table = List.generate(3, (useless) => List.filled(3, 0));
  bool aiMoving = false;
  bool aiFirst = false;
  bool aiFirstRunOnce = false;
  bool settingsOpen = false;
  int winningPlayer = -1;
  double difficulty = -1;
  @override
  Widget build(BuildContext context) {
    if (aiFirstRunOnce) {
      setState(() {
        aiFirstRunOnce = false;

        aiMoving = true;
      });
      List<int> aiMove = bestMove(table, difficulty);
      Timer(const Duration(milliseconds: 750), () {
        setState(() {
          table[aiMove[0]][aiMove[1]] = 2;
          aiMoving = false;
        });
      });
    }
    if (winningPlayer == -1 &&
        (isFinished(table) != 0 ||
            !table.any((element) => element.any((element) => element == 0)))) {
      winningPlayer = isFinished(table);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("TicTacToe"),
        actions: [
          settingsOpen
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      settingsOpen = false;
                    });
                  },
                  icon: const Icon(Icons.close),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      settingsOpen = true;
                    });
                  },
                  icon: const Icon(Icons.settings),
                ),
        ],
      ),
      body: settingsOpen
          ? Column(
              children: [
                Text(
                  "Difficulty:",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.shortestSide / 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ink(
                      height: MediaQuery.of(context).size.shortestSide / 10,
                      width: MediaQuery.of(context).size.shortestSide / 4,
                      color: difficulty == -1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "Dumb",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 15,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            difficulty = -1;
                          });
                        },
                      ),
                    ),
                    Ink(
                      height: MediaQuery.of(context).size.shortestSide / 10,
                      width: MediaQuery.of(context).size.shortestSide / 4,
                      color: difficulty == 1 / 16
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "Easy",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 15,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            difficulty = 1 / 16;
                          });
                        },
                      ),
                    ),
                    Ink(
                      height: MediaQuery.of(context).size.shortestSide / 10,
                      width: MediaQuery.of(context).size.shortestSide / 4,
                      color: difficulty == 1 / 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "Normal",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 15,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            difficulty = 1 / 2;
                          });
                        },
                      ),
                    ),
                    Ink(
                      height: MediaQuery.of(context).size.shortestSide / 10,
                      width: MediaQuery.of(context).size.shortestSide / 4,
                      color: difficulty == 10
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "Hard",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 15,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            difficulty = 10;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  "First player:",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.shortestSide / 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ink(
                      height: MediaQuery.of(context).size.shortestSide / 10,
                      width: MediaQuery.of(context).size.shortestSide / 5,
                      color: !aiFirst
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "Player",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 15,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            aiFirst = false;
                            winningPlayer = -1;
                            table = List.generate(
                                3, (useless) => List.filled(3, 0));
                          });
                        },
                      ),
                    ),
                    Ink(
                      height: MediaQuery.of(context).size.shortestSide / 10,
                      width: MediaQuery.of(context).size.shortestSide / 5,
                      color: aiFirst
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "AI",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 15,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            aiFirst = true;
                            winningPlayer = -1;
                            aiFirstRunOnce = true;
                            table = List.generate(
                                3, (useless) => List.filled(3, 0));
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        3,
                        (j) => Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.shortestSide / 100),
                          child: Ink(
                            height:
                                MediaQuery.of(context).size.shortestSide / 4 -
                                    15,
                            width:
                                MediaQuery.of(context).size.shortestSide / 4 -
                                    15,
                            color: Theme.of(context).colorScheme.background,
                            child: InkWell(
                              child: Center(
                                child: Text(
                                  getLetter(table[i][j]),
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                            .size
                                            .shortestSide /
                                        10,
                                  ),
                                ),
                              ),
                              onTap: !aiMoving && table[i][j] == 0
                                  ? () {
                                      setState(() {
                                        table[i][j] = 1;
                                        aiMoving = true;
                                      });
                                      List<int> aiMove =
                                          bestMove(table, difficulty);
                                      if (aiMove.isNotEmpty) {
                                        Timer(const Duration(milliseconds: 750),
                                            () {
                                          setState(() {
                                            table[aiMove[0]][aiMove[1]] = 2;
                                            aiMoving = false;
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          winningPlayer = isFinished(table);
                                        });
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  if (winningPlayer != -1) {
                    String text = winningPlayer == 0
                        ? "Tied"
                        : "${getLetter(winningPlayer)} won";
                    return Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.shortestSide / 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide / 15,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left:
                                  MediaQuery.of(context).size.shortestSide / 20,
                            ),
                            child: Ink(
                              height:
                                  MediaQuery.of(context).size.shortestSide / 10,
                              width:
                                  MediaQuery.of(context).size.shortestSide / 3,
                              color: Theme.of(context).colorScheme.background,
                              child: InkWell(
                                child: Center(
                                  child: Text(
                                    "Play Again",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .shortestSide /
                                          15,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    aiFirstRunOnce = aiFirst;
                                    table = List.generate(
                                        3, (useless) => List.filled(3, 0));
                                    winningPlayer = -1;
                                    aiMoving = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                })
              ],
            ),
    );
  }
}
