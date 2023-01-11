import 'dart:math';

enum GameState { active, win }

class LightsOutGame {
  final int numLights;
  int turns = 0;
  GameState state = GameState.active;
  var linearlights;

  LightsOutGame(this.numLights) {
    linearlights = List.filled(numLights, false);
    var rng = Random();
    for (int index = 0; index < numLights; index++) {
      if (rng.nextInt(2) == 0) {
        fliplight(index - 1);
        fliplight(index);
        fliplight(index + 1);
      }
    }
    if (lightCount() == 0) {
      fliplight(0);
      fliplight(1);
    }
  }

  void selectLight(int index) {
    if (index < 0 || index >= numLights || state == GameState.win) {
      return;
    }
    fliplight(index - 1);
    fliplight(index);
    fliplight(index + 1);
    turns++;
    winCheck();
  }

  void fliplight(int index) {
    if (index < 0 || index >= numLights) {
      return;
    } else if (linearlights[index] == true) {
      linearlights[index] = false;
    } else {
      linearlights[index] = true;
    }
  }

  int lightCount() {
    int count = 0;
    for (int i = 0; i < numLights; i++) {
      if (linearlights[i] == true) {
        count += 1;
      }
    }
    return count;
  }

  void winCheck() {
    int lightcount = lightCount();
    if (lightcount == 0) {
      state = GameState.win;
    }
    return;
  }

  String stateString() {
    String statestring = "";
    if (state == GameState.active) {
      if (turns == 0) {
        statestring = "Try to turn off all the lights";
      } else {
        statestring = "Num Moves = $turns";
      }
    } else if (state == GameState.win) {
      if (turns == 1) {
        statestring = "You won in only 1 turn!";
      } else {
        statestring = "You won in $turns turns!";
      }
    }
    return statestring;
  }
}
