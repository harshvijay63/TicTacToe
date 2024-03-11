int isFinished(List<List<int>> table) {
  if (table[0][0] == 1 && table[1][1] == 1 && table[2][2] == 1) {
    return 1;
  }
  if (table[0][0] == 2 && table[1][1] == 2 && table[2][2] == 2) {
    return 2;
  }
  if (table[2][0] == 1 && table[1][1] == 1 && table[0][2] == 1) {
    return 1;
  }
  if (table[2][0] == 2 && table[1][1] == 2 && table[0][2] == 2) {
    return 2;
  }
  for (int i = 0; i < 3; i++) {
    if (table[i][0] == 1 && table[i][1] == 1 && table[i][2] == 1) {
      return 1;
    }
    if (table[i][0] == 2 && table[i][1] == 2 && table[i][2] == 2) {
      return 2;
    }
    if (table[0][i] == 1 && table[1][i] == 1 && table[2][i] == 1) {
      return 1;
    }
    if (table[0][i] == 2 && table[1][i] == 2 && table[2][i] == 2) {
      return 2;
    }
  }
  return 0;
}

String getLetter(int x) {
  if (x == 1) return "X";
  if (x == 2) return "O";
  return "";
}

List<int> bestMove(List<List<int>> table, double difficulty) {
  int? imax, jmax;
  double? valmax;
  List<List<double>> scores = List.generate(3, (useless) => List.filled(3, -1));
  if (isFinished(table) != 0) return [];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (table[i][j] == 0) {
        table[i][j] = 2;
        double val = getMoveScore(table, 1, difficulty);
        val *= (i == 1 || j == 1) && i != j ? 1.1 : 1;
        table[i][j] = 0;
        scores[i][j] = val;
        if (valmax == null || valmax < val) {
          imax = i;
          jmax = j;
          valmax = val;
        }
      }
    }
  }
  // ignore: avoid_print
  print(scores);
  if (imax == null) {
    return [];
  } else {
    return [imax, jmax!];
  }
}

double getMoveScore(List<List<int>> table, int player, double difficulty) {
  if (isFinished(table) == 2) return difficulty;
  if (isFinished(table) == 1) return -difficulty;
  double sum = 0;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (table[i][j] == 0) {
        table[i][j] = player;
        double val = getMoveScore(table, player == 1 ? 2 : 1, difficulty);
        sum += val / difficulty;
        table[i][j] = 0;
      }
    }
  }
  return sum;
}
