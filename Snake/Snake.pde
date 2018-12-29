int grid = 20, hor1 = 0, ver1 = 0, hor2 = 0, ver2 = 0;
PVector food;
Snek snek;
Snek2 snek2;

void setup(){
  size(1200,700);
  snek = new Snek();
  snek2 = new Snek2();
  food = new PVector(floor(floor(random(width))/grid)*grid, floor(floor(random(height))/grid)*grid);
  // set low frames to ensure snake moves at a reasonable speed while staying in discrete grid positions
  // also emulates the classic
  frameRate(15);
}

void draw(){
  background(0);
  snek.eat();
  snek.update();
  snek.die();
  snek.show();
  snek2.eat();
  snek2.update();
  snek2.die();
  snek2.show();
  fill(255, 0, 0);
  rect(food.x, food.y, grid, grid);
}

void keyPressed(){
  // controls for player 1, and statements prevent backtracking
  if ((keyCode == LEFT) && (snek.vel.x != 1)){
    snek.vel.x= -1;
    snek.vel.y= 0;
  } else if ((keyCode == RIGHT) && (snek.vel.x != -1)){
    snek.vel.x = 1;
    snek.vel.y= 0;
  } 
  if ((keyCode == UP) && (snek.vel.y != 1)){
    snek.vel.y = -1;
    snek.vel.x= 0;
  } else if ((keyCode == DOWN) && (snek.vel.y != -1)){
    snek.vel.y = 1;
    snek.vel.x= 0;
  }
  // controls for player 2 and statements prevent backtracking
  if ((keyCode == 'A') && (snek2.vel.x != 1)){
    snek2.vel.x= -1;
    snek2.vel.y= 0;
  } else if ((keyCode == 'D') && (snek2.vel.x != -1)){
    snek2.vel.x = 1;
    snek2.vel.y= 0;
  } 
  if ((keyCode == 'W') && (snek2.vel.y != 1)){
    snek2.vel.y = -1;
    snek2.vel.x= 0;
  } else if ((keyCode == 'S') && (snek2.vel.y != -1)){
    snek2.vel.y = 1;
    snek2.vel.x= 0;
  }
}
