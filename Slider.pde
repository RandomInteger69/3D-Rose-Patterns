class Slider{
    int max;
    int min;
    int len;
    int nobPos;
    int alpha;
    String label;
    PVector col;
    PVector  pos;

    Slider(int _max, int _min, PVector _pos, PVector _col, int _len, int _alpha, String _label){
        max = _max;
        min = _min;
        nobPos = min;
        len = _len;
        alpha = _alpha;
        label = _label;
        pos = new PVector(_pos.x, _pos.y, _pos.z);
        col = new PVector(_col.x, _col.y, _col.z);
    }


    void show(float _z){
        stroke(col.x, col.y, col.z, alpha);
        fill(col.x, col.y, col.z, alpha);
        strokeWeight(2);
        pos.z = _z;
        line(pos.x, pos.y, pos.z, pos.x+len, pos.y, pos.z);
        float newx = len * nobPos/max - width/2;
        strokeWeight(len/20);
        point(newx, pos.y, pos.z);
        textAlign(CENTER);
        textSize(len/20);
        text(label+str(nobPos), pos.x+len/2, pos.y+len/10, pos.z);
    }


    void enable(boolean sw){
        if(sw){
            alpha = 255;
        }
        else{
            alpha = 64;
        }
    }

    
    void update(boolean moveR){
        if(moveR){
            if(nobPos < max){
                nobPos++;
            }
        }
        else{
            if(nobPos > min){
                nobPos--;
            }
        }
    }


    int getVal(){
        return nobPos;
    }
}
