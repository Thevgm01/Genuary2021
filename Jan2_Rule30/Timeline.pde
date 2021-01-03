class Timeline {
  Rules ruleset;
  ArrayList<ArrayList<Boolean>> cells;
  ArrayList<Timeline> children;
  
  int startHeight = 0;
  public int getHeight() { return startHeight + cells.size(); }
  public ArrayList<Boolean> getLastRow() { return cells.get(cells.size() - 1); }
  
  public Timeline() {
    ruleset = new Rules();
    cells = new ArrayList<ArrayList<Boolean>>();
    children = new ArrayList<Timeline>();
    
    ArrayList<Boolean> firstRow = new ArrayList<Boolean>();
    firstRow.add(false);
    firstRow.add(false);
    firstRow.add(true);
    firstRow.add(false);
    firstRow.add(false);
    cells.add(firstRow);
  }
  
  public Timeline(Timeline origin, Rules ruleset) {
    this.ruleset = ruleset;
    cells = new ArrayList<ArrayList<Boolean>>();
    children = new ArrayList<Timeline>();

    startHeight = origin.getHeight();
    cells.add(origin.getLastRow());
  }
  
  public void drawAll(float cellSize, float cellDistance, color cellColor) {
    noStroke();
    fill(cellColor);
    cellColor = color(hue(cellColor) + 31, 255, 255);
    //strokeWeight(cellSize);
    //stroke(cellColor);
    
    pushMatrix();
    translate(0, startHeight * cellDistance, 0);
    for(ArrayList<Boolean> row : cells) {
      pushMatrix();
      translate(-cellDistance * row.size() / 2f, 0, 0);
      for(Boolean cell : row) {
        if(cell)
          box(cellSize);
          //point(0, 0);
        translate(cellDistance, 0, 0);
      }
      popMatrix();
      translate(0, cellDistance, 0);
    }
    popMatrix();
    
    for(Timeline child : children) {
      translate(0, 0, cellDistance); 
      child.drawAll(cellSize, cellDistance, cellColor);
    }
  }
  
  public void advanceAll() {
    for(Timeline child : children) {
      child.advanceAll(); 
    }
    
    ArrayList<Boolean> lastRow = cells.get(cells.size() - 1);
    ArrayList<Boolean> nextRow = new ArrayList<Boolean>();
    nextRow.add(false);
    nextRow.add(false);
    for(int i = 1; i < lastRow.size() - 1; ++i) {
      boolean nextCell = ruleset.getNextCellState(lastRow, i);
      if(!nextCell) {
        Rules newRules = new Rules();
        while(!newRules.getNextCellState(lastRow, i)) {
          newRules.shuffle();
        }
        Timeline newTimeline = new Timeline(this, newRules);
        children.add(newTimeline);
        ++totalWidth;
      }
      nextRow.add(nextCell);
    }
    nextRow.add(false);
    nextRow.add(false);
    cells.add(nextRow);
  }
}
