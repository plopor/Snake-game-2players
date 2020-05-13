import java.util.Stack; //<>// //<>// //<>// //<>// //<>// //<>//
import java.util.Queue;
import java.util.LinkedList;
import java.util.PriorityQueue;

class Snek {
  PVector pos;
  PVector vel;
  PVector start;
  PVector lastFood = new PVector(0, 0);
  ArrayList<PVector> hist;
  Stack<PVector> orders = new Stack<PVector>();
  int len;
  int playerNum;
  boolean runOnce = true;
  Stack<PVector> cycle = new Stack<PVector>();

  boolean first;

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


    //testing
    first = false;
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

  PVector eat(PVector food, Snek other) {
    // increase snake tail length when it hits food

    if ((pos.x == food.x)&&(pos.y == food.y)) {
      len += 1; 
      // make new food position
      //food = new PVector((floor(random(width))/grid)*grid, (floor(random(height))/grid)*grid);
      food = spawnFood(other);
    }
    lastFood.x = food.x;
    lastFood.y = food.y;
    return food;
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

  void think(Snek other, PVector food, String method) {

    if (this.first) {
      food.x = 200;
      food.y = 0;
      first = false;
    }

    int rows = 60;
    int cols = 35;
    int grid[][] = new int[rows][cols];
    int startX = (int)(pos.x / 20);
    int startY = (int)(pos.y / 20);
    int endX = (int)(food.x / 20);
    int endY = (int)(food.y / 20);

    //grid[startX][startY] = -2;

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

    if (method == "DFS") {
      DFS(startX, startY, grid);
      executeOrder66();
    } else if (method == "BFS") {
      BFS(startX, startY, grid);
      executeOrder66();
    } else if (method == "A*") {
      // Dijkstra's is omitted since it is pretty redundant when all edge costs are the same
      // A* and the heuristic might save some node expansion though, so it's included
      aStar(startX, startY, endX, endY, grid);
      executeOrder66();
    } else if (method == "Hamiltonian") {
      hamiltonian(startX, startY, grid, rows, cols);
      executeOrder66();
    }
  }

  //MISC functions----------------------------------------------------------------------------
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

  private void DFS(int startX, int startY, int[][] grid) {
    Stack<PVector> stack = new Stack<PVector>();
    Stack<ArrayList<PVector>> pathStack = new Stack<ArrayList<PVector>>();

    //DFS cannot respond to changes every tick, its path results changes as it follows it
    if (orders.size() == 0 || lastFood.x != food.x || lastFood.y != food.y) {
      lastFood.x = food.x;
      lastFood.y = food.y;
      stack.push(new PVector(startX, startY));
      ArrayList<PVector> path = new ArrayList<PVector>();
      ArrayList<PVector> temp;
      path.add(new PVector(startX, startY));
      pathStack.push(path);

      while (stack.size() != 0) {
        PVector curr = stack.pop();
        path = pathStack.pop();
        if (grid[(int)curr.x][(int)curr.y] == 1) {
          for (int i = path.size() - 1; i > 0; i--) {
            orders.push(path.get(i));
            //System.out.println(path.get(i));
          }
          break;
        }

        //DFS is not responsive enough to avoid dynamic movements including the other player
        if (grid[(int)curr.x][(int)curr.y] == 3 || grid[(int)curr.x][(int)curr.y] == -2) {
          continue;
        }
        if ((int)curr.x < 59) {
          temp = new ArrayList<PVector>(path);
          temp.add(new PVector(curr.x + 1, curr.y));
          pathStack.push(temp);
          stack.push(new PVector(curr.x + 1, curr.y));
        }
        if ((int)curr.y < 34) {
          temp = new ArrayList<PVector>(path);
          temp.add(new PVector(curr.x, curr.y + 1));
          pathStack.push(temp);
          stack.push(new PVector(curr.x, curr.y + 1));
        }
        if (curr.x > 0) {
          temp = new ArrayList<PVector>(path);
          temp.add(new PVector(curr.x - 1, curr.y));
          pathStack.push(temp);
          stack.push(new PVector(curr.x - 1, curr.y));
        }
        if (curr.y > 0) {
          temp = new ArrayList<PVector>(path);
          temp.add(new PVector(curr.x, curr.y - 1));
          pathStack.push(temp);
          stack.push(new PVector(curr.x, curr.y - 1));
        }
        grid[(int)curr.x][(int)curr.y] = 3;
      }

      System.out.println("Size: " + orders.size());
    }
  }

  private void BFS(int startX, int startY, int[][] grid) {
    orders = new Stack<PVector>();

    Queue<PVector> queue = new LinkedList<PVector>();
    Queue<ArrayList<PVector>> pathQ = new LinkedList<ArrayList<PVector>>();
    ArrayList<PVector> path = new ArrayList<PVector>();
    ArrayList<PVector> temp;

    queue.add(new PVector(startX, startY));
    path.add(new PVector(startX, startY));
    pathQ.add(path);
    while (queue.size() != 0) {
      PVector curr = queue.remove();
      path = pathQ.remove();
      if (grid[(int)curr.x][(int)curr.y] == 1) {
        for (int i = path.size() - 1; i > 0; i--) {
          orders.push(path.get(i));
          //System.out.println(path.get(i));
        }
        break;
      }
      if (grid[(int)curr.x][(int)curr.y] == 3 || grid[(int)curr.x][(int)curr.y] == -2 || grid[(int)curr.x][(int)curr.y] == -1) {
        continue;
      }
      if ((int)curr.x < 59) {
        temp = new ArrayList<PVector>(path);
        temp.add(new PVector(curr.x + 1, curr.y));
        pathQ.add(temp);
        queue.add(new PVector(curr.x + 1, curr.y));
      }
      if ((int)curr.y < 34) {
        temp = new ArrayList<PVector>(path);
        temp.add(new PVector(curr.x, curr.y + 1));
        pathQ.add(temp);
        queue.add(new PVector(curr.x, curr.y + 1));
      }
      if (curr.x > 0) {
        temp = new ArrayList<PVector>(path);
        temp.add(new PVector(curr.x - 1, curr.y));
        pathQ.add(temp);
        queue.add(new PVector(curr.x - 1, curr.y));
      }
      if (curr.y > 0) {
        temp = new ArrayList<PVector>(path);
        temp.add(new PVector(curr.x, curr.y - 1));
        pathQ.add(temp);
        queue.add(new PVector(curr.x, curr.y - 1));
      }
      grid[(int)curr.x][(int)curr.y] = 3;
    }
    System.out.println("Size: " + orders.size());
  }

  private void aStar(int startX, int startY, int endX, int endY, int[][] grid) {
    orders = new Stack<PVector>();

    PriorityQueue<ComparablePVec> pQueue = new PriorityQueue<ComparablePVec>();
    PVector goal = new PVector(endX, endY);
    pQueue.add(new ComparablePVec(startX, startY, goal));

    while (pQueue.size() != 0) {
      ComparablePVec curr = pQueue.remove();

      if (grid[curr.x][curr.y] == 1) {
        while (curr.parent != null) {
          PVector order = new PVector(curr.x, curr.y);
          orders.push(order);
          //System.out.println(order);
          curr = curr.parent;
        }
        break;
      }

      // We can assume that the first time a coord is reached it has the lowest cost, since each single path has same weight and obviously the same coord has same heuristic
      else if (grid[curr.x][curr.y] == 3 || grid[curr.x][curr.y] == -2 || grid[curr.x][curr.y] == -1) {
        continue;
      }
      if (curr.x < 59) {
        ComparablePVec toAdd = new ComparablePVec(curr.x + 1, curr.y, goal);
        toAdd.z += 1;
        toAdd.parent = curr;
        pQueue.add(toAdd);
      }
      if (curr.y < 34) {
        ComparablePVec toAdd = new ComparablePVec(curr.x, curr.y + 1, goal);
        toAdd.z += 1;
        toAdd.parent = curr;
        pQueue.add(toAdd);
      }
      if (curr.x > 0) {
        ComparablePVec toAdd = new ComparablePVec(curr.x - 1, curr.y, goal);
        toAdd.z += 1;
        toAdd.parent = curr;
        pQueue.add(toAdd);
      }
      if (curr.y > 0) {
        ComparablePVec toAdd = new ComparablePVec(curr.x, curr.y - 1, goal);
        toAdd.z += 1;
        toAdd.parent = curr;
        pQueue.add(toAdd);
      }
      grid[curr.x][curr.y] = 3;
    }
    System.out.println("Size: " + orders.size());
  }

  private void hamiltonian(int startX, int startY, int[][] grid, int rows, int cols) {
    if (runOnce) {
      grid[2][0] = 1; //seed the grid for Hamiltonian generation
      grid[1][0] = -1; //block the path directly between start and finish
      BFS(startX, startY, grid);
      grid = new int[rows][cols];

      //NOT USED IF WE ARE JUST TO GENERATE A HAMILTONIAN PATH ONCE AT THE START i.e no need to avoid itself
      //for (int i = 0; i < hist.size(); i++)
      //  grid[(int)hist.get(i).x / 20][(int)hist.get(i).y / 20] = 1;

      for (int i = 0; i < orders.size(); i++)
        grid[(int)orders.get(i).x][(int)orders.get(i).y] = 1;

      for (int i = orders.size() - 1; i > 0; i --) {
        //System.out.println("Updating size: " + orders.size());
        System.out.println();
        for (int z = 0; z < cols; z++) {
          for (int j = 0; j < rows; j++) {
            System.out.print(grid[j][z]);
          }
          System.out.println();
        }
        PVector pointA = orders.get(i);
        PVector pointB = orders.get(i - 1);
        if (pointA.x == pointB.x) {
          if ((int)pointA.x + 1 < 60 && grid[(int)pointA.x + 1][(int)pointA.y] != 1 && grid[(int)pointB.x + 1][(int)pointB.y] != 1) {
            PVector pointC = new PVector(pointA.x + 1, pointA.y);
            PVector pointD = new PVector(pointB.x + 1, pointB.y);

            grid[(int)pointC.x][(int)pointC.y] = 1;
            grid[(int)pointD.x][(int)pointD.y] = 1;

            orders.add(i, pointC);
            orders.add(i, pointD);
            i += 3;
          } else if ((int)pointA.x - 1 >= 0 && grid[(int)pointA.x - 1][(int)pointA.y] != 1 && grid[(int)pointB.x - 1][(int)pointB.y] != 1) {
            PVector pointC = new PVector(pointA.x - 1, pointA.y);
            PVector pointD = new PVector(pointB.x - 1, pointB.y);

            grid[(int)pointC.x][(int)pointC.y] = 1;
            grid[(int)pointD.x][(int)pointD.y] = 1;

            orders.add(i, pointC);
            orders.add(i, pointD);
            i += 3;
          } else
            continue;
        } else if (pointA.y == pointB.y) {
          if ((int)pointA.y + 1 < 35 && grid[(int)pointA.x][(int)pointA.y + 1] != 1 && grid[(int)pointB.x][(int)pointB.y + 1] != 1) {
            PVector pointC = new PVector(pointA.x, pointA.y + 1);
            PVector pointD = new PVector(pointB.x, pointB.y + 1);

            grid[(int)pointC.x][(int)pointC.y] = 1;
            grid[(int)pointD.x][(int)pointD.y] = 1;

            orders.add(i, pointC);
            orders.add(i, pointD);
            i += 3;
          } else if ((int)pointA.y - 1 >= 0 && grid[(int)pointA.x][(int)pointA.y - 1] != 1 && grid[(int)pointB.x][(int)pointB.y - 1] != 1) {
            PVector pointC = new PVector(pointA.x, pointA.y - 1);
            PVector pointD = new PVector(pointB.x, pointB.y - 1);

            grid[(int)pointC.x][(int)pointC.y] = 1;
            grid[(int)pointD.x][(int)pointD.y] = 1;

            orders.add(i, pointC);
            orders.add(i, pointD);
            i += 3;
          } else
            continue;
        } else {
          System.out.println("Same point");
        }
      }

      //finish the Hamiltonian cycle
      orders.add(0, new PVector(1, 0));
      orders.add(0, new PVector(0, 0));

      cycle = (Stack)orders.clone();
      runOnce = false;
    }

    //continue the cycle
    if (orders.size() == 0)
      orders = (Stack)cycle.clone();
  }

  private void executeOrder66() {
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
    System.out.println("Orders remaining: " + orders.size());
  }

  private PVector spawnFood(Snek other) {
    PVector toRet = new PVector();
    ArrayList<PVector> occupied = new ArrayList<PVector>();
    int[] flattened = new int[60 * 35];

    for (int i = 0; i < other.hist.size(); i++)
      occupied.add(new PVector((int)other.hist.get(i).x / 20, (int)other.hist.get(i).y / 20));
    for (int i = 0; i < hist.size(); i++)
      occupied.add(new PVector((int)hist.get(i).x / 20, (int)hist.get(i).y / 20));

    for (int i = 0; i < occupied.size(); i++) {
      flattened[(int)occupied.get(i).y * 60 + (int)occupied.get(i).x] = 1;
    }

    //int LOLcounter = 0;
    //for (int i = 0; i < 35; i++){
    //  for (int j = 0; j < 60; j++){
    //    System.out.print(flattened[LOLcounter]);
    //    LOLcounter++;
    //  }
    //  System.out.println();
    //}

    int total = 60 * 35 - occupied.size();
    int placing = int(random(total));
    int counter = 0;

    for (counter = 0; counter < (60 * 35); counter++) {
      if (flattened[counter] == 1) {
        continue;
      }
      if (placing == 0)
        break;
      placing--;
    }

    toRet.x = (counter % 60) * 20;
    toRet.y = (counter / 60) * 20;

    return toRet;
  }
}
