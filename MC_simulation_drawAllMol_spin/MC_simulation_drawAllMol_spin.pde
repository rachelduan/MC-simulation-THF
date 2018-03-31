int num = 3;
Table[] table = new Table[num];
float by;
float r = 4;
float x,y,z;
String filename; 
int count = 0;
void setup(){
  size(600,600,P3D);
  background(255);
  
  for(int i = 0; i < num; i++){
    filename = "coordinates" + String.valueOf(i) + ".csv";
    table[i] = loadTable(filename); 
  }
  by = 0;
}

void draw(){
  if(by>=height){
    by = 0;
    print(count);
    count = (count + 1) % num;}
  background(255);
  pushMatrix();
  translate(300,300,300);
  x = table[count].getFloat(0,0);
  y = table[count].getFloat(1,0);
  z = table[count].getFloat(2,0);
  pushMatrix();
  //rotateZ(map(by, 0, height, -PI, PI));
  rotateY(map(by, 0, width, -PI, PI));
  //rotateY(map(by, 0, height, -PI, PI));
  translate(x,y,z);
  sphere(r-1);
  
  popMatrix();

    for(int i=1;i<table[count].getColumnCount();i++){
    x = table[count].getFloat(0,i);
    y = table[count].getFloat(1,i);
    z = table[count].getFloat(2,i);
    r = table[count].getFloat(3,i);
    
    int index = (int)table[count].getFloat(4,i)-1;
 
    noStroke();
    lights();
    pushMatrix();
    if(abs(r-4)<0.0001){
      fill(50,70,86);
    }
    else{
      fill(225,225,225);
    }
    
    //rotateX(PI/4);
    //rotateZ(map(by, 0, width, 0, 2*PI));
    rotateY(map(by, 0, height, -PI, PI));
    translate(x,y,z);
    sphere(r-1);
    stroke(0);
   
    line(0,0,0,table[count].getFloat(0,index)-x,table[count].getFloat(1,index)-y,table[count].getFloat(2,index)-z);
    
    popMatrix();
  }
  popMatrix();
  by += PI/2.5; 
}