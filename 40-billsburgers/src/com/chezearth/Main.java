package com.chezearth;

public class Main {

    public static void main(String[] args) {
	    Hamburger hamburger = new Hamburger("Standard","white sesame", "beef", 39.90);
	    hamburger.addAddition1("lettuce", 5.99);
	    hamburger.addAddition2("tomato", 4.99);
	    hamburger.addAddition3("cheese slice", 12.99);
	    hamburger.itemisedHamburger();

	    HealthyBurger healthyBurger = new HealthyBurger("turkey", 62.49);
	    healthyBurger.addAddition1("lettuce", 2.99);
        healthyBurger.addAddition2("tomato", 1.99);
        healthyBurger.addAddition3("feta cheese", 15.99);
        healthyBurger.addAddition4("pineapple", 5.99);
        healthyBurger.addAddition5("gerkin", 12.99);
        healthyBurger.addAddition6("green beans", 3.99);
        healthyBurger.itemisedHamburger();

        DeluxeBurger deluxeBurger = new DeluxeBurger( "sesame", "fatty beef", 119.99);
        deluxeBurger.addAddition1("lettuce", 2.99);
        deluxeBurger.addAddition2("tomato", 1.99);
        deluxeBurger.addAddition3("feta cheese", 15.99);
        deluxeBurger.addAddition4("pineapple", 5.99);
        deluxeBurger.itemisedHamburger();
    }
}
