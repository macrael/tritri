float rad;

// Angle and angular velocity, accleration
float theta;
float theta_vel;
float theta_acc;

float forward; 

void setup() {
  size(1280, 720, P3D);
  
  // Initialize all values
  rad = height * 0.15;
  theta = 0;
  theta_vel = .005;
  theta_acc = 0;
  forward = 0;
}

void drawTri(float r, float t, float d, float z) {

  pushMatrix();
  translate(0,0,z);
  
  for (float i = 0; i < 3; i++) {
    
    float tprime = t + (2 * PI / 3) * i;
    
    float x = r * cos(tprime);
    float y = r * sin(tprime);
    
    ellipseMode(CENTER);
    noStroke();
    fill(200);
    ellipse(x, y, d, d);
    
  }
  
  popMatrix();
}

void draw() {
  
  background(0);
  
  // Translate the origin point to the center of the screen
  translate(width/2, height/2, forward);
  
  for (float i = 0; i < 500; i++) {
    float r = rad;
    float offset = (PI / 4) * (i - 1);
    float d = 20;
    float z = (i - 450) * 50;
    
    //println(r);
    //println(offset);
    drawTri( r, theta + offset, d, z);
  }
  
  theta_vel += theta_acc;
  theta += theta_vel;

  forward += 5;

}