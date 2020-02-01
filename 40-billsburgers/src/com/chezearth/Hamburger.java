package com.chezearth;

public class Hamburger {

    private String name;
    private String breadRollType;
    private String meat;
    private double basePrice = 39.99;
    private String addition1Name;
    private double addition1Price;
    private String addition2Name;
    private double addition2Price;
    private String addition3Name;
    private double addition3Price;
    private String addition4Name;
    private double addition4Price;

    public Hamburger(String name, String breadRollType, String meat, double basePrice) {
        this.name = name;
        this.breadRollType = breadRollType;
        this.meat = meat;
        this.basePrice = basePrice;
    }

    public void addAddition1(String name, double price) {
        this.addition1Name = name;
        this.addition1Price = price;
    }

    public void addAddition2(String name, double price) {
        this.addition2Name = name;
        this.addition2Price = price;
    }

    public void addAddition3(String name, double price) {
//        System.out.println(name + " " + price);
        this.addition3Name = name;
        this.addition3Price = price;
//        System.out.println(this.addition3Name + " " + this.addition3Price);
    }

    public void addAddition4(String name, double price) {
        this.addition4Name = name;
        this.addition4Price = price;
    }

    public double itemisedHamburger() {
        double subTotal = this.basePrice;

        System.out.println("Total price of "
                + this.name
                + " burger made from "
                + this.breadRollType
                + " and "
                + this.meat
                + ":");
        System.out.println("base price: " + this.basePrice);

        if (this.addition1Name != null) {
            subTotal += this.addition1Price;
            System.out.println("additional "
                    + this.addition1Name
                    + ": "
                    + this.addition1Price
                    + " subtotal: "
                    + (double) Math.round(subTotal * 100) / 100
            );
        }

        if (this.addition2Name != null) {
            subTotal += this.addition2Price;
            System.out.println("additional "
                    + this.addition2Name
                    + ": "
                    + this.addition2Price
                    + " subtotal: "
                    + (double) Math.round(subTotal * 100) / 100
            );
        }

        if (this.addition3Name != null) {
            subTotal += this.addition3Price;
            System.out.println("additional "
                    + this.addition3Name
                    + ": "
                    + this.addition3Price
                    + " subtotal: "
                    + (double) Math.round(subTotal * 100) / 100
            );
        }

        if (this.addition4Name != null) {
            subTotal += this.addition4Price;
            System.out.println("additional "
                    + this.addition4Name
                    + ": "
                    + this.addition4Price
                    + " subtotal: "
                    + (double) Math.round(subTotal * 100) / 100
            );
        }

        return Math.round(subTotal * 100)/100;
    }
}


