import processing.core.*;

class DhParticles{
  private float x, y;
  private float speed;
  private float angle;
  private float size;
  private color partColor;
  private float lifeTime;
  private float gravity;
  
  DhConsole console;
  
  DhParticles(float x, float y, int lifeTime, float angle, color colour){
    this(x, y, lifeTime, colour);
    this.angle = angle;
  }
  
  DhParticles(float x, float y, int lifeTime, color colour){
    console = new DhConsole("DhParticles", "float, float, int");
    
    this.x = x;
    this.y = y;
    this.lifeTime = lifeTime;
    angle = 0;
    size = 10;
    speed = 5;
    gravity = 0;
    partColor = colour;
  }
  
  public void move(){
    if(lifeTime <= 0) console.err("move()","lifeTime reached 0 and would cause a division/zero exception.");
    
    setAngle(angle);
    if(angle > -PI/4 || angle < PI/4){
      y += 2*gravity/50;
    } else{
      y -= 2*gravity/50;
    }
    
    x += cos(angle)*speed;
    y += sin(angle)*speed;
    lifeTime--;
    gravity++;
    
    if(speed <= 0) console.err("move()","speed reached 0 and would cause a ball going backward effect.");
    speed -= speed/(lifeTime+50);
  }
  
  private void setAngle(float newAngle){
    angle = newAngle;
    
    while(angle < -PI || angle > PI){
      if(angle > PI){
        angle -= 2*PI;
      } else{
        angle += 2*PI;
      }
    }

  }
  
  public void paint(){
    noStroke();
    move();
    
    fill(partColor, lifeTime);
    ellipse(x, y, size, size);
  }
  
  public int getLifeTime(){
    return int(lifeTime);
  }
}












class DhParticleHandler{
  private ArrayList<DhParticles> partList;
  
  DhParticleHandler(){
    partList = new ArrayList<DhParticles>();
  }
  
  public void newParticle(float x, float y, int lifeTime){
    partList.add(new DhParticles(x, y, lifeTime, color(0, 0, 0)));
  }
  
  /*public void newParticle(float x, float y, int lifeTime, float angle){
    partList.add(new DhParticles(x, y, lifeTime, angle));
  }*/
  
  public void newParticle(float x, float y, int lifeTime, float angle, color colour){
    partList.add(new DhParticles(x, y, lifeTime, angle, colour));
  }
  
  public void newParticles(float x, float y, int lifeTime, int number, color colour){
    for(int i = 0; i < number; i++){
      newParticle(x, y, lifeTime, random(2*PI), colour);
    }
  }
  
  public void paint(){
    for(int i = 0; i < partList.size(); i++){
      partList.get(i).paint();
      if(partList.get(i).getLifeTime() <= 0){
        partList.remove(i);
      }
    }
  }
  
}







import processing.core.*;

//DH API > For creating more usefull console messages

class DhConsole{
  private final String object;
  
  DhConsole(String object, String constructor){
    this.object = object;
    
    msg(object+"("+constructor+")", "Creation of the new "+object+" object fullfilled !");
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //Messages for normal informations
  public void msg(String field, String message){
    println("DH API > "+object+"."+field+" ... "+message);
  }
  
  public void msg(String field, String message, String parameters, String returns){
    println("DH API > "+object+"."+field+" ... "+message+"        PARAMS : "+parameters+" | RETURNS : "+returns);
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //Messages for warnings
  public void warn(String field, String message){
    println("DH API > [WARNING] ----------------------------------------- "+object+"."+field+" ... "+message);
  }
  
  public void warn(String field, String message, String parameters, String returns){
    println("DH API > [WARNING] ----------------------------------------- "+object+"."+field+" ... "+message+"        PARAMS : "+parameters+" | RETURNS : "+returns);
  }
  
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //Error messages... Will stop the execution
  public void err(String field, String message){
    println("DH API > [ERROR] -------------------------------------------------------------------------------------- "+object+"."+field+" ... "+message);
    
    System.exit(1);
  }
  
  public void err(String field, String message, String parameters, String returns){
    println("DH API > [ERROR] -------------------------------------------------------------------------------------- "+object+"."+field+" ... "+message+"        PARAMS : "+parameters+" | RETURNS : "+returns+"\n");
    
    System.exit(1);
  }
  
}