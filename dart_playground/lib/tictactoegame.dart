import 'dart:ffi';
import 'dart:io';

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

  void checkBoard() {}

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
}

void main() {
  TicTacToeGame game = new TicTacToeGame();
  print("Testing TicTacToeGame");
  while (true) {
    print(game.state);
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
    }
  }
}
