package com.chezearth;

import java.util.Scanner;

public class Main {
    private static Scanner scanner = new Scanner(System.in);
    private static MobilePhone mobilePhone = new MobilePhone();

    public static void main(String[] args) {
        boolean quit = false;
        int choice = 0;
        printInstructions();

        while (!quit) {
            System.out.print("Enter your choice: ");
            choice = scanner.nextInt();
            scanner.nextLine();

            switch (choice) {
                case 2:
                    addContact();
                    break;
                case 6:
                    System.out.println("Bye.");
                    quit = true;
            }

        }

    }

    public static void printInstructions() {
        System.out.println("\nPress ");
        System.out.println("\t 0 - To print choice options");
        System.out.println("\t 1 - To print a list of contacts");
        System.out.println("\t 2 - To add a contact to the list");
        System.out.println("\t 3 - To modify a contact in the list");
        System.out.println("\t 4 - To remove a contact from the list");
        System.out.println("\t 5 - To search for a contact in the list");
        System.out.println("\t 6 - To quit the application");
    }

//    public static void enterContactDetails() {
//
//    }

    public static void addContact() {
        System.out.print("Enter contact name: ");
        String name = scanner.nextLine();
        System.out.print("Enter contact phone number: ");
        String number = scanner.nextLine();
        mobilePhone.addContact(name, number);
    }


}
