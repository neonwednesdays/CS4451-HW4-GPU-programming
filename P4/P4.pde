//Declare global variables
PShader floorShader;
PShader cheeseShader;
PShader mandelbrotShader;
PShader duckShader;
PShader mountainShader;
PImage duckTexture;
PImage gradientTexture;

float offsetY;
float offsetX;
float zoom;
boolean locked = false;
float dirY = 0;
float dirX = 0;

//initialize variables and load shaders
void setup() {
  size(640, 640, P3D);
  offsetX = width/2;
  offsetX = height/2;
  noStroke();
  fill(204);
  
  duckTexture = loadImage("data/duck.bmp");
  gradientTexture = loadImage("data/RGBgradient.jpg");
  floorShader = loadShader("data/card0.frag", "data/card0.vert");
  cheeseShader = loadShader("data/card1.frag", "data/card1.vert");
  mandelbrotShader = loadShader("data/card2.frag", "data/card2.vert");
  duckShader = loadShader("data/card3.frag", "data/card3.vert");
  mountainShader = loadShader("data/card4.frag", "data/card4.vert");
}

void draw() {
  
  background(0); 
  
  //control the scene rotation via the current mouse location
  if(!locked){
    dirY = (mouseY / float(height) - 0.5) * 2;
    dirX = (mouseX / float(width) - 0.5) * 2;
  }
  
  //if the mouse is pressed, update the x and z camera locations
  if (mousePressed){
    offsetY += (mouseY - pmouseY);
    offsetX += (mouseX - pmouseX);
  }
  
  //create a single directional light
  directionalLight(204, 204, 204, 0, 0, -1);
  
  //translate and rotate all objects to simulate a camera
  //NOTE: processing +y points DOWN
  translate(offsetX, offsetY, zoom);
  rotateY(-dirX);
  rotateX(dirY);
  
  //Render a floor plane with the default shader
  shader(floorShader);
  beginShape();
    vertex(-300, 300, -400);
    vertex( 300, 300, -400);
    vertex( 300, 300,  200);
    vertex(-300, 300,  200);
  endShape();
  
  //Render the "Swiss Cheese" shader (card1)
  shader(cheeseShader);
  beginShape();
    vertex(50,  50,  -300, 0,0);
    vertex(300, 50,  -300, 1,0);
    vertex(300, 300, -300, 1,1);
    vertex(50,  300, -300, 0,1);
  endShape();
  
  //Render the "Mandelbrot" shader (card2)
  shader(mandelbrotShader);
  textureMode(NORMAL);
  beginShape();
    vertex(50,  50,  100, 0,0);
    vertex(300, 50,  100, 1,0);
    vertex(300, 300, 100, 1,1);
    vertex(50,  300, 100, 0,1);
  endShape();
  
  //Render the "Duck" shader (card3)
  shader(duckShader);
  textureMode(NORMAL);
  beginShape();
    texture(duckTexture);
    vertex(-300, 50,  -300, 0,0);
    vertex(-50,  50,  -300, 1,0);
    vertex(-50,  300, -300, 1,1);
    vertex(-300, 300, -300, 0,1);
  endShape();
  
  //Render the "Terrain" shader (card4)
  //You will need to subdivide this card in x and y
  shader(mountainShader);
  float xmin = -300.0;
  float xmax = -50.0;
  float ymin = 50.0;
  float ymax = 300.0;
  float zmin = 100.0;
  float zmax = 100.0;
  
  int iterations = 20;
  float xint = (float)(xmax-xmin)/iterations;
  float yint = (float)(ymax-ymin)/iterations;
  
  float uint = (float)1/iterations;

  for(float x = 0; x<iterations; x++){
    for(float y = 0; y<iterations; y++){

      beginShape();
        texture(gradientTexture);

        vertex(x*xint - 300, y*yint + 50, 100, x*uint, y*uint);
        vertex(x*xint - 300 + xint, y*yint + 50, 100, (x+1)*uint, y*uint);
        vertex(x*xint - 300 + xint, y*yint + 50 + yint, 100, (x+1)*uint, (y+1)*uint);
        vertex(x*xint - 300, y*yint + 50 + yint, 100, x*uint, (y+1)*uint);
        
//        print("\n");
//        print("\npos x: "+ (x*xint - 300) + " y: "+(y*yint + 50));
//        print("\npos x: "+ (x*xint - 50) + " y: "+(y*yint + 50));
//        print("\npos x: "+ (x*xint - 50) + " y: "+(y*yint + 300));
//        print("\npos x: "+ (x*xint - 300) + " y: "+(y*yint + 300));
        
      endShape();
    }
  }

}

void keyPressed(){
  if(key == ' '){
    locked = !locked;
  }else if(key == '1'){
    gradientTexture = loadImage("data/gradient3.jpg");
  }else if(key == '2'){
    gradientTexture = loadImage("data/gradient2.jpg");
  }else if(key == '3'){
    gradientTexture = loadImage("data/gradient.jpg");
  }else if(key == '4'){
    gradientTexture = loadImage("data/RGBgradient.jpg");
  }else if(key == '5'){
    gradientTexture = loadImage("data/RGBgradient2.jpg");
  }
}

void mouseWheel(MouseEvent event) {
  zoom += event.getAmount()*12.0;
}
