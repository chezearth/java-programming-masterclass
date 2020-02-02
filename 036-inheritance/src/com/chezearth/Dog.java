package com.chezearth;

public class Dog extends Animal {
    private int eyes;
    private int legs;
    private int tail;
    private int teeth;
    private String coat;

    public Dog(
        String name,
        int brain,
        int body,
        int size,
        int weight,
        int eyes,
        int legs,
        int tail,
        int teeth,
        String coat
    ) {
        super(name, brain, body, size, weight);
        this.eyes = eyes;
        this.legs = legs;
        this.tail = tail;
        this.teeth = teeth;
        this.coat = coat;
    }

    public void chew() {
        System.out.println("Dog chewing");
    }

    @Override
    public void eat() {
        System.out.println("Dog eating");
        chew();
        super.eat();
    }

    public void walk() {
        System.out.println("Dog walking");
        move(5);
    }

    public void  run() {
        System.out.println("Dog running");
        move(20);
    }
}
