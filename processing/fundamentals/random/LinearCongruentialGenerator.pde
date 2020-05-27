class LinearCongruentialGenerator {
    int number = 0;
    int m = 9; // modulo (max value of random number)
    int a = 2; // multiplyer 1103515245
    int c = 0; // increment 12345

    LinearCongruentialGenerator(int seed) {
        number = seed;
    }

    void setMultiplyer(int n) {
        a = n;
    }

    void setIncement(int n) {
        c = n;
    }

    void setModulo(int n) {
        m = n;
    }

    int next() {
        number = (a * number + c) % m;
        return number;
    }
}