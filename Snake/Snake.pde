int grid = 20, hor1 = 0, ver1 = 0, hor2 = 0, ver2 = 0;
PVector food;
long start, timePass;
Snek snek;
Snek snek2;

void setup() {
  size(1200, 700);
  snek = new Snek(1);
  snek2 = new Snek(2);
  food = new PVector(floor(floor(random(width))/grid)*grid, floor(floor(random(height))/grid)*grid);
  // set low frames to ensure snake moves at a reasonable speed while staying in discrete grid positions
  // also emulates the classic
  //frameRate(15);
  start = System.currentTimeMillis();
  timePass = 0;
}

void draw() {
  background(0);
  snek.show();
  snek2.show();
  fill(255, 0, 0);
  rect(food.x, food.y, grid, grid);
  if (timePass >= 30) {
    snek.think(snek2, food);
    food = snek.eat(food);
    snek.update();
    snek.die(snek2);
    snek.show();
    food = snek2.eat(food);
    snek2.update();
    snek2.die(snek);
    start = System.currentTimeMillis();
  }
  timePass = System.currentTimeMillis() - start;
}

void keyPressed() {
  // controls for player 1, and statements prevent backtracking
  if ((keyCode == LEFT) && (snek.vel.x != 1)) {
    snek.vel.x= -1;
    snek.vel.y= 0;
  } else if ((keyCode == RIGHT) && (snek.vel.x != -1)) {
    snek.vel.x = 1;
    snek.vel.y= 0;
  } 
  if ((keyCode == UP) && (snek.vel.y != 1)) {
    snek.vel.y = -1;
    snek.vel.x= 0;
  } else if ((keyCode == DOWN) && (snek.vel.y != -1)) {
    snek.vel.y = 1;
    snek.vel.x= 0;
  }

  // controls for player 2 and statements prevent backtracking
  if ((keyCode == 'A') && (snek2.vel.x != 1)) {
    snek2.vel.x= -1;
    snek2.vel.y= 0;
  } else if ((keyCode == 'D') && (snek2.vel.x != -1)) {
    snek2.vel.x = 1;
    snek2.vel.y= 0;
  } 
  if ((keyCode == 'W') && (snek2.vel.y != 1)) {
    snek2.vel.y = -1;
    snek2.vel.x= 0;
  } else if ((keyCode == 'S') && (snek2.vel.y != -1)) {
    snek2.vel.y = 1;
    snek2.vel.x= 0;
  }
}
