package com.chezearth;

public class LandRover extends Car {
    private boolean fourWheelDrive;

    public LandRover(int steering, int speed, String name, int gear, boolean fourWheelDrive) {
        super(steering, speed, name, gear);
        this.fourWheelDrive = fourWheelDrive;
    }

    public void setFourWheelDrive(boolean fourWheelDrive) {
        this.fourWheelDrive = fourWheelDrive;
    }

    public boolean isFourWheelDrive() {
        return fourWheelDrive;
    }
}
