package com.chezearth;

public class Main {

    public static void main(String[] args) {
        calculateScore(true, 800, 5, 100);
        calculateScore(true, 10000, 8, 200);

        displayHighScorePosition("Charles", calculateHighScorePosition(1500));
        displayHighScorePosition("Bob", calculateHighScorePosition(900));
        displayHighScorePosition("Jane", calculateHighScorePosition(400));
        displayHighScorePosition("Fred", calculateHighScorePosition(50));
    }

    public static void calculateScore(boolean gameOver, int score, int levelCompleted, int bonus) {

        if (gameOver) {
            int finalScore = score + (levelCompleted * bonus);
            System.out.println("Your final score was " + finalScore);
        }

    }

    public static void displayHighScorePosition(String name, int position) {
        System.out.println(name + " managed to get into position " + position + " on the high score table");
    }

    public static int calculateHighScorePosition(int score) {

        if(score >= 1000) {
            return 1;
        } else if(score >= 500) {
            return 2;
        } else if(score >= 100) {
            return 3;
        }

        return 4;
    }
}
