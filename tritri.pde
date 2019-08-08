import controlP5.*;

float rad;

// Angle and angular velocity, accleration
float theta;
float theta_vel;

int layerCount = 500;
float[] colors;
float forward;

// --UI Fiddles--
float rotation_modifier = 4;
float vertical_spacing = 42.0;
float diameter = 20.0;
float forward_speed = 3.0;
float forward_offset = 400;
float sin_scale_factor = 100;
float fn_amplitude = 100;
float lookahead_modifier = .5;
float tube_radius_buffer = 30;
float noise_shrinker = 2000;
float noise_grower = 2000;
// --/Fiddles--

SliderConfig[] sliders = {
  // --UI Sliders--
  new SliderConfig("rotation_modifier", 1.0, 10.0),
  new SliderConfig("vertical_spacing", 0.0, 200.0),
  new SliderConfig("diameter", 0.0, 100.0),
  new SliderConfig("forward_speed", 0.0, 20.0),
  new SliderConfig("forward_offset", 0.0, 1000.0),
  new SliderConfig("sin_scale_factor", 0, 400.0),
  new SliderConfig("fn_amplitude", 0, 400.0),
  new SliderConfig("lookahead_modifier", 0, 10.0),
  new SliderConfig("tube_radius_buffer", 0, 100.0),
  new SliderConfig("noise_shrinker", 0, 4000.0),
  new SliderConfig("noise_grower", 0, 3000.0),
  // --/Sliders
};


void setup() {
  size(1280, 720, P3D);

  // Initialize all values
  rad = height * 0.15;
  theta = 0;
  theta_vel = .005;
  forward = - width * 2 ;

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

PVector curveFn(float z) {
  float y = fn_amplitude * sin(z / (sin_scale_factor * PI));
  float x = -fn_amplitude * cos(z / (sin_scale_factor * PI));

  float xNoise = noise(z/noise_shrinker, -50);
  float yNoise = noise(z/noise_shrinker, 50);

  y = y + (yNoise - 1/2) * noise_grower;
  x = x + (xNoise - 1/2) * noise_grower;

  return new PVector(x, y, z);
}

PVector lookaheadPoint(float z) {
  PVector center = curveFn(z + forward_offset);
  center.z = center.z + forward_offset * lookahead_modifier;
  return center;
}

void drawNextTubeSection(PShape tube, float radius, float z, float spacing) {

  int sides = 10;
  float angle = 2 * PI / sides;

  PVector curve = curveFn(z);
  PVector nextCurve = curveFn(z + spacing);

  for (int i = 0; i < sides; i++) {
    float x = cos(i * angle) * radius;
    float y = sin(i * angle) * radius;
    tube.vertex(x + curve.x, y + curve.y, z);
    tube.vertex(x + nextCurve.x, y + nextCurve.y, z + spacing);
  }

}

void drawTri(float r, float t, float d, float z, float red, float green, float blue) {

  pushMatrix();

  PVector curve = curveFn(z);
  translate(curve.x, curve.y, z);

  for (float i = 0; i < 3; i++) {

    float tprime = t + (2 * PI / 3) * i;

    float x = r * cos(tprime);
    float y = r * sin(tprime);

    ellipseMode(CENTER);
    noStroke();
    fill(red, green, blue);
    // pushMatrix();
    // translate(x, y, 0);
    // sphere(d);
    // translate(-x, -y, 0);
    // popMatrix();
    ellipse(x, y, d, d);

  }

  popMatrix();
}

void draw() {

  background(0);

  pushMatrix();

  // Translate the origin point to the center of the screen
  translate(width/2, height/2, 0);
  PVector curve = curveFn(forward);
  println(noise(100, -50));
  PVector center = lookaheadPoint(forward);
  camera(curve.x, curve.y, curve.z,
              center.x, center.y, center.z,
              0, 1, 0);

  PShape tube = createShape();
  tube.beginShape(TRIANGLE_STRIP);
  tube.fill(0, 0, 0);
  tube.stroke(0, 255, 0);
  // tube.noStroke();
  tube.noFill();
  // tube.strokeWeight(1);

  for (float i = 0; i < layerCount; i++) {
    float r = rad;
    float offset = (PI / (rotation_modifier)) * (i - 1);
    float d = diameter;
    float z = (i - 100) * vertical_spacing;

    float red = colors[int(i) * 3];
    float green = colors[int(i) * 3 + 1];
    float blue = colors[int(i) * 3 + 2];

    //println(r);
    //println(offset);
    drawTri( r, theta + offset, d, z, red, green, blue);

    drawNextTubeSection(tube, r + tube_radius_buffer, z, vertical_spacing);
  }

  tube.endShape(CLOSE);
  // shape(tube);

  theta += theta_vel;

  forward += forward_speed;

  popMatrix();
}
