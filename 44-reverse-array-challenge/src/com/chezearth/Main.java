package com.chezearth;

import java.util.Arrays;

public class Main {

    public static void main(String[] args) {
        int[] array1 = {-20, 5, 63, 2, -1, 0, 4};
        int[] array2 = {-20, 5, 63, 2, -1, 0};
        System.out.println("original array1 = " + Arrays.toString(array1));
        reverse(array1);
        System.out.println("reversed array1 = " + Arrays.toString(array1));
        System.out.println("original array2 = " + Arrays.toString(array2));
        reverse(array2);
        System.out.println("reversed array2 = " + Arrays.toString(array2));
    }

    public static void reverse(int[] arr) {
        for (int i = 0; i < arr.length / 2; i++) {
            int swap = arr[i];
            arr[i] = arr[arr.length - i - 1];
            arr[arr.length - i - 1] = swap;
        }

    }
}
