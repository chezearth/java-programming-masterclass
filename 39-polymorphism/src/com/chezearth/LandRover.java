package com.chezearth;

public class LandRover extends  Car {

    public LandRover(String name, int doors) {
        super(name, 4, true, doors);
    }

    @Override
    public String accelerate() {
        if (this.isEngineRunning()) {
            this.setSpeed(this.getSpeed() + 10);

            if (this.getSpeed() >= 85) {
                this.setSpeed(85);
                return "Flooring it! Max speed of 85 mph";
            }

            return getClass().getSimpleName() + " is speeding up to " + this.getSpeed() + " mph";
        } else {
            return "Start the engine first!";
        }
    }

    @Override
    public String brake() {

        if (this.getSpeed() > 15) {
            this.setSpeed(this.getSpeed() - 15);
            return getClass().getSimpleName() + " is slowing down to " + this.getSpeed() + " mph";
        } else {
            this.setSpeed(0);
            return getClass().getSimpleName() + " has stopped";
        }

    }

}
