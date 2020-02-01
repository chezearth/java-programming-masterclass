package com.chezearth;

import java.util.Arrays;
import java.util.Scanner;

public class Main {

    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {

        int[] myIntegers = getIntegers(5);

        System.out.println("Average is " + getAverage(myIntegers));

        printIntegers("Sorted array", sortIntegers(myIntegers));
        printIntegers("Original array", myIntegers);


    }

    public static int[] getIntegers(int number) {
        System.out.println("Enter " + number + " or integer values:\r");
        int[] values = new int[number];

        for (int i = 0; i < values.length; i++) {
            values[i] = scanner.nextInt();
        }

        return values;
    }

    public static double getAverage(int[] arr) {
        int sum = 0;

        if (arr.length > 0) {

            for (int i = 0; i < arr.length; i++) {
                sum += arr[i];
            }

            return (double) sum / (double) arr.length;
        }

        return sum;
    }

    public static void printIntegers(String intro, int[] arr) {
        System.out.println(intro + ":");
        for (int i = 0; i < arr.length; i++) {
            System.out.println("Element " + i + ", value is " + arr[i]);
        }

    }

    public static int[] sortIntegers(int[] arr) {

        if (arr.length > 0) {
            int[] result = Arrays.copyOf(arr, arr.length);

            for (int i = 0; i < result.length; i++) {

                for (int j = i + 1; j < result.length; j++) {

                    if (result[i] < result[j]) {
                        int swap = result[j];
                        result[j] = result[i];
                        result[i] = swap;
                    }

                }

            }

            return result;
        }

        return null;
    }

}
