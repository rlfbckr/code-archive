class MultiBeam {
    PVector  origin;
    float rotation = 0;
    int size = 100;

    ArrayList beams = new ArrayList();
    MultiBeam(PVector origin, float rotation) {
        this.origin = origin;
        this.rotation = rotation;
        for (int i = 0; i < size; i++) {
            float ox = lerp(    origin.x - (cos(rotation + (PI / 2)) * size / 2),
                                origin.x + (cos(rotation + (PI / 2)) * size / 2),
                                (i / (size * 1.0))
                           );
            float oy = lerp(    origin.y - (sin(rotation + (PI / 2)) * size / 2),
                                origin.y + (sin(rotation + (PI / 2)) * size / 2),
                                (i / (size * 1.0))
                           );

            PVector oo = new PVector(ox, oy);
            Beam b = new Beam(oo, rotation);
            beams.add(b);
            println(i + " > adding beam: " + ox + " / " + oy + "     " + (i / size));
        }
    }

    void setMultiBeamRotation(float rot) {
        this.rotation = rot;
    }

    float getMultiBeamRotation() {
        return rotation;
    }

    void setMultiBeamOrigin(PVector origin) {
        this.origin = origin;
    }

    PVector getMultiBeamOrigin() {
        return origin;
    }

    float calcRotationAngle(PVector centerPt, PVector targetPt) {
        float theta = atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
        theta = ((PI / 2.0) - theta) + PI ; //offset
        return theta;
    }

    void draw() {
        if (DEBUG) {
            stroke(255, 0, 255);
            line(origin.x - (cos(rotation + (PI / 2)) * size / 2), origin.y - (sin(rotation + (PI / 2)) * size / 2), origin.x + (cos(rotation + (PI / 2)) * size / 2), origin.y + (sin(rotation + (PI / 2)) * size / 2));
        }
        for (int i = 0; i < beams.size(); i++) {
            Beam b = (Beam) beams.get(i);
            b.setBeamRotation(rotation);
            b.setBeamOrigin(    lerp(
                                    origin.x - (cos(rotation + (PI / 2)) * size / 2),
                                    origin.x + (cos(rotation + (PI / 2)) * size / 2),
                                    (i / (size * 1.0))
                                ),
                                lerp(
                                    origin.y - (sin(rotation + (PI / 2)) * size / 2),
                                    origin.y + (sin(rotation + (PI / 2)) * size / 2),
                                    (i / (size * 1.0))
                                )
                           );
            b.compReflection();
        }
    }
}