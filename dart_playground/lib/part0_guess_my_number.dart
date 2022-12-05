import 'dart:io';
import 'dart:math';

void main() {
  print("Welcome to Guess My Number");

  int numguesses = 0;
  Random random = new Random();
  int randomNumber = random.nextInt(100) + 1;

  while (true) {
    print("Guess a number between 1-100");
    numguesses += 1;
    final guess = stdin.readLineSync();
    if (guess != null) {
      try {
        int guessasnum = int.parse(guess);
        if (guessasnum < 1 || guessasnum > 100) {
          print("Not a valid number!");
          continue;
        }
        if (guessasnum > randomNumber) {
          print("Too high!");
        } else if (guessasnum < randomNumber) {
          print("Too low!");
        } else if (guessasnum == randomNumber) {
          break;
        }
      } catch (e) {
        print("Not a valid number!");
        continue;
      }
    }
  }

  if (numguesses == 1) {
    print("First try! Nice!");
  } else {
    print("Nice! You guessed correct in $numguesses tries!");
  }
}
