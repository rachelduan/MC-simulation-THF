Table table;
float by;
float r = 4;
float x,y,z;
String filename; 
int count = 0;
void setup(){
  size(600,600,P3D);
  background(255);
  filename = "coordinates.csv";
  table = loadTable(filename); 
  by = 0;
}

void draw(){
  if(by>=height){
    by = 0;}
  background(255);
  pushMatrix();
  translate(300,300,300);
  x = table.getFloat(0,0);
  y = table.getFloat(1,0);
  z = table.getFloat(2,0);
  pushMatrix();
  //rotateZ(map(by, 0, height, -PI, PI));
  rotateY(map(by, 0, width, -PI, PI));
  //rotateY(map(by, 0, height, -PI, PI));
  translate(x,y,z);
  sphere(r-1);
  
  popMatrix();

    for(int i=1;i<table.getColumnCount();i++){
    x = table.getFloat(0,i);
    y = table.getFloat(1,i);
    z = table.getFloat(2,i);
    r = table.getFloat(3,i);
    
    int index = (int)table.getFloat(4,i)-1;
 
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
   
    line(0,0,0,table.getFloat(0,index)-x,table.getFloat(1,index)-y,table.getFloat(2,index)-z);
    
    popMatrix();
  }
  popMatrix();
  by += PI/2.5; 
}