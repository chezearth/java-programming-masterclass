package com.chezearth;

import java.util.Arrays;

public class Main {

    public static void main(String[] args) {
        int myIntValue = 10;
        int anotherIntValue = myIntValue;
        anotherIntValue = 20;
        System.out.println("myIntValue = " + myIntValue + ", anotherIntValue = " + anotherIntValue);

        String myStringValue = "hello";
        String anotherStringValue = myStringValue;
        myStringValue = "Fred";
        System.out.println("myStringValue = " + myStringValue + ", anotherStringValue = " + anotherStringValue);

        int[] myArr = new int[5];
        int[] anotherArr = myArr;
        System.out.println("myArr = " + Arrays.toString(myArr));
        System.out.println("anotherArr = " + Arrays.toString(anotherArr));
        anotherArr[0] = 3;
        System.out.println("myArr = " + Arrays.toString(myArr));
        System.out.println("anotherArr = " + Arrays.toString(anotherArr));

        modifyRef(myArr);
        System.out.println("myArr = " + Arrays.toString(myArr));
        System.out.println("anotherArr = " + Arrays.toString(anotherArr));

    }

    public static void modifyRef(int[] array) {
        array[0] = 2;
    }
}
