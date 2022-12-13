import 'dart:ffi';
import 'dart:io';
import 'package:test/test.dart';

enum Mark { x, o, none }

enum GameState { xTurn, oTurn, xWon, oWon, tie }

class TicTacToeGame {
  var board = List.filled(9, Mark.none);
  GameState state = GameState.xTurn;

  void selectSquare(int index) {
    if (index < 0 || index > 8) {
      return;
    }
    if (board[index] != Mark.none ||
        state == GameState.xWon ||
        state == GameState.oWon ||
        state == GameState.tie) {
      return;
    }

    if (state == GameState.xTurn) {
      board[index] = Mark.x;
      state = GameState.oTurn;
    } else {
      board[index] = Mark.o;
      state = GameState.xTurn;
    }
    checkBoard();
  }

  void checkBoard() {
    String winconsstring =
        "${board[0]}${board[1]}${board[2]}|${board[3]}${board[4]}${board[5]}|${board[6]}${board[7]}${board[8]}|${board[0]}${board[3]}${board[6]}|${board[1]}${board[4]}${board[7]}|${board[2]}${board[5]}${board[8]}|${board[0]}${board[4]}${board[8]}|${board[2]}${board[4]}${board[6]}";

    if (winconsstring.contains("Mark.xMark.xMark.x")) {
      state = GameState.xWon;
      return;
    } else if (winconsstring.contains("Mark.oMark.oMark.o")) {
      state = GameState.oWon;
      return;
    } else if (!board.contains(Mark.none)) {
      state = GameState.tie;
      return;
    }
    return;
  }

  String boardAsString() {
    String boardString = "";
    for (int i = 0; i < 3; i++) {
      boardString += "|";
      for (int j = 0; j < 3; j++) {
        if (board[3 * i + j] == Mark.x) {
          boardString += "x";
        } else if (board[3 * i + j] == Mark.o) {
          boardString += "o";
        } else {
          boardString += " ";
        }
        boardString += "|";
      }
      boardString += "\n";
    }
    return boardString;
  }

  String stateString() {
    String statestring = "";
    if (state == GameState.xTurn) {
      statestring = "X's Turn";
    } else if (state == GameState.oTurn) {
      statestring = "O's Turn";
    } else if (state == GameState.xWon) {
      statestring = "X Wins!";
    } else if (state == GameState.oWon) {
      statestring = "O Wins!";
    } else if (state == GameState.tie) {
      statestring = "It's A Tie!";
    }
    return statestring;
  }
}

void main() {
  TicTacToeGame game = new TicTacToeGame();
  print("Testing TicTacToeGame");
  while (true) {
    print("\n${game.stateString()}");
    print(game.boardAsString());
    if (game.state == GameState.oTurn || game.state == GameState.xTurn) {
      print("Which square do you wish to play?");
      final takeTurn = stdin.readLineSync();
      try {
        if (takeTurn != null) {
          int picked = int.parse(takeTurn);
          game.selectSquare(picked);
        }
      } catch (e) {}
    } else {
      print("Good Game!");
      break;
    }
  }
}
