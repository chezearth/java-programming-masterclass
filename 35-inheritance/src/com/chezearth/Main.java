package com.chezearth;

public class Main {

    public static void main(String[] args) {

        Dog dog = new Dog("Alsatian", 1, 1, 5, 85, 2, 4, 1,25, "short bristle");
        dog.eat();
        dog.walk();
        dog.run();
        System.out.println("----------");
        System.out.println("ByRef or ByVal?");
        String var1 = "New";
        String var2 = var1;
        System.out.println("var1 = " + var1);
        System.out.println("var2 = " + var2);
        var2 = "Even Newer";
        System.out.println("var1 = " + var1);
        System.out.println("var2 = " + var2);
        System.out.println("Primitives are ByVal! (objects are ByRef)");
        System.out.println("----------");
        Vehicle bicycle = new Vehicle(0, 10, 2, "bicyle");
        System.out.println(bicycle.getName() + " speed = " + bicycle.getCurrentSpeed());
        System.out.println(bicycle.getName() + " number of wheels = " + bicycle.getWheels());
        System.out.println(bicycle.getName() + " steering direction = " + bicycle.steeringDescriptor());
        bicycle.setCurrentSteering(-10);
        System.out.println(bicycle.getName() + " steering direction = " + bicycle.steeringDescriptor());
        bicycle.setCurrentSteering(10);
        System.out.println(bicycle.getName() + " steering direction = " + bicycle.steeringDescriptor());
        bicycle.setCurrentSteering(0);
        System.out.println(bicycle.getName() + " steering direction = " + bicycle.steeringDescriptor());
        Car bmw = new Car(0,0, "BMW", 0);
        System.out.println(bmw.getName() + " speed = " + bmw.getCurrentSpeed());
        System.out.println(bmw.getName() + " number of wheels = " + bmw.getWheels());
        System.out.println(bmw.getName() + " steering direction = " + bmw.steeringDescriptor());
        bmw.accelerate(15);
        System.out.println(bmw.getName() + " gear = " + bmw.getCurrentGear() + " speed = " + bmw.getCurrentSpeed());
        bmw.setCurrentGear(2);
        bmw.accelerate(10);
        System.out.println(bmw.getName() + " gear = " + bmw.getCurrentGear() + " speed = " + bmw.getCurrentSpeed());
        bmw.accelerate(15);
        System.out.println(bmw.getName() + " gear = " + bmw.getCurrentGear() + " speed = " + bmw.getCurrentSpeed());
        bmw.accelerate(15);
        System.out.println(bmw.getName() + " gear = " + bmw.getCurrentGear() + " speed = " + bmw.getCurrentSpeed());
        bmw.setCurrentGear(3);
        bmw.accelerate(15);
        System.out.println(bmw.getName() + " gear = " + bmw.getCurrentGear() + " speed = " + bmw.getCurrentSpeed());
        bmw.accelerate(20);
        System.out.println(bmw.getName() + " gear = " + bmw.getCurrentGear() + " speed = " + bmw.getCurrentSpeed());
        LandRover defender = new LandRover(0, 0, "Defender", 0, false);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " 4WD engaged" +
                " " + defender.isFourWheelDrive());
        defender.setFourWheelDrive(true);
        defender.setCurrentGear(1);
        defender.accelerate(20);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed " +
                "= " + defender.getCurrentSpeed() + " 4WD engaged" +
                " " + defender.isFourWheelDrive());
        defender.accelerate(20);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " 4WD engaged" +
                " " + defender.isFourWheelDrive());
        defender.setCurrentGear(2);
        defender.accelerate(20);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " 4WD engaged" +
                " " + defender.isFourWheelDrive());
        defender.setCurrentGear(3);
        defender.accelerate(40);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " 4WD engaged" +
                " " + defender.isFourWheelDrive());
        defender.accelerate(40);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " 4WD engaged" +
                " " + defender.isFourWheelDrive());
        defender.setCurrentGear(4);
        defender.accelerate(40);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " 4WD engaged" +
                " " + defender.isFourWheelDrive());
        defender.accelerate(-20);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " 4WD " +
                "engaged " + defender.isFourWheelDrive());
        defender.accelerate(-30);
        System.out.println(defender.getName() + " gear = " + defender.getCurrentGear() + " speed = " + defender.getCurrentSpeed() + " " +
                "4WD " +
                "engaged " + defender.isFourWheelDrive());
    }
}
