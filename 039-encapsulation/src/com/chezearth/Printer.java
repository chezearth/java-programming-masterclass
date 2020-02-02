package com.chezearth;

public class Printer {

    private int tonerLevel = 100;
    private int numPagesPrinted;
    private boolean isDuplex;

    public Printer(int tonerLevel, boolean isDuplex) {

        this.tonerLevel = tonerCheck(tonerLevel);
        this.numPagesPrinted = 0;
        this.isDuplex = isDuplex;
    }

    public int getTonerLevel() {
        return tonerLevel;
    }

    public int getNumPagesPrinted() {
        return numPagesPrinted;
    }

    public boolean getIsDuplex() {
        return isDuplex;
    }

    public void printPages(int numPrinted) {

        if (tonerLevel / 2 < numPrinted) {
            numPrinted = tonerLevel / 2;
        }

        if (this.isDuplex) {
            numPrinted /= 2 + numPrinted % 2;
            System.out.println("Printing in Duplex Mode");
        }

        this.numPagesPrinted = numPrinted;
        this.tonerLevel = tonerCheck(this.tonerLevel - numPrinted * 2);
    }

    private int tonerCheck(int tonerLevel) {

        if (tonerLevel > 0 && tonerLevel < 100) {
            return tonerLevel;
        } else if (tonerLevel >= 100 ){
            return 100;
        }
        return 0;

    }

    public void fillToner(int tonerAdded) {
        this.tonerLevel = tonerCheck(this.tonerLevel + (tonerAdded < 0 ? 0 : tonerAdded));
    }

    public void setDuplex(boolean duplex) {
        this.isDuplex = duplex;
        System.out.println("Changed to " + (duplex ? "Duplex Mode" : "Non-duplex Mode"));
    }

}
