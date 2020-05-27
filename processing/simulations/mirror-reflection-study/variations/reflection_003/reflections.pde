void compReflection(PVector origin, float direction, int depth, Mirror currentMirror) {
    if (depth > MAX_REFLECTION_DEPTH) return; // max recursion

    PVector finite = new PVector((float) (origin.x + (Math.cos(direction) * 4000)), (float) (origin.y + (Math.sin(direction) * 4000)));

    if (DEBUG) {
        stroke(40);
        line(origin.x, origin.y, finite.x, finite.y);
    }
    Intersection inter = findFirstIntersection(origin, finite, currentMirror);
    if (inter != null) {
        // println(depth + " > I N T E R  ---> " + inter.p.x + "   " + inter.p.y);
        // draw beam
        stroke(map(depth,0,MAX_REFLECTION_DEPTH,255,10), 0, 0);
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
        // println(depth + " > NO_INTER");
        // draw beam into the infinit....
        stroke(255, 0, 0);
        line(origin.x, origin.y, finite.x, finite.y);
    }
}
