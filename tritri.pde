float rad;

// Angle and angular velocity, accleration
float theta;
float theta_vel;
float theta_acc;

void setup() {
  size(1280, 720);
  
  // Initialize all values
  rad = height * 0.15;
  theta = 0;
  theta_vel = .005;
  theta_acc = 0; //0.00001;
}

void drawAt(float r, float t, float d) {

  for (float i = 0; i < 3; i++) {
    
    float tprime = t + (2 * PI / 3) * i;
    
    float x = r * cos(tprime);
    float y = r * sin(tprime);
    
    ellipseMode(CENTER);
    noStroke();
    fill(200);
    ellipse(x, y, d, d);
    
  }
}

void draw() {
  
  background(0);
  
  // Translate the origin point to the center of the screen
  translate(width/2, height/2);
  
  for (float i = 0; i < 12; i++) {
    float r = rad * .1 * pow(1.5, i);
    float offset = (PI / 4) * (i - 1);
    float d = 20 * .1 * pow(1.5, i) + pow(1.1, r/50);
    //println(r);
    //println(offset);
    drawAt( r, theta + offset, d);
  }
  
  rad = rad + .2;
  
  theta_vel += theta_acc;
  theta += theta_vel;

}