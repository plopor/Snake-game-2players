int grid = 20;
PVector food;
Snek snek;
Snek2 snek2;

void setup(){
  size(1200,700);
  snek = new Snek();
  snek2 = new Snek2();
  food = new PVector(floor(floor(random(width))/grid)*grid, floor(floor(random(height))/grid)*grid);
  frameRate(10);
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
  if (keyCode == LEFT){
    snek.vel.x= -1;
    snek.vel.y= 0;
  } else if (keyCode == RIGHT){
    snek.vel.x = 1;
    snek.vel.y= 0;
  } 
  if (keyCode == UP){
    snek.vel.y = -1;
    snek.vel.x= 0;
  } else if (keyCode == DOWN){
    snek.vel.y = 1;
    snek.vel.x= 0;
  }
  
  if (keyCode == 'A'){
    snek2.vel.x= -1;
    snek2.vel.y= 0;
  } else if (keyCode == 'D'){
    snek2.vel.x = 1;
    snek2.vel.y= 0;
  } 
  if (keyCode == 'W'){
    snek2.vel.y = -1;
    snek2.vel.x= 0;
  } else if (keyCode == 'S'){
    snek2.vel.y = 1;
    snek2.vel.x= 0;
  }
}
