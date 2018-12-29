class Snek{
 PVector pos;
 PVector vel;
 ArrayList<PVector> hist;
 int len;
 
 Snek(){
   pos = new PVector(0, 0);
   vel = new PVector(0, 0);
   hist = new ArrayList<PVector>();
   len = 0;
 }
 
 void update(){  
   // add previous location of snake head to snake tail
   hist.add(pos.copy());
   pos.x += (vel.x*grid);
   pos.y += (vel.y*grid);
   // remove oldest section of snake tail as the head moves, i.e the first in the array
   if (hist.size() > len){
     hist.remove(0);
   }
 }
 
 void show(){
   noStroke();
   fill(20, 250, 20);
   // draw snake head
   rect(pos.x, pos.y, grid, grid);
   // draw snake tail
   for (PVector p : hist){
    rect (p.x, p.y, grid, grid);
   }
 }
 
 void eat(){
   // increase snake tail length when it hits food
  if ((pos.x == food.x)&&(pos.y == food.y)){
   len += 1; 
   // make new food position
   food = new PVector(floor(floor(random(width))/grid)*grid, floor(floor(random(height))/grid)*grid);
  }
 }
 
 void die(){
   // snake death when it encounters its tail
   for (PVector j : hist){
     if ((pos.x == j.x)&&(pos.y == j.y)){
       len = 0;
       hist = new ArrayList<PVector>();
       pos.x = 0;
       pos.y = 0;
       snek.vel.y = 0;
       snek.vel.x = 0;
     }
   }
   // snake death when it encounters player 2's tail
   for (PVector l : snek2.hist){
     if ((pos.x == l.x)&&(pos.y == l.y)){
       len = 0;
       hist = new ArrayList<PVector>();
       pos.x = 0;
       pos.y = 0;
       snek.vel.y = 0;
       snek.vel.x = 0;
     }
   }
   // snake deaths when it encounters the edges
   if (pos.x > floor((floor(width)-1)/grid)*grid){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = 0;
     pos.y = 0;
     snek.vel.y = 0;
     snek.vel.x = 0;
   }
   else if (pos.x < 0){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = 0;
     pos.y = 0;
     snek.vel.y = 0;
     snek.vel.x = 0;
   }
   if (pos.y > floor((floor(height)-1)/grid)*grid){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = 0;
     pos.y = 0;
     snek.vel.y = 0;
     snek.vel.x = 0;
   }
   else if (pos.y < 0){
     len = 0;
     hist = new ArrayList<PVector>();
     pos.x = 0;
     pos.y = 0;
     snek.vel.y = 0;
     snek.vel.x = 0;
   }
 }
}
