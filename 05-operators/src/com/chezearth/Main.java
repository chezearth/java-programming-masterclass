package com.chezearth;

public class Main {

    public static void main(String[] args) {

        int result = 10 * 20;
        System.out.println("10 * 20 = " + result);
        int previousResult = result;
        System.out.println("previousResult = " + previousResult);
        result = result * 20;
        System.out.println("result * 20 = " + result);
        System.out.println("previousResult = " + previousResult);

        result = result / 200;
        System.out.println("result / 200 = " + result);

        result = result % 3;
        System.out.println("result % 3 = " + result);

        result++;
        System.out.println("result++ = " + result);

        result += 3;
        System.out.println("result += 3 = " + result);

        result--;
        System.out.println("result-- = " + result);

        result *= 10;
        System.out.println("result *= 10 = " + result);

        result /= 5;
        System.out.println("result /= 5 = " + result);

        result -= 9;
        System.out.println("result -= 9 = " + result);

        boolean isAlien = false;
        if (!isAlien) {
            System.out.println("It is not an alien!");
        }

        int topScore = 100;
        if (topScore <= 100) {
            System.out.println("Highest Score!");
        }

        int secondHighestScore = 75;
        if (topScore > secondHighestScore && topScore > 80) {
            System.out.println("Your score was higher than 80 and the second highest score.");
        }

        boolean isCar = false;
        if (!isCar) {
            System.out.println("This is not supposed to happen");
        }

        boolean wasCar = isCar ? true : false;
        System.out.println("wasCar is " + wasCar);

        double myFirstVar = 20.00d;
        double mySecondVar = 80.00d;

        boolean answer = ((myFirstVar + mySecondVar) * 100.00d % 40.00d == 0) ? true : false;
        System.out.println(("Challenge answer is " + answer));
        if (!answer) {
            System.out.println("Got some remainder");
        }

    }
}
