import java.util.Comparator;
import java.lang.Math;

class ComparablePVec implements Comparable<ComparablePVec>{
  public int x = 0;
  public int y = 0;
  public float z = 0;
  public ComparablePVec parent = null;
  
  ComparablePVec(int x, int y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  ComparablePVec(int x, int y, PVector end){
    this.x = x;
    this.y = y;
    z = sqrt((float)(Math.pow(abs(x - end.x), 2) + Math.pow(abs(y - end.y), 2)));
  }
  
  @Override
  public int compareTo(ComparablePVec other){
    if (this.z > other.z)
      return 1;
    return -1;
  }
}
