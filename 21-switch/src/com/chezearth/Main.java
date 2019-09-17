package com.chezearth;

public class Main {

    public static void main(String[] args) {
        char charValue = 'D';

        switch (charValue) {
            case 'A':
                System.out.println("Letter 'A' found");
                break;
            case 'B':
                System.out.println("Letter 'B' found");
                break;
            case 'C': case 'D': case 'E':
                System.out.println("Letter 'C', 'D' or 'E' found");
                break;
            default:
                System.out.println("Not found");
                break;
        }

        printDayOfTheWeek(-1);
        printDayOfTheWeek(0);
        printDayOfTheWeek(1);
        printDayOfTheWeek(3);
        printDayOfTheWeek(6);
        printDayOfTheWeek(7);
        printDayOfTheWeekIf(-1);
        printDayOfTheWeekIf(0);
        printDayOfTheWeekIf(1);
        printDayOfTheWeekIf(3);
        printDayOfTheWeekIf(6);
        printDayOfTheWeekIf(7);
    }

    private static void printDayOfTheWeek(int day) {
        switch (day) {
            case 0:
                System.out.println("Sunday");
                break;
            case 1:
                System.out.println("Monday");
                break;
            case 2:
                System.out.println("Tuesday");
                break;
            case 3:
                System.out.println("Wednesday");
                break;
            case 4:
                System.out.println("Thursday");
                break;
            case 5:
                System.out.println("Friday");
                break;
            case 6:
                System.out.println("Saturday");
                break;
            default:
                System.out.println("Invalid day");
                break;
        }
    }

    private static void printDayOfTheWeekIf(int day) {
        if(day == 0) {
            System.out.println("Sunday");
        } else if(day == 1) {
            System.out.println("Monday");
        } else if(day == 2) {
            System.out.println("Tuesday");
        } else if(day == 3) {
            System.out.println("Wednesday");
        } else if(day == 4) {
            System.out.println("Thursday");
        } else if(day == 5) {
            System.out.println("Friday");
        } else if(day == 6) {
            System.out.println("Saturday");
        } else {
            System.out.println("Invalid day");
        }
    }
}
