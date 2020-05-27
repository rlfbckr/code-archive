class Mirror  {
    PVector p1;
    PVector p2;
    boolean isBoundayElement = false;
    Mirror(PVector p1, PVector p2) {
        this.p1 = p1;
        this.p2 = p2;
    }
    Mirror(PVector p1, PVector p2, boolean isBoundayElement) {
        this.p1 = p1;
        this.p2 = p2;
        this.isBoundayElement = isBoundayElement;
    }
    void setBoundary(boolean b) {
        isBoundayElement = b;
    }
    boolean isBoundary() {
        return isBoundayElement;
    }
    float getAngle() {
        return calcRotationAngle(p1, p2);
    }

    void draw() {
        stroke(128);
        if (isBoundayElement) {
            stroke(0,255,0);
        }
        line(p1.x, p1.y, p2.x, p2.y);
    }
}