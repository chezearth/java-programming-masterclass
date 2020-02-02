package com.chezearth;

import java.util.Scanner;

public class Main {

    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Please supply the number of integers required");
            args = new String[1];
            args[0] = String.valueOf(readIntegers(1)[0]);
        }
        int[] array = readIntegers(Integer.parseInt(args[0]));
        System.out.println("Min element = " + findMin(array));
    }

    public static int[] readIntegers(int count) {
        int[] arr = new int[count];
        System.out.println("Enter " + count + " integers:\r");

        for (int i = 0; i < count; i++) {
            arr[i] = scanner.nextInt();
        }

        return arr;
    }

    public static int findMin(int[] arr) {
        int min = arr[0];

        for (int i = 1; i < arr.length; i++) {

            if (min > arr[i]) {
                min = arr[i];
            }

        }

        return min;
    }
}
