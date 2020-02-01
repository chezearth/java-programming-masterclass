package com.chezearth;

public class Car {

    private String name;
    private boolean engine;
    private int cylinders;
    private int wheels;
    private boolean fourWheelDrive;
    private int doors;
    private boolean engineRunning;
    private int speed;

    public Car(String name, int cylinders, boolean fourWheelDrive, int doors) {
        this.name = name;
        this.engine = true;
        this.cylinders = cylinders;
        this.wheels = 4;
        this.fourWheelDrive = fourWheelDrive;
        this.doors = doors;
        this.speed = 0;
        this.engineRunning = false;
    }

    public String getName() {
        return name;
    }

    public boolean isEngine() {
        return engine;
    }

    public int getCylinders() {
        return cylinders;
    }

    public int getWheels() {
        return wheels;
    }

    public boolean isFourWheelDrive() {
        return fourWheelDrive;
    }

    public int getDoors() {
        return doors;
    }

    public boolean isEngineRunning() {
        return engineRunning;
    }

    public int getSpeed() {
        return speed;
    }

    public String describe(String className) {
        return className + " name is " + this.name + " and it has " + this.doors + " doors, with " +
                "a" +
                " " + this.cylinders + "-cylinder engine";
    }

    public void setSpeed(int speed) {
        this.speed = speed;
    }

    public String startEngine() {
        this.speed = 0;
        this.engineRunning = true;
        return "Engine is now running";
    }

    public String accelerate() {

        if (engineRunning) {
            this.speed += 20;
            return "Car is speeding up to " + this.getSpeed() + " mph";
        } else {
            return "Start the engine first!";
        }

    }

    public String brake() {

        this.speed -= 30;

        if (this.speed < 30) {
            this.speed = 0;
            return "Car has stopped";
        }

        return "Car is slowing down to " + this.getSpeed() + " mph";
    }
}
