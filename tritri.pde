import controlP5.*;

float rad;

// Angle and angular velocity, accleration
float theta;
float theta_vel;
float theta_acc;

int layerCount = 500;
float[] colors;
float forward;

// UI Fiddles.
float rotation_modifier = 4;
float vertical_spacing = 42.0;
float diameter = 20.0;
float forward_speed = 3.0;
float radin = 0.0;

SliderConfig[] sliders = {
  new SliderConfig("rotation_modifier", 1.0, 10.0),
  new SliderConfig("vertical_spacing", 0.0, 200.0),
  new SliderConfig("diameter", 0.0, 100.0),
  new SliderConfig("forward_speed", 0.0, 20.0)
};


void setup() {
  size(1280, 720, P3D);

  // Initialize all values
  rad = height * 0.15;
  theta = 0;
  theta_vel = .005;
  theta_acc = 0;
  forward = 0;

  setupColors();
  setupGUI();
}

void setupColors() {
  colors = new float[layerCount * 3];
  for (int i = 0; i < layerCount; i++) {
    float red = random(255);
    float green = random(255);
    float blue = random(255);

    colors[i * 3] = red;
    colors[i * 3 + 1] = green;
    colors[i * 3 + 2] = blue;
  }
}


public class SliderConfig {
  public String name;
  public float min;
  public float max;

  public SliderConfig(String name, float min, float max){
    this.name = name;
    this.min = min;
    this.max = max;

  }
}

void setupGUI() {
  ControlP5 cp5 = new ControlP5(this);

  int sY = 10;
  int sHeight = 15;
  for (SliderConfig slider : sliders) {
    cp5.addSlider(slider.name, slider.min, slider.max, 10, sY, 200, sHeight).setLabel(slider.name);
    sY = sY + sHeight + 5;
  }

}

void drawTri(float r, float t, float d, float z, float red, float green, float blue) {

  pushMatrix();
  translate(0,0,z);

  for (float i = 0; i < 3; i++) {

    float tprime = t + (2 * PI / 3) * i;

    float x = r * cos(tprime);
    float y = r * sin(tprime);

    ellipseMode(CENTER);
    noStroke();
    fill(red, green, blue);
    ellipse(x, y, d, d);

  }

  popMatrix();
}

void draw() {


  background(0);

  pushMatrix();

  // Translate the origin point to the center of the screen
  translate(width/2, height/2, forward);

  float rot_spin = (sin(radin) + 1);
  radin += .0001;

  for (float i = 0; i < layerCount; i++) {
    float r = rad;
    float offset = (PI / (rotation_modifier + rot_spin)) * (i - 1);
    float d = diameter;
    float z = (i - 450) * vertical_spacing;

    float red = colors[int(i) * 3];
    float green = colors[int(i) * 3 + 1];
    float blue = colors[int(i) * 3 + 2];

    //println(r);
    //println(offset);
    drawTri( r, theta + offset, d, z, red, green, blue);
  }

  theta_vel += theta_acc;
  //theta += theta_vel;

  forward += forward_speed;

  popMatrix();
}
