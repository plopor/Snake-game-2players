import java.util.Stack;

class Snek {
  PVector pos;
  PVector vel;
  PVector start;
  PVector lastFood = new PVector(0, 0);
  ArrayList<PVector> hist;
  Stack<PVector> orders = new Stack<PVector>();
  int len;
  int playerNum;

  Snek(int number) {
    playerNum = number;
    if (number == 1)
      pos = new PVector(0, 0);
    else
      pos = new PVector(1180, 680);
    start = pos;
    vel = new PVector(0, 0);
    hist = new ArrayList<PVector>();
    len = 0;
  }

  void update() {  
    // add previous location of snake head to snake tail
    hist.add(pos.copy());
    pos.x += (vel.x*grid);
    pos.y += (vel.y*grid);
    // remove oldest section of snake tail as the head moves, i.e the first in the array
    if (hist.size() > len) {
      hist.remove(0);
    }
  }

  void show() {
    noStroke();
    if (playerNum == 1)
      fill(20, 250, 20);
    else
      fill(20, 20, 250);
    // draw snake head
    rect(pos.x, pos.y, grid, grid);
    // draw snake tail
    for (PVector p : hist) {
      rect (p.x, p.y, grid, grid);
    }
  }

  PVector eat(PVector food) {
    // increase snake tail length when it hits food

    if ((pos.x == food.x)&&(pos.y == food.y)) {
      len += 1; 
      // make new food position
      return new PVector(floor(floor(random(width))/grid)*grid, floor(floor(random(height))/grid)*grid);
    }
    lastFood.x = food.x;
    lastFood.y = food.y;
    return food;
  }

  private void restart() {
    len = 0;
    hist = new ArrayList<PVector>();
    if (playerNum == 1) {
      pos.x = 0;
      pos.y = 0;
    } else
    {
      pos.x = 1180;
      pos.y = 680;
    }
    snek.vel.y = 0;
    snek.vel.x = 0;
  }

  void die(Snek other) {
    // snake death when it encounters its tail
    for (PVector j : hist) {
      if ((pos.x == j.x)&&(pos.y == j.y)) {
        restart();
      }
    }
    // snake death when it encounters player 2's tail
    for (PVector l : other.hist) {
      if ((pos.x == l.x)&&(pos.y == l.y)) {
        restart();
      }
    }
    // snake deaths when it encounters the edges
    if (pos.x > floor((floor(width)-1)/grid)*grid) {
      restart();
    } else if (pos.x < 0) {
      restart();
    }
    if (pos.y > floor((floor(height)-1)/grid)*grid) {
      restart();
    } else if (pos.y < 0) {
      restart();
    }
  }

  void think(Snek other, PVector food) {
    Stack<PVector> stack = new Stack<PVector>();
    Stack<PVector> path = new Stack<PVector>();

    //food.x = 0;
    //food.y = 300;

    int rows = 60;
    int cols = 35;
    int grid[][] = new int[rows][cols];
    int startX = (int)(pos.x / 20);
    int startY = (int)(pos.y / 20);
    int endX = (int)(food.x / 20);
    int endY = (int)(food.y / 20);
    grid[startX][startY] = -1;

    for (int i = 0; i < other.hist.size(); i++)
      grid[(int)other.hist.get(i).x / 20][(int)other.hist.get(i).y / 20] = -1;
    for (int i = 0; i < hist.size(); i++)
      grid[(int)hist.get(i).x / 20][(int)hist.get(i).y / 20] = -2;

    grid[endX][endY] = 1;

    //System.out.println();
    //for (int i = 0; i < cols; i++){
    //  for (int j = 0; j < rows; j++){
    //    System.out.print(grid[j][i]);
    //  }
    //  System.out.println();
    //}

    //grid[0][9] = -2;

    if (orders.size() == 0 || lastFood.x != food.x || lastFood.y != food.y) {
      lastFood.x = food.x;
      lastFood.y = food.y;
      stack.push(new PVector(startX, startY));
      while (stack.size() != 0) {
        PVector curr = stack.pop();
        path.push(curr);
        if (grid[(int)curr.x][(int)curr.y] == 1) {
          break;
        }
        if (grid[(int)curr.x][(int)curr.y] == -2 || grid[(int)curr.x][(int)curr.y] == 3) {
          path.pop();
          continue;
        }
        if ((int)curr.x < 59) {
          stack.push(new PVector(curr.x + 1, curr.y));
        }
        if ((int)curr.y < 34) {
          stack.push(new PVector(curr.x, curr.y + 1));
        }
        if (curr.x > 0) {
          stack.push(new PVector(curr.x - 1, curr.y));
        }
        if (curr.y > 0) {
          stack.push(new PVector(curr.x, curr.y - 1));
        }
        grid[(int)curr.x][(int)curr.y] = 3;
      }

      System.out.println("Size: " + path.size());

      while (path.size() > 1) {
        orders.push(path.pop());
      }
    }
    if (orders.size() != 0) {
      //System.out.println("position: " + pos.x / 20 + ", " + pos.y / 20);
      PVector direction = orders.pop();
      //System.out.println("direction: " + direction.x + ", " + direction.y);
      if (direction.x > pos.x / 20) {
        vel.x = 1;
        vel.y = 0;
      } else if (direction.x < pos.x / 20) {
        vel.x = -1;
        vel.y = 0;
      } else if (direction.y > pos.y / 20) {
        vel.x = 0;
        vel.y = 1;
      } else if (direction.y < pos.y / 20) {
        vel.x = 0;
        vel.y = -1;
      } else {
        System.out.println("nothing to do");
      }
    }
    System.out.println("Orders: " + orders.size());
    //for (int i = 0; i < orders.size(); i++){
    //  PVector lol = orders.get(i);
    //  System.out.println(lol.x + ", " + lol.y);
    //}
  }
}
