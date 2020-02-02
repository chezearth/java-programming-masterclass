package com.chezearth;

public class HealthyBurger extends Hamburger {

    private String addition5Name;
    private double addition5Price;
    private String addition6Name;
    private double addition6Price;

    public HealthyBurger(String meat, double price) {
        super( "Healthy","brown rye bread", meat, price);
    }

    public void addAddition5(String name, double price) {
        this.addition5Name = name;
        this.addition5Price = price;
    }

    public  void addAddition6(String name, double price) {
        this.addition6Name = name;
        this.addition6Price = price;
    }

    @Override
    public double itemisedHamburger() {
        double subTotal = super.itemisedHamburger();

        if (this.addition5Name != null) {
            subTotal += this.addition5Price;
            System.out.println("additional "
                    + this.addition5Name
                    + ": "
                    + this.addition5Price
                    + " subtotal: "
                    + (double) Math.round(subTotal * 100) / 100
            );
        }

        if (this.addition6Name != null) {
            subTotal += this.addition6Price;
            System.out.println("additional "
                    + this.addition6Name
                    + ": "
                    + this.addition6Price
                    + " subtotal: "
                    + (double) Math.round(subTotal * 100) / 100
            );
        }

        return Math.round(subTotal * 100)/100;
    }

}
