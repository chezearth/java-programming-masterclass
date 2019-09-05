package com.chezearth;

public class Main {

    public static void main(String[] args) {

        // int has a width of 32
        int myMinIntValue = Integer.MIN_VALUE; //-2_147_483_648;
        int myMaxIntValue = Integer.MAX_VALUE; // 2_147_483_647;

        int myIntValue = (myMinIntValue / 2);
        System.out.println("myMinIntValue = " + myMinIntValue);
        System.out.println("myIntValue = " + myIntValue);
        System.out.println("myMaxIntValue = " + myMaxIntValue);

        // byte has a width of 8
        byte myMinByteValue = Byte.MIN_VALUE; // -128;
        byte myMaxByteValue = Byte.MAX_VALUE; // 127;

        byte myByteValue = (byte) (myMinByteValue / 2);
        System.out.println("myMinByteValue = " + myMinByteValue);
        System.out.println("myByteValue = " + myByteValue);
        System.out.println("myMaxByteValue = " + myMaxByteValue);

        // short has a width of 16
        short myMinShortValue = Short.MIN_VALUE; // -32_768;
        short myMaxShortValue = Short.MAX_VALUE; //32_767;

        short myShortValue = (short) (myMinShortValue /2);
        System.out.println("myMinShortValue = " + myMinShortValue);
        System.out.println("myShortValue = " + myShortValue);
        System.out.println("myMaxShortValue = " + myMaxShortValue);

        // long has a width of 64
        long myMinLongValue = Long.MIN_VALUE; // -9_223_372_036_854_775_808L;
        long myMaxLongValue = Long.MAX_VALUE; // 9_223_372_036_854_775_807L;

        long myLongValue = (myMinLongValue /2);
        System.out.println("myMinLongValue = " + myMinLongValue);
        System.out.println("myShortValue = " + myLongValue);
        System.out.println("myMaxLongValue = " + myMaxLongValue);


        // exercise
        byte myByte = 15;
        short myShort = 1_256; // 1_271
        int myInt = 45_000; // 46_271
        long myLong = 50_000L + 10L * (myByte + myShort + myInt);
        // 50_000 + 10 * (15 + 1_156 + 45_000) = 50_000 + 10 * (1_271 + 45_000) = 50_000 + 10 * 46_271 =
        // 50_000 + 462_710 = 512_710
        System.out.println("myLong = " + myLong);

    }
}
