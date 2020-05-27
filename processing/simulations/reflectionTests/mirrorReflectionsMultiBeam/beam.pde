class Beam {
    PVector beamOrigin;
    float beamRotation = 0;

    Beam(PVector beamOrigin, float beamRotation) {
        this.beamOrigin = beamOrigin;
        this.beamRotation = beamRotation;
    }

    void setBeamRotation(float rot) {
        this.beamRotation = rot;
    }

    float getBeamRotation() {
        return beamRotation;
    }

    void setBeamOrigin(float x, float y) {
        beamOrigin.x = x;
        beamOrigin.y = y;
    }
    void setBeamOrigin(PVector newBeamOrigin) {
        this.beamOrigin = newBeamOrigin;
    }
    PVector getBeamOrigin() {
        return beamOrigin;
    }

    void compReflection() {
        compReflection(beamOrigin, beamRotation, 0, null);
    }


    void compReflection(PVector origin, float direction, int depth, Mirror currentMirror) {
        if (depth > MAX_REFLECTION_DEPTH) return; // max recursion

        PVector finite = new PVector((float) (origin.x + (Math.cos(direction) * 4000)), (float) (origin.y + (Math.sin(direction) * 4000)));

        if (DEBUG) {
            stroke(40);
            line(origin.x, origin.y, finite.x, finite.y);
        }
        Intersection inter = findFirstIntersection(origin, finite, currentMirror);
        if (inter != null) {
            // println(depth + " > INTERSECION FOUND  ---> " + inter.p.x + "   " + inter.p.y);
            // draw beam
            stroke(map(depth, 0, MAX_REFLECTION_DEPTH, 255, 10), map(depth, 0, MAX_REFLECTION_DEPTH, 255, 10), map(depth, 0, MAX_REFLECTION_DEPTH, 200, 10),128); // fade out beam color...
            line(origin.x, origin.y, inter.p.x, inter.p.y);

            float centerangle = -inter.mirror.getAngle();
            PVector tangente = new PVector((float) (inter.p.x + (cos(centerangle) * 100)), (float) (inter.p.y + (sin(centerangle) * 100)));
            if (DEBUG) {
                stroke(25, 250, 90);
                line(inter.p.x, inter.p.y, tangente.x, tangente.y);
            }
            float ta = calcRotationAngle(inter.p, tangente);
            float la = calcRotationAngle(inter.p, origin);
            float diff = ta - la;
            float returnangle = centerangle - diff ;
            compReflection(inter.p, returnangle, depth + 1, inter.mirror); // recursion :)

        } else {
            // println(depth + " > NO_INTERSECTION");
            // draw beam into the infinit....
            stroke(255, 255, 200,128);
            line(origin.x, origin.y, finite.x, finite.y);
        }
    }

    float calcRotationAngle(PVector centerPt, PVector targetPt) {
        float theta = atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
        theta = ((PI / 2.0) - theta) + PI ; //offset
        return theta;
    }

}