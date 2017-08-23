boolean blacksturn;
boolean legality;
Space[][] grid;

void setup(){
  size(800,800);
  blacksturn = true;
  legality = false;
  grid = new Space[8][8];
  for(Space[] arr : grid){
    for(int x = 0;x < arr.length;x ++)
      arr[x] = new Space();
  }
  grid[3][3].empty = false;
  grid[4][4].empty = false;
  grid[3][4].empty = false;
  grid[4][3].empty = false;
  grid[3][3].piece = new Piece("black",3,3);
  grid[4][4].piece = new Piece("black",4,4);
  grid[3][4].piece = new Piece("white",3,4);
  grid[4][3].piece = new Piece("white",4,3);
  drawGrid();
}

void drawGrid(){
  
  for(int row = 0;row < grid.length;row ++){
    for(int col = 0;col < grid[row].length;col ++){
      fill(0,100,0);
      rect(col * 100, row * 100, 100, 100);
      
      if( !grid[row][col].empty ){
        if( grid[row][col].piece._color.equals("white") )
          fill(255);
        else
          fill(0);          
        ellipse(col * 100 + 50,row * 100 + 50, 75, 75);
      }
      
    }
  }
}

void mouseClicked(){
  //Boolean legality = false;
  int row = mouseY / 100;
  int col = mouseX / 100;
  if(grid[row][col].empty){
    grid[row][col].empty = false;
    if(blacksturn)
      grid[row][col].piece = new Piece("black",row,col);
    else
      grid[row][col].piece = new Piece("white",row,col);
  /*
  legality = legality || VerticalFlips(row,col);
  legality = legality || HorizontalFlips(row,col);
  legality = legality || DiagonalFlips(row,col);
  */
    VerticalFlips(row,col,false);
    HorizontalFlips(row,col,false);
    DiagonalFlips(row,col,false);
    if(!legality){
      grid[row][col].piece = null;
      grid[row][col].empty = true;
    }
    else{
      legality = false;
      blacksturn = !blacksturn;
    }
  }
  
  if(blacksturn)
    print(movesLeft("black"));
  else
    print(movesLeft("white"));
    
  //print(VerticalFlips(row,col));
  //print(HorizontalFlips(row,col));
  //print(DiagonalFlips(row,col));
}

void VerticalFlips(int row,int col,boolean testing){ //flipping pieces in the same column
  Boolean flipsMade = false;
  //Boolean flipsFromBelow = false;
  String ownColor = grid[row][col].piece._color;
  //initialize as inputted piece to avoid chance of no initialization
  Piece closestFromAbove = grid[row][col].piece; //closest piece of same color above inputted piece
  Piece closestFromBelow = grid[row][col].piece;
  for(int u = 0;u < row;u ++){ //iterate from top of board to inputted piece
    if( !grid[u][col].empty && grid[u][col].piece._color.equals(ownColor))
      closestFromAbove = grid[u][col].piece;
  }
  boolean noBreaks = true; //whether all spaces between inputted piece and cFA are occupied
  //if(closestFromAbove != null){
    for(int u = closestFromAbove.y + 1;u < row;u ++){
      noBreaks = noBreaks && !grid[u][col].empty;
    }
    //if( !noBreaks || closestFromAbove.equals(grid[row][col].piece) )
      //flipsFromAbove = false;
    if(noBreaks){ //if no empty spaces, then they must be occupied by enemy color
      for(int u = closestFromAbove.y + 1;u < row;u ++){
        flipsMade = true;
        if(!testing) //if VerticalFlips is called to see if legal moves are left, don't actually flip anything
          grid[u][col].piece._color = ownColor; //flip em
      }
    }
  //}
  for(int d = grid.length - 1;d > row;d --){ //iterate from bottom of board to inputted piece
    if( !grid[d][col].empty && grid[d][col].piece._color.equals(ownColor))
      closestFromBelow = grid[d][col].piece;
  }
  noBreaks = true;
  //if(closestFromBelow != null){
    for(int d = closestFromBelow.y - 1;d > row;d --){
      noBreaks = noBreaks && !grid[d][col].empty;
    }
    //if( !noBreaks || closestFromBelow.equals(grid[row][col].piece) )
      //flipsFromBelow = false;
    if(noBreaks){
      for(int d = closestFromBelow.y - 1;d > row;d --){
        flipsMade = true;
        if(!testing)
          grid[d][col].piece._color = ownColor;
      }
    }
  //}
  legality = legality || flipsMade;
}

void HorizontalFlips(int row,int col,boolean testing){ //flipping pieces in the same row
  Boolean flipsMade = false;
  String ownColor = grid[row][col].piece._color;
  Piece closestFromLeft = grid[row][col].piece;
  Piece closestFromRight = grid[row][col].piece;
  for(int l = 0;l < col;l ++){
    if( !grid[row][l].empty && grid[row][l].piece._color.equals(ownColor))
      closestFromLeft = grid[row][l].piece;
  }
  boolean noBreaks = true;
  for(int l = closestFromLeft.x + 1;l < col;l ++){
    noBreaks = noBreaks && !grid[row][l].empty;
  }
  //if( !noBreaks || closestFromLeft.equals(grid[row][col].piece) )
    //flipsFromLeft = false;
  if(noBreaks){
    for(int l = closestFromLeft.x + 1;l < col;l ++){
      flipsMade = true;
      if(!testing) //if HorizontalFlips is called to see if legal moves are left, don't actually flip anything
        grid[row][l].piece._color = ownColor;
    }
  }
  noBreaks = true;
  for(int r = grid[row].length - 1;r > col;r --){
    if( !grid[row][r].empty && grid[row][r].piece._color.equals(ownColor))
      closestFromRight = grid[row][r].piece;
  }
  for(int r = closestFromRight.x - 1;r > col;r --){
    noBreaks = noBreaks && !grid[row][r].empty;
  }
  //if( !noBreaks || closestFromRight.equals(grid[row][col].piece) )
    //flipsFromRight = false;
  if(noBreaks){
    for(int r = closestFromRight.x - 1;r > col;r --){
      flipsMade = true;
      if(!testing)
        grid[row][r].piece._color = ownColor;
    }
  }
  legality = legality || flipsMade;
}

void DiagonalFlips(int row,int col,boolean testing){ //flipping pieces diagonally
  //Boolean ret = false;
  String ownColor = grid[row][col].piece._color;
  DiagonalHelper(row,col,-1,-1,ownColor,testing); //top left direction
  DiagonalHelper(row,col,1,-1,ownColor,testing); //top right
  DiagonalHelper(row,col,-1,1,ownColor,testing); //bottom left
  DiagonalHelper(row,col,1,1,ownColor,testing); //bottom right
  //legality = legality || ret;
}

void DiagonalHelper(int row,int col,int dx,int dy,String ownColor,boolean testing){
  ArrayList<Piece> pieces = new ArrayList<Piece>();
  int x = col + dx;
  int y = row + dy;
  Boolean ownFound = false;
  while( (x >= 0 && x < grid[row].length) && (y >= 0 && y < grid.length) ){
    if(grid[y][x].empty){
      break;
    }
    else if(grid[y][x].piece._color.equals(ownColor)){
      ownFound = true;
      break;
    }
    else{
      pieces.add( grid[y][x].piece );
      x += dx;
      y += dy;
    }
  }
  if(ownFound && !testing) //if DiagonalFlips is called to see if legal moves are left, don't actually flip anything
    for(Piece p : pieces)
      p._color = ownColor;
  legality = legality || (ownFound && pieces.size() > 0);
}


Boolean movesLeft(String c){
  for(int i = 0;i < grid.length;i ++){
    for(int x = 0;x < grid[i].length;x ++){
      if(grid[i][x].empty){
        grid[i][x].empty = false;
        grid[i][x].piece = new Piece(c,i,x);
        legality = false;
        VerticalFlips(i,x,true);
        HorizontalFlips(i,x,true);
        DiagonalFlips(i,x,true);
        grid[i][x].piece = null;
        grid[i][x].empty = true;
        if(legality){
          legality = false;
          return true;
        }
      }
    }
  }
  return false;
}


void draw(){
  drawGrid();
  if(blacksturn)
    fill(0);
  else
    fill(255);
  ellipse(mouseX,mouseY,75,75);
}