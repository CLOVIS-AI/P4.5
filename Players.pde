class Player{
  private String name;
  private color colour;
  private int score;
  private char[] keys;
  private int column;
  private int countDown;
  private int countDownMax;
  private boolean able;
  private ArrayList<Integer> moves;
  
  Player(String name, color colour, char[] keys){
    score = 0;
    this.name = name;
    this.colour = colour;
    this.keys = keys;
    column = 0;
    countDown = score*100;
    able = false;
    moves = new ArrayList<Integer>();
  }
  
  char[] getKeys(){
    return keys;
  }
  
  int getColumn(){
    return column;
  }
  
  void moveLeft(){
    column--;
  }
  
  void moveRight(){
    column++;
  }
  
  color getColor(){
    return colour;
  }
  
  void refresh(){
    if(column < 0) column = 0;
    if(column > nbreOfColumns-1) column = nbreOfColumns-1;
    countDown--;
    if(countDown <= 0)  able = true;
    for(int i = 0; i < moves.size(); i++){
      moves.set(i, moves.get(i)-1);
      if(moves.get(i) < 0)
        moves.remove(i);
    }
    countDownMax = (moves.size()+1)*60;
  }
  
  String getName(){
    return name;
  }
  
  boolean able(){
    return able;
  }
  
  void played(){
    countDown = countDownMax;
    able = false;
  }
  
  int getScore(){
    return score;
  }
  
  void upScore(){
    score++;
    moves.add(5000);
  }
  
  int getTimeLeft(){
    return countDown;
  }
  
  int getCountDownMax(){
    return countDownMax;
  }
}