import peasy.*;

PeasyCam cam;
CameraState state;

float angle = 0;
int camD = 3000;
int sliderD = camD - 1300;
int targetFR = 60;
int refCount = targetFR/6;
long lcount = 0;

int r0;
int n0;
int d0;
boolean showR = true;
boolean showM = false;

Slider s1;
Slider s2;
boolean sliderSwitch = true;

ArrayList<PVector> rose = new ArrayList<PVector>();
ArrayList<PVector> mRose = new ArrayList<PVector>();


ArrayList<PVector> Rose(int n, int R){
    ArrayList<PVector> path = new ArrayList<PVector>();

    for(float i = 0; i < TWO_PI; i += 0.001){
        float k = i;
        float r = R * sin(k*n);
        float x = r * cos(k);
        float y = r * sin(k);
        float z = r * cos(k) * sin(k);
        path.add(new PVector(x, y, z));
    }
    return path;
}


ArrayList<PVector> maurerRose(int n, int d, int R){
    ArrayList<PVector> path = new ArrayList<PVector>();

    for(int i = 0; i < 360; i++){
        float k = i * d * PI/180;
        float r = R * sin(k*n);
        float x = r * cos(k);
        float y = r * sin(k);
        float z = r * cos(k) * sin(k);
        path.add(new PVector(x, y, z));
    }
    return path;
}


void setup(){
    fullScreen(P3D);
    frameRate(targetFR);
    cam = new PeasyCam(this, 0, 0, 0, camD);
    r0 = width * 19/40;
    s1 = new Slider(1000, 1, new PVector(-width/2, 50-height/2, sliderD), new PVector(0, 255, 255), width/5, 255, "N: ");
    s2 = new Slider(1000, 1, new PVector(-width/2, 200-height/2, sliderD), new PVector(0, 255, 255), width/5, 64, "D: ");
    n0 = s1.getVal();
    d0 = s2.getVal();
    rose = Rose(n0, r0);
    mRose = maurerRose(n0, d0, r0);
}


void draw(){
    background(0);
    noFill();

    stroke(255);
    strokeWeight(1);
    if(showM){
        beginShape();
        for(PVector v : mRose){
            vertex(v.x, v.y, v.z);
        }
        endShape(CLOSE);
    }

    stroke(255, 0, 127);
    strokeWeight(2);
    if(showR){
        beginShape();
        for(PVector v : rose){
            vertex(v.x, v.y, v.z);
        }
        endShape(CLOSE);
    }
   
    updateSliders();
    eventHandler();
    //line(0, 0, 400, 400);
    //println(cam.getDistance());
    //println(cam.getLookAt());
    //println(cam.getPosition()); // returns array of length 3 which contains the postion values of the camera 
    //println(cam.getRotations()); // returns array of length 3 which contains the the rotation values for the specific axis (between -PI and PI) 
}


void updateSliders(){
    float x0 = cam.getLookAt()[0];
    float y0 = cam.getLookAt()[1];
    float z0 = cam.getLookAt()[2];
    
    if(x0 != 0 || y0 != 0 || z0 != 0){
        cam.lookAt(0, 0, 0);
    }

    float x1 = cam.getPosition()[0];
    float y1 = cam.getPosition()[1];
    float z1 = cam.getPosition()[2];

    PVector v = new PVector(x0-x1, y0-y1, z0-z1);
    float d = v.mag();
    
    float rx = cam.getRotations()[0];
    float ry = cam.getRotations()[1];
    float rz = cam.getRotations()[2];
    
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    
    //translate(x0,y0,z0);
    float newz = d - 1300;
    s1.show(newz);
    s2.show(newz);
}


void eventHandler(){
    if(!keyPressed){
        return;
    }
  
    if(key == CODED){
        if(keyCode == UP){
            sliderSwitch = true;
            s1.enable(true);
            s2.enable(false);
        }

        else if(keyCode == DOWN){
            sliderSwitch = false;
            s1.enable(false);
            s2.enable(true);
        }

        else if(keyCode == RIGHT && frameCount-lcount >= refCount){
            if(sliderSwitch){
                s1.update(true);
            }
            else{
                s2.update(true);
            }
            n0 = s1.getVal();
            d0 = s2.getVal();
            rose = Rose(n0, r0);
            mRose = maurerRose(n0, d0, r0);
            lcount = frameCount;
        }

        else if(keyCode == LEFT && frameCount-lcount >= refCount){
            if(sliderSwitch){
                s1.update(false);
            }
            else{
                s2.update(false);
            }
            n0 = s1.getVal();
            d0 = s2.getVal();
            rose = Rose(n0, r0);
            mRose = maurerRose(n0, d0, r0);
            lcount = frameCount;
        }
    }
}


void keyReleased(){
    if(key == 'r' || key == 'R'){
            showR = !showR;
    }
    else if(key == 'm' || key == 'M'){
            showM = !showM;
    }
}
