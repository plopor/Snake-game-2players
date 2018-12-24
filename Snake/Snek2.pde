class Snek2{
 PVector pos;
 PVector vel;
 ArrayList<PVector> hist;
 int len;
 long lastTime, deltaTime;
 
 Snek2(){
     pos = new PVector(floor((floor(width)-1)/grid)*grid, 0);
     vel = new PVector(0, 0);
     hist = new ArrayList<PVector>();
     len = 0;
 }
 
 void update(){
   deltaTime = System.currentTimeMillis() - lastTime;
   
   hist.add(pos.copy());
   pos.x += vel.x*grid;
   pos.y += vel.y*grid;
   if (pos.x > floor((floor(width)-1)/grid)*grid){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = floor((floor(width)-1)/grid)*grid;
     pos.y = 0;
     snek2.vel.y = 0;
     snek2.vel.x = 0;
   }
   else if (pos.x < 0){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = floor((floor(width)-1)/grid)*grid;
     pos.y = 0;
     snek2.vel.y = 0;
     snek2.vel.x = 0;
   }
   if (pos.y > floor((floor(height)-1)/grid)*grid){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = floor((floor(width)-1)/grid)*grid;
     pos.y = 0;
     snek2.vel.y = 0;
     snek2.vel.x = 0;
   }
   else if (pos.y < 0){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = floor((floor(width)-1)/grid)*grid;
     pos.y = 0;
     snek2.vel.y = 0;
     snek2.vel.x = 0;
   }
   if (hist.size() > len){
     hist.remove(0);
   }
   lastTime = System.currentTimeMillis();
 }
 
 void show(){
   noStroke();
   fill(20, 20, 250);
   rect(pos.x, pos.y, grid, grid);
   for (PVector p : hist){
    rect (p.x, p.y, grid, grid);
   }
 }
 
 void eat(){
  if ((pos.x == food.x)&&(pos.y == food.y)){
   len += 1; 
   food = new PVector(floor(floor(random(width))/grid)*grid, floor(floor(random(height))/grid)*grid);
  }
 }
 
 void die(){
   for (PVector j : hist){
     if ((pos.x == j.x)&&(pos.y == j.y)){
       len = 0;
       hist = new ArrayList<PVector>();
       pos.x = floor((floor(width)-1)/grid)*grid;
       pos.y = 0;
       snek2.vel.y = 0;
       snek2.vel.x = 0;
   }
  }
   for (PVector l : snek.hist){
     if ((pos.x == l.x)&&(pos.y == l.y)){
       len = 0;
       hist = new ArrayList<PVector>();
       pos.x = floor((floor(width)-1)/grid)*grid;
       pos.y = 0;
       snek2.vel.y = 0;
       snek2.vel.x = 0;
   }
  }
 }
}
