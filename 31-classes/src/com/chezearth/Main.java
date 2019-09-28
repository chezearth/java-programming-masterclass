package com.chezearth;

public class Main {

    public static void main(String[] args) {
        Car porsche = new Car();
        porsche.setModel("Carrera");
        System.out.println("Model is " + porsche.getModel());
        porsche.setModel("Skyline");
        System.out.println("Model is " + porsche.getModel());
        Car holden = new Car();
    }
}
