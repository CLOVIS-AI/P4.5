import processing.core.*;

//10 puissance 4

final int nbreOfColumns = 27;
final int nbreOfCases = 12;
final int needToAlign = 4;

ArrayList<ArrayList<Case>> map;
ArrayList<Player> players;
DhParticleHandler particles;

void setup(){
  fullScreen();
  map = new ArrayList<ArrayList<Case>>();
  for(int i = 0; i < nbreOfColumns; i++){
    map.add(new ArrayList<Case>());
  }
  
  players = new ArrayList<Player>();
  //                           Name            Color                       Keys       Left  Right Play
  players.add(new Player(      "Ivan",         color(255, 000, 000),       new char[]{'4',  '6',  '8'}));
  players.add(new Player(      "Amy",          color(000, 255, 000),       new char[]{'l',  'm',  'p'}));
  
  particles = new DhParticleHandler();
}

void draw(){
  paint();
  for(int i = 0; i < players.size(); i++){
    players.get(i).refresh();
  }
  particles.paint();
}

void paint(){
  background(0);
  int x = 20;
  int y = 600;
  for(int i = 0; i < map.size(); i++){
    ArrayList<Case> column = map.get(i);
    for(int j = 0; j < column.size(); j++){
      Case current = column.get(j);
      fill(current.owner.getColor());
      ellipse(x, y, 40, 40);
      y-=50;
    }
    
    y=600;
    
    for(int k = 0; k < players.size(); k++){
      if(players.get(k).getColumn() == i){
        Player current = players.get(k);
        fill(current.getColor(), current.able() ? 255 : 50);
        int y2 = y+15*(k+3);
        rect(x, y2, 10, 10);
        int n = current.getTimeLeft()/60;
        String more = (n > 0) ? str(n) : "";
        text(more, x-(more.length()*12), y2+10);
        text(current.getName() + " : "+ current.getScore() + " / " + current.getCountDownMax()/60, x+15, y2+10);
        
        fill(255);
        text(current.getScore(), 10, y2+10);
      }
    }
    
    x+=50;
  }
}

void disp(){
  println("Game...");
  println(map);
}

void keyPressed(){
  for(int i = 0; i < players.size(); i++){
    Player player = players.get(i);
    if(key == player.getKeys()[2] && player.able()){
      ArrayList<Case> current = map.get(player.getColumn());
      if(current.size() > nbreOfCases)
        current.remove(0);
      current.add(new Case(player));
      refreshMap();
      player.played();
      isMultipleTen();
    }
    if(key == player.getKeys()[0])    player.moveLeft();
    if(key == player.getKeys()[1])    player.moveRight();
  }
}

void isMultipleTen(){
  for(int i = 0; i < players.size(); i++){
    if(players.get(i).getScore() > 0 && float(players.get(i).getScore())%10.0 == 0){
      Player current = players.get(i);
      for(int x = 0; x < map.size(); x++){
        for(int y = 0; y < map.get(x).size(); y++){
          if(getCase(x, y).owner == current){
            delete(new Case[]{getCase(x, y)}, new int[][]{{x, y}});
          }
        }
      }
      for(int k = 0; k < int(random(1, needToAlign)); k++){
        int target = current.getColumn();
        map.get(target).add(new Case(current));
        if(map.get(target).size() > nbreOfCases){
          map.get(target).remove(0);
        }
      }
    }
  }
}

void refreshMap(){
  for(int i = 0; i < map.size(); i++){
    for(int j = 0; j < map.get(i).size(); j++){
      checkCase(i, j);
    }
  }
  for(int i = 0; i < players.size()-1; i++){
    if(players.get(i).getScore() < players.get(i+1).getScore()){
      Player move = players.get(i);
      players.remove(i);
      players.add(move);
    }
  }
}

Case getCase(int x, int y){
  Case current;
  try{
    current = map.get(x).get(y);
    return current;
  }catch(IndexOutOfBoundsException e){}
  return null;
}

void checkCase(int x, int y){
  int[][] coords = new int[needToAlign][2];
  { //HORIZONTAL
    Case[] current = new Case[needToAlign];
    for(int i = 0; i < current.length; i++){
      coords[i][0] = x+i;
      coords[i][1] = y;
      current[i] = getCase(coords[i][0], coords[i][1]);
    }
    search(current, coords);
  }
  { //VERTICAL
    Case[] current = new Case[needToAlign];
    for(int i = 0; i < current.length; i++){
      coords[i][0] = x;
      coords[i][1] = y+i;
      current[i] = getCase(coords[i][0], coords[i][1]);
    }
    search(current, coords);
  }
  { //RIGHT DIAGONAL
    Case[] current = new Case[needToAlign];
    for(int i = 0; i < current.length; i++){
      coords[i][0] = x+i;
      coords[i][1] = y+i;
      current[i] = getCase(coords[i][0], coords[i][1]);
    }
    search(current, coords);
  }
  { //LEFT DIAGONAL
    Case[] current = new Case[needToAlign];
    for(int i = 0; i < current.length; i++){
      coords[i][0] = x-i;
      coords[i][1] = y+i;
      current[i] = getCase(coords[i][0], coords[i][1]);
    }
    search(current, coords);
  }
}

void search(Case[] cases, int[][] coords){
  Case first = cases[0];
  if(first == null)
    return;
  Player owner = first.owner;
  boolean isAligned = true;
  for(int i = 1; i < cases.length; i++){
    if(cases[i] != null && cases[i].owner != owner || cases[i] == null)
      isAligned = false;
  }
  if(isAligned && owner != null){
    owner.upScore();
    for(int i = 1; i < cases.length; i++){
      checkCase(coords[i][0], coords[i][1]);
    }
    delete(cases, coords);
    refreshMap();
  }
}

void delete(Case[] cases, int[][] coords){
  for(int i = 0; i < coords.length; i++){
    particles.newParticles(20+50*coords[i][0], 600-50*coords[i][1], 60, int(random(50))+20, cases[i].owner.getColor());
    map.get(coords[i][0]).remove(cases[i]);
  }
}