package com.chezearth;

public class Main {

    public static void main(String[] args) {
        long sum = 0;
        int count = 0;

        for(int i = 1; i <= 1000 && count < 5; i++) {

            if(i % 3 == 0 && i % 5 == 0) {
                System.out.println(i);
                sum += i;
                count++;
            }

        }

        System.out.println("Sum of first " + count + " numbers divisible by 3 & 5 = " + sum);

        System.out.println(sumOdd(1,100));
        System.out.println(sumOdd(-1, 100));
        System.out.println(sumOdd(100, 100));
        System.out.println(sumOdd(13, 13));
        System.out.println(sumOdd(100, -100));
        System.out.println(sumOdd(100, 1000));
    }

    public static boolean isOdd(int number) {

        if(number <= 0) {
            return false;
        }

        return number % 2 != 0;
    }

    public static int sumOdd(int start, int end) {

        if(end < start || start < 0) {
            return -1;
        }

        int sum = 0;

        for(int i = start; i <= end; i++) {

            if(isOdd(i)) {
                sum += i;
            }

        }

        return sum;
    }

}
