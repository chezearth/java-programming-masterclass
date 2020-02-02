package com.chezearth;

public class Car extends Vehicle {
    private int currentGear;

    public Car(int currentSteering, int currentSpeed, String name, int currentGear) {
        super(currentSteering, currentSpeed, 4, name);
        this.currentGear = currentGear;
    }

    public void setCurrentGear(int currentGear) {

        if (currentGear < 0) {
            this.currentGear = 0;
        } else {
            this.currentGear = currentGear;
        }
    }

    public int getCurrentGear() {
        return currentGear;
    }

    @Override
    public void accelerate(int extraSpeed) {

        if (currentGear == 0) {
            extraSpeed = -getCurrentSpeed();
        } else if (currentGear == 1) {

            if (getCurrentSpeed() + extraSpeed > 10) {
                extraSpeed = 10 - getCurrentSpeed();
//                System.out.println("> > extra speed = " + extraSpeed);
            }

        } else if (currentGear == 2) {

            if (getCurrentSpeed() + extraSpeed > 30) {
                extraSpeed = 30 - getCurrentSpeed();
//                System.out.println("> > extra speed = " + extraSpeed);
            } else if (getCurrentSpeed() + extraSpeed < 10) {
                extraSpeed = -getCurrentSpeed();
//                System.out.println("> > extra speed = " + extraSpeed);
            }

        } else if (currentGear == 3) {

            if (getCurrentSpeed() + extraSpeed > 50) {
                extraSpeed = 50 - getCurrentSpeed();
//                System.out.println("> > extra speed = " + extraSpeed);
            } else if (getCurrentSpeed() + extraSpeed < 20) {
                extraSpeed = -getCurrentSpeed();
//                System.out.println("> > extra speed = " + extraSpeed);
            }

        } else {

            if (getCurrentSpeed() + extraSpeed > 80) {
                extraSpeed = 80 - getCurrentSpeed();
//                System.out.println("> > extra speed = " + extraSpeed);
            } else if (this.getCurrentSpeed() + extraSpeed < 40) {
                extraSpeed = -getCurrentSpeed();
//                System.out.println("> > extra speed = " + extraSpeed);
            }

        }

        super.accelerate(extraSpeed);

    }
}
