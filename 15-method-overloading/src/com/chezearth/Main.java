package com.chezearth;

public class Main {

    public static void main(String[] args) {
	    int newScore = calculateScore("Bob", 500);
        System.out.println("New score is " + newScore);
        int newNewScore = calculateScore(newScore);
        System.out.println("New, new score is " + newNewScore);
        int finalScore = calculateScore();
        System.out.println("Final score is " + finalScore);
        System.out.println("6' 2\" = " + calcFeetAndInchesToCentimeters(6, 2) + " cm");
        System.out.println("74\" = " + calcFeetAndInchesToCentimeters(74) + " cm");
    }

    public static int calculateScore(String playerName, int score) {
        System.out.println("Player " + playerName + " scored " + score);
        return score * 1000;
    }

    public static int calculateScore(int score) {
        System.out.println("Unnamed player scored " + score);
        return score * 1000;
    }

    public static int calculateScore() {
        System.out.println("No player scored ");
        return 0;
    }

    public static double calcFeetAndInchesToCentimeters(double feet, double inches) {

        if(feet < 0 || inches < 0 || inches > 12) {
            return -1;
        };

        return (feet * 12 + inches) * 2.54;
    }

    public static double calcFeetAndInchesToCentimeters(double inches) {

        if(inches < 0) {
            return -1;
        };

        return calcFeetAndInchesToCentimeters((double) (long) (inches / 12), (double) (inches % 12));
    }

}
