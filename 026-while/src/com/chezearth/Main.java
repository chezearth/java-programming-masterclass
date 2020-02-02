package com.chezearth;

public class Main {

    public static void main(String[] args) {
        int number = 4;
        int finishNumber = 20;
        int total = 0;
        int count = 0;

        while (number <= finishNumber) {

            number++;
            if(!isEvenNumber(number)) {
                continue;
            }

            if(count >= 5) {
                break;
            }

            System.out.println("Even number " + number);
            total += number;
//            System.out.println(total);
            count ++;
//            System.out.println(count);

        }

        System.out.println("total = "+ total);
    }

    public static boolean isEvenNumber(int num) {
        if(num % 2 == 0) return true;
        return false;
    }
}
