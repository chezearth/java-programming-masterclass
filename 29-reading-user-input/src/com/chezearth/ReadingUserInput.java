package com.chezearth;

import java.util.Scanner;

public class ReadingUserInput {

    public static void readUserInput() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter your year of birth: ");
        boolean hasNextInt = scanner.hasNextInt();

        if (hasNextInt) {
            int yearOfBirth = scanner.nextInt();
            scanner.nextLine();

            if (yearOfBirth > 2019 - 130 && yearOfBirth < 2019) {
                System.out.print("Enter your name: ");
                String name = scanner.nextLine();
                int age = 2019 - yearOfBirth;
                System.out.println("Your name is " + name + ", and you are " + age + " years old.");
            } else {
                System.out.println("Invalid year of birth");
            }

        } else {
            System.out.println("Unable to parse year of birth");
        }

        scanner.close();
    }

}
