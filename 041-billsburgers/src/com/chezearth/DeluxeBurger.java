package com.chezearth;

public class DeluxeBurger extends Hamburger {

    public DeluxeBurger(String rollType, String meat, double price) {
        super("Deluxe", rollType, meat, price);
        super.addAddition1("chips", 0);
        super.addAddition2("drink", 0);
    }

    @Override
    public void addAddition1(String name, double price) {
        return;
    }

    @Override
    public  void addAddition2(String name, double price) {
        return;
    }

    @Override
    public void addAddition3(String name, double price) {
        return;
    }

    @Override
    public void addAddition4(String name, double price) {
        return;
    }

}
