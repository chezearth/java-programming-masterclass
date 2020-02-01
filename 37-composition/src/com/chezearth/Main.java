package com.chezearth;

public class Main {

    public static void main(String[] args) {
        Dimensions dimensions = new Dimensions(35, 35, 10);
	    Case theCase = new Case("Superbia", "Sytem76", "240V ac/15V dc", dimensions);
	    Monitor theMonitor = new Monitor("Xperienz", "Sony", 27, new Resolution(2540, 1440));
	    Motherboard motherboard = new Motherboard("XT500", "Asus", 4, 8, "grub");
	    Computer machine = new Computer(theCase, theMonitor, motherboard);
		machine.powerUp();
//	    machine.getTheCase().pressPowerButton();
//      machine.getMotherboard().loadProgram("Fedora");
//	    machine.getMonitor().drawPixelAt(1200, 990, "blue");

		Room room = new Room(
				"Bedroom",
				new Bed("Queen", false),
				new Cupboard(2),
				new Lamp(true),
				new Window(false)
		);
		System.out.println("Bed size = " + room.getBedSize());
		System.out.println("Is bed hidden? " + room.getBed().isHidden());
		room.hideBed();
		System.out.println("Is bed hidden? " + room.getBed().isHidden());
    }
}
