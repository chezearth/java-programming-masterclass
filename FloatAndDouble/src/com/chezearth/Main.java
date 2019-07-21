package com.chezearth;

public class Main {

    public static void main(String[] args) {

        // width of int is 32 (4 bytes)
        int myIntValue = 5 / 2;
        // width of float is 32 (4 bytes)
        float myFloatValue = 5f / 3f;
        // width of double is 64 (8 bytes)
        double myDoubleValue = 5d / 3d;

        System.out.println("myIntValue = " + myIntValue);
        System.out.println("myFloatValue = " + myFloatValue);
        System.out.println("myDoubleValue = " + myDoubleValue);


        double lbValue = 200d;
        double kgValue = lbValue * 0.453_592_37d;
        System.out.println(lbValue + " lb converts to " + kgValue + " kg");

    }
}
