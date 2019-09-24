package com.chezearth;

import java.util.Scanner;

public class ReadingUserInputChallenge {

    public static void readUserInput() {

        int counter = 0;
        int sum = 0;
        Scanner scanner = new Scanner(System.in);
        boolean hasNextInt = true;

        while (counter < 10) {
            System.out.println("Enter number #" + (counter + 1) + ": ");
            hasNextInt = scanner.hasNextInt();

            if (hasNextInt) {
                int number = scanner.nextInt();
                sum += number;
                counter++;
            } else {
//                scanner.nextLine();
                System.out.println("Invalid number entered");
//                hasNextInt = true;
//                scanner.reset();
            }

            scanner.nextLine();
        }

        scanner.close();
        System.out.println("Sum of numbers entered = " + sum);
    }

}
