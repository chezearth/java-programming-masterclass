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
        if(!isAlien) System.out.println("It is not an alien!");


    }
}
