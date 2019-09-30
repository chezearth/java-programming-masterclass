package com.chezearth;

public class Vehicle {
    private int currentSteering;
    private int currentSpeed;
    private int wheels;
    private String name;

    public Vehicle(int currentSteering, int speed, int wheels, String name) {
        this.currentSteering = currentSteering;
        this.currentSpeed = speed;
        this.wheels = wheels;
        this.name = name;
    }

    public void setCurrentSteering(int currentSteering) {
        this.currentSteering = currentSteering;
    }

    public void setCurrentSpeed(int currentSpeed) {
        this.currentSpeed = currentSpeed;
    }

    public int getCurrentSteering() {
        return currentSteering;
    }

    public String getName() {
        return name;
    }

    public int getCurrentSpeed() {
        return currentSpeed;
    }

    public int getWheels() {
        return wheels;
    }

    public String steeringDescriptor() {

        if (this.currentSteering < 0) {
            return "Turning left";
        } else if (this.currentSteering > 0) {
            return "Turning right";
        } else {
            return "Straight ahead";
        }

    }

    public void accelerate(int extraSpeed) {

        if (extraSpeed < 0) {
            brake(Math.abs(extraSpeed));
//            System.out.println("> accelerate() result speed = " + getCurrentSpeed());
        } else {
            this.currentSpeed += extraSpeed;
//            System.out.println("> accelerate() result speed = " + getCurrentSpeed());
        }

    }

    public void brake(int reducedSpeed) {

        if (reducedSpeed < 0) {
            accelerate(Math.abs(reducedSpeed));
//            System.out.println("> brake() result speed = " + getCurrentSpeed());
        } else {
            this.currentSpeed -= reducedSpeed;
//            System.out.println("> brake() result speed = " + getCurrentSpeed());
        }
    }
}
