class shiftRegister {
    int size = 100;
    int[] register;

    shiftRegister(int size) {
        this.size = size;
        register = new int[size];
    }

    int getSize() {
        return size;
    }

    void add(int number) {
        for (int i = size -2;i>0;i--) {
            register[i] = register[i-1];
        }
        register[0] = number;
    }

    int get(int pos) {
        return register[pos];
    }
}