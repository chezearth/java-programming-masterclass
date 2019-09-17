package com.chezearth;

public class Main {

    public static void main(String[] args) {

        for(long i = 8; i > 1; i--) {
            System.out.println("$10 000 at " + i + "% interest = " + String.format(
                    "%.2f", calculateInterest(10000,
                    i)));
        }

        int primeCount = 0;
        for(int i = 1; i <= 1000; i++) {
            if(isPrime(i)) {
                System.out.println(i);
                primeCount++;
                if(primeCount == 3) {
                    break;
                }
            }
        }
//        System.out.println("Number of prime numbers between 1 & 1000 inclusive are " + primeCount);
    }

    public static double calculateInterest(double amount, double interestRate) {
        return amount * interestRate / 100;
    }

    public static boolean isPrime(int n) {

        if(n == 1) {
            return false;
        }

        for(int i = 2; i <= n / 2; i++) {
            if(n % i == 0) {
                return false;
            }
        }

        return true;
    }
}
