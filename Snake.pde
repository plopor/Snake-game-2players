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
