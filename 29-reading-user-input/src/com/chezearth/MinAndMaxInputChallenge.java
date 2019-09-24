package com.chezearth;

import java.util.Scanner;

public class MinAndMaxInputChallenge {

    public static void minAndMaxInput() {

//        int min = 0;
//        int max = 0;
        int min = Integer.MAX_VALUE;
        int max = Integer.MIN_VALUE;
//        boolean flag = true;
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("Enter number: ");
            boolean isInt = scanner.hasNextInt();

            if (isInt) {
                int number = scanner.nextInt();

//                if (flag) {
//                    min = number;
//                    max = number;
//                    flag = false;
//                } else {
                    min = Math.min(number, min);
                    max = Math.max(number, max);
//                }

            } else {

//                if(!flag) {
                if (!(min == Integer.MAX_VALUE && max == Integer.MIN_VALUE)) {
                    break;
                }

            }


            scanner.nextLine();
        }

        System.out.println("Minimum number = " + min + " and maximum number = " + max);
        scanner.close();
    }

}
