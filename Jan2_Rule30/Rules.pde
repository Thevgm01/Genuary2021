class Rules {
  private boolean[] ruleset;

  public Rules() {
    ruleset = new boolean[] { false, false, false, true, true, true, true, false };
  }
  
  public void shuffle() {
    for(int i = 7; i >= 0; --i) {
       int index = (int)random(i + 1);
       
       boolean temp = ruleset[index];
       ruleset[index] = ruleset[i];
       ruleset[i] = temp;
    }
  }
  
  public void randomize() {
    ruleset = new boolean[8];
    for(int i = 0; i < 8; ++i)
      ruleset[i] = random(1) > 0.5f;
  }
  
  public boolean getNextCellState(ArrayList<Boolean> list, int centerIndex) {
    boolean[] neighbors = { list.get(centerIndex - 1), list.get(centerIndex), list.get(centerIndex + 1) };
    for(int i = 0; i < 8; ++i) {
       if(neighbors[0] == cellPattern[i][0] &&
          neighbors[1] == cellPattern[i][1] &&
          neighbors[2] == cellPattern[i][2])
         return ruleset[i];
    }
    return false; // Should never get here
  }
}
