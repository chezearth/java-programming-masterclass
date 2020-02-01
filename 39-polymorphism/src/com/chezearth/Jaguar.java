package com.chezearth;

public class Jaguar extends  Car {

    public Jaguar(String name, int doors) {
        super(name, 12, true, doors);
    }

    @Override
    public String accelerate() {
        if (this.isEngineRunning()) {
            this.setSpeed(this.getSpeed() + 40);

            if (this.getSpeed() >= 200) {
                this.setSpeed(200);
                return "Flooring it! Max speed of 200 mph";
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
