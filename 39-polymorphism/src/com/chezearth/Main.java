package com.chezearth;

class Movie {
    private String name;

    public Movie(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public String plot() {
        return "No plot here";
    }
}

class Jaws extends Movie {

    public Jaws() {
        super("Jaws");
    }

    public String plot() {
        return "A shark eats lots of people";
    }
}

class IndependenceDay extends Movie {

    public IndependenceDay() {
        super("Independence Day");
    }

    @Override
    public String plot() {
        return "Aliens attempt to take over Earth";
    }
}

class MazeRunner extends Movie {

    public MazeRunner() {
        super("Maze Runner");
    }

    @Override
    public String plot() {
        return "Kids try escape a maze";
    }
}

class StarWars extends Movie {

    public StarWars() {
        super("Star Wars");
    }

    @Override
    public String plot() {
        return "Fighting against Imperial Forces taking over the Universe";
    }
}

class Forgettable extends Movie {

    public Forgettable() {
        super("Forgettable");
    }
}

public class Main {

    public static void main(String[] args) {

        Car car = new Car("Unknown", 4, false, 3);
        System.out.println(car.describe(car.getClass().getSimpleName()));
        System.out.println(car.accelerate());
        System.out.println(car.brake());
        System.out.println(car.startEngine());
        System.out.println(car.accelerate());
        System.out.println(car.brake());
        System.out.println(car.brake());

        LandRover landRover = new LandRover("Defender", 5 );
        System.out.println(landRover.describe(landRover.getClass().getSimpleName()));
        System.out.println(landRover.accelerate());
        landRover.startEngine(); System.out.println(landRover.accelerate()); System.out.println(landRover.accelerate());
        System.out.println(landRover.brake()); System.out.println(landRover.accelerate()); System.out.println(landRover.brake()); System.out.println(landRover.brake());

        Jaguar jaguar = new Jaguar("E-Type", 2);
        System.out.println(jaguar.describe(jaguar.getClass().getSimpleName()));
        System.out.println(jaguar.startEngine());
        System.out.println(jaguar.accelerate()); System.out.println(jaguar.accelerate()); System.out.println(jaguar.accelerate()); System.out.println(jaguar.accelerate()); System.out.println(jaguar.accelerate()); System.out.println(jaguar.accelerate());
        System.out.println(jaguar.brake()); System.out.println(jaguar.accelerate()); System.out.println(jaguar.accelerate()); System.out.println(jaguar.brake()); System.out.println(jaguar.brake()); System.out.println(jaguar.brake()); System.out.println(jaguar.brake());
/*
        System.out.println("Land Rover details:");
        for (int i = 1; i < 11; i++) {
            Movie movie = randomMovie();
            System.out.println("Movie #" + i + "; " + movie.getName() + "\n" +
                "Plot: " + movie.plot() + "\n"
        );
        } */
    }

    public static Movie randomMovie() {
        int randomNumber = (int) (Math.random() * 5) + 1;
        System.out.println("Random number generated is " + randomNumber);
        switch (randomNumber) {
            case 1:
                return new Jaws();
            case 2:
                return new IndependenceDay();
            case 3:
                return new MazeRunner();
            case 4:
                return new StarWars();
            case 5:
                return new Forgettable();
        }

        return null;
    }
}
