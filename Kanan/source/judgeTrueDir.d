module Kanan.judgeTrueDir;

bool trueDir(int[] whichAgent, ulong fieldX, ulong fieldY, int dir) {
  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];

  if (whichAgent[0] + dx[dir] < 0)
    return false;
  else if (fieldX <= whichAgent[0] + dx[dir])
    return false;
  else if (whichAgent[1] + dy[dir] < 0)
    return false;
  else if (fieldY <= whichAgent[1] + dy[dir])
    return false;

  return true;
}
