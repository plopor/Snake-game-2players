import java.util.Scanner;

int grid = 20, hor1 = 0, ver1 = 0, hor2 = 0, ver2 = 0;
PVector food;
long start, timePass;
Snek snek;
Snek snek2;
String option = null;

void setup() {
  size(1200, 700);
  snek = new Snek(1);
  snek2 = new Snek(2);
  food = new PVector(floor(floor(random(width))/grid)*grid, floor(floor(random(height))/grid)*grid);
  start = System.currentTimeMillis();
  timePass = 0;
  System.out.println("For DFS press 1, for BFS press 2, for Human press 3, for A* press 4, for unmodified Hamiltonian press 5 (a cycle will be generated first).");
}

void draw() {
  background(0);
  snek.show();
  snek2.show();
  fill(255, 0, 0);
  rect(food.x, food.y, grid, grid);
  if (timePass >= 30) {

    snek.think(snek2, food);
    snek.update();
    food = snek.eat(food, snek2);
    snek.die(snek2);
    snek.show();


    food = snek2.eat(food, snek);
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

  // startup options
  if (keyCode == '1') {
    snek.method = "DFS";
    System.out.println("Switching to DFS");
  }
  if (keyCode == '2') {
    snek.method = "BFS";
    System.out.println("Switching to BFS");
  }
  if (keyCode == '3') {
    snek.method = "Human";
    System.out.println("Switching to manual");
  }
  if (keyCode == '4') {
    snek.method = "A*";
    System.out.println("Switching to A*");
  }
  if (keyCode == '5') {
    snek.method = "Hamiltonian";
    System.out.println("Switching to Hamiltonian");
  }
}
