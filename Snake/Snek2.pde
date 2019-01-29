class Snek2 extends Snek{
 Snek2(){
     pos = new PVector(floor((floor(width)-1)/grid)*grid, 0);
     vel = new PVector(0, 0);
     hist = new ArrayList<PVector>();
     len = 0;
 }
 @Override
 void show(){
   noStroke();
   fill(20, 20, 250);
   // draw snake head
   rect(pos.x, pos.y, grid, grid);
   // draw snake tail
   for (PVector p : hist){
    rect (p.x, p.y, grid, grid);
   }
 }
 @Override
 void die(){
   // snake death when it encounters its own tail
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
  // snake death when it encounters player 1's tail
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
  // snake deaths when it encounters edge
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
 }
}
