class SerialCommunication extends Thread {
  public SerialCommunication() {
    println("init SerialCommunication");
  }

  public void start() {
    super.start();
  }

  public void run() {
    while (true) {
      // do stuff here
      println("forever...");
      delay(1000);
    }
  }
}
