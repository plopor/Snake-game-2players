import java.util.Stack; //<>// //<>// //<>//
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

    int total = 60 * 35 - occupied.size();
    int placing = int(random(total));
    int counter = 0;

    for (int i = 0; i < placing; i++) {
      if (flattened[i] == 1)
        continue;
      counter++;
    }

    toRet.x = (counter % 60) * 20;
    toRet.y = (counter / 60) * 20;

    return toRet;
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

  void think(Snek other, PVector food, String method) {

    if (this.first) {
      food.x = 20;
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
    //grid[startX][startY] = -1;

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
      Stack<PVector> stack = new Stack<PVector>();
      Stack<PVector> path = new Stack<PVector>();
      if (orders.size() == 0 || lastFood.x != food.x || lastFood.y != food.y) {
        lastFood.x = food.x;
        lastFood.y = food.y;
        stack.push(new PVector(startX, startY));
        while (stack.size() != 0) {
          PVector curr = stack.pop();
          path.push(curr);
          if (grid[(int)curr.x][(int)curr.y] == 1) {
            while (path.size() > 1) {
              orders.push(path.pop());
            }
            //for (int i = 0; i < orders.size(); i++) {
            //  System.out.println(orders.get(i));
            //}
            break;
          }
          if (grid[(int)curr.x][(int)curr.y] == 3 || grid[(int)curr.x][(int)curr.y] == -2) {
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

        System.out.println("Size: " + orders.size());
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
    } else if (method == "BFS") {
      Queue<PVector> queue = new LinkedList<PVector>();
      Queue<ArrayList<PVector>> pathQ = new LinkedList<ArrayList<PVector>>();
      ArrayList<PVector> path = new ArrayList<PVector>();
      ArrayList<PVector> temp;
      if (orders.size() == 0 || lastFood.x != food.x || lastFood.y != food.y) {
        lastFood.x = food.x;
        lastFood.y = food.y;
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
          if (grid[(int)curr.x][(int)curr.y] == 3 || grid[(int)curr.x][(int)curr.y] == -2) {
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
    } else if (method == "A*") {
      // Dijkstra's is omitted since it is pretty redundant when all edge costs are the same
      // A* and the heuristic might save some node expansion though, so it's included

      PriorityQueue<ComparablePVec> pQueue = new PriorityQueue<ComparablePVec>();
      ArrayList<ComparablePVec> completed = new ArrayList<ComparablePVec>();
      PVector goal = new PVector(endX, endY);
      pQueue.add(new ComparablePVec(startX, startY, goal));

      if (orders.size() == 0 || lastFood.x != food.x || lastFood.y != food.y) {
        lastFood.x = food.x;
        lastFood.y = food.y;
        while (pQueue.size() != 0) {
          ComparablePVec curr = pQueue.remove();
          completed.add(curr);

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
          else if (grid[curr.x][curr.y] == 3 || grid[curr.x][curr.y] == -2) {
            completed.remove(completed.size() - 1);
            continue;
          }
          if ((int)curr.x < 59) {
            ComparablePVec toAdd = new ComparablePVec(curr.x + 1, curr.y, goal);
            toAdd.z += 1;
            toAdd.parent = curr;
            pQueue.add(toAdd);
          }
          if ((int)curr.y < 34) {
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
        }
        System.out.println("Size: " + orders.size());
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
    }
  }

  //MISC functions
}
