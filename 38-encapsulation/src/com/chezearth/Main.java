package com.chezearth;

public class Main {

    public static void main(String[] args) {
        Printer printer = new Printer(20, true);
        System.out.println("Number of pages printed = " + printer.getNumPagesPrinted());
        System.out.println("Toner level = " + printer.getTonerLevel());
        printer.fillToner(60);
        System.out.println("Number of pages printed = " + printer.getNumPagesPrinted());
        System.out.println("Toner level = " + printer.getTonerLevel());
        printer.printPages(30);
        System.out.println("Number of pages printed = " + printer.getNumPagesPrinted());
        System.out.println("Toner level = " + printer.getTonerLevel());
        printer.setDuplex(false);
        printer.fillToner(80);
        System.out.println("Number of pages printed = " + printer.getNumPagesPrinted());
        System.out.println("Toner level = " + printer.getTonerLevel());
        printer.printPages(43);
        System.out.println("Number of pages printed = " + printer.getNumPagesPrinted());
        System.out.println("Toner level = " + printer.getTonerLevel());
        printer.printPages(38);
        System.out.println("Number of pages printed = " + printer.getNumPagesPrinted());
        System.out.println("Toner level = " + printer.getTonerLevel());
    }


}
