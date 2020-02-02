package com.chezearth;

public class Ford extends  Car {

    public Ford(String name, int doors) {
        super(name, 8, true, doors);
    }

    @Override
    public String accelerate() {
        if (this.isEngineRunning()) {
            this.setSpeed(this.getSpeed() + 25);

            if (this.getSpeed() >= 110) {
                this.setSpeed(110);
                return "Flooring it! Max speed of 110 mph";
            }

            return getClass().getSimpleName() + " is speeding up to " + this.getSpeed() + " mph";
        } else {
            return "Start the engine first!";
        }
    }

    @Override
    public String brake() {

        if (this.getSpeed() > 55) {
            this.setSpeed(this.getSpeed() - 55);
            return getClass().getSimpleName() + " is slowing down to " + this.getSpeed() + " mph";
        } else {
            this.setSpeed(0);
            return getClass().getSimpleName() + " has stopped";
        }

    }

}
