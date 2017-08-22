class Piece{
  String _color;
  int x,y;
  boolean flipMe;
  
  Piece(){
    _color = "black";
    flipMe = false;
  }
  
  Piece(String c,int ycor,int xcor){
    _color = c;
    x = xcor;
    y = ycor;
    flipMe = false;
  }
  
  void flip(){
    if (_color.equals("black"))
      _color = "white";
    else
      _color = "black";
  }
  
  
}