package com.chezearth;

public class Computer {
    private Case theCase;
    private Monitor monitor;
    private Motherboard motherboard;

    public Computer(Case theCase, Monitor monitor, Motherboard motherboard) {
        this.theCase = theCase;
        this.monitor = monitor;
        this.motherboard = motherboard;
    }

    public void powerUp() {
        theCase.pressPowerButton();
        drawLogo();
    }

    public void drawLogo() {
        // fancy graphics
        monitor.drawPixelAt(1200, 50, "grey");
    }

//    private Case getTheCase() {
//        return theCase;
//    }
//
//    private Monitor getMonitor() {
//        return monitor;
//    }
//
//    private Motherboard getMotherboard() {
//        return motherboard;
//    }
}
