class Intersection {
    Mirror mirror;
    PVector p;
    Intersection(Mirror mirror, PVector p) {
        this.mirror = mirror;
        this.p = p;
    }
}


Intersection findFirstIntersection(PVector start, PVector end, Mirror currentMirror) {  //closest intersection...
    ArrayList possibleIntersections = new ArrayList();
    for (int i = 0; i < mirrors.size(); i++) {
        Mirror m = (Mirror) mirrors.get(i);
        if (m.isBoundary() && USE_BOUNDARY == false) {
            continue;
        }
        if (m != currentMirror) {
            PVector testintersection = segIntersection(start.x, start.y, end.x, end.y, m.p1.x, m.p1.y, m.p2.x, m.p2.y);

            if (testintersection != null) {
                stroke( 255, 255, 0 );
                noFill();
                if (DEBUG) ellipse( testintersection.x, testintersection.y, 10, 10 );
                Intersection in =  new Intersection(m, testintersection);
                possibleIntersections.add(in);
            }
        }
    }

    if (possibleIntersections.size() == 1) {
        return (Intersection) possibleIntersections.get(0);
    }
    if (possibleIntersections.size() > 1) {
        // find the closest intersection
        Intersection closest = (Intersection) possibleIntersections.get(0);
        float closestdist = dist (start.x, start.y, closest.p.x, closest.p.y);
        for (int i = 1; i < possibleIntersections.size(); i++) {
            Intersection is = (Intersection) possibleIntersections.get(i);
            float isdist = dist (start.x, start.y, is.p.x, is.p.y);

            if (isdist < closestdist ) {
                closest = is;
                closestdist = isdist;
            }
        }
        return closest;
    }

    return null;
}



Intersection findIntersection(PVector start, PVector end) {
    for (int i = 0; i < mirrors.size(); i++) {
        Mirror m = (Mirror) mirrors.get(i);
        PVector testintersection = segIntersection(start.x, start.y, end.x, end.y, m.p1.x, m.p1.y, m.p2.x, m.p2.y);

        if (testintersection != null) {
            stroke( 255, 255, 0 );
            ellipse( testintersection.x, testintersection.y, 10, 10 );
            return new Intersection(m, testintersection);
        }


    }
    return null;
}


PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    double bx = x2 - x1;
    double by = y2 - y1;

    double dx = x4 - x3;
    double dy = y4 - y3;
    double b_dot_d_perp = bx * dy - by * dx;
    if (b_dot_d_perp == 0) {
        return null;
    }
    double cx = x3 - x1;
    double cy = y3 - y1;
    double t = (cx * dy - cy * dx) / b_dot_d_perp;
    if (t < 0 || t > 1) {
        return null;
    }
    double u = (cx * by - cy * bx) / b_dot_d_perp;
    if (u < 0 || u > 1) {
        return null;
    }
    return new PVector( (float) (x1 + t * bx), (float) (y1 + t * by)) ;
}
