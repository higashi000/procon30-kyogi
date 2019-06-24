module Kanan.judgeTrueDir;

bool trueDir(int[] whereAgent, ulong fieldX, ulong fieldY, int dir) {
  static immutable int[] dx = [-1, -1, 0, 1, 1, 1, 0, -1];
  static immutable int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];

  if (whereAgent[0] + dx[dir] < 0)
    return false;
  else if (fieldX <= whereAgent[0] + dx[dir])
    return false;
  else if (whereAgent[1] + dy[dir] < 0)
    return false;
  else if (fieldY <= whereAgent[1] + dy[dir])
    return false;

  return true;
}
