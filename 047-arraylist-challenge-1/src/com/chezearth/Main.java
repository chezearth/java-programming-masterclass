package com.chezearth;

import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    private static Scanner scanner = new Scanner(System.in);
    private static MobilePhone mobilePhone = new MobilePhone();

    public static void main(String[] args) {
        boolean quit = false;
        int choice = 0;
        printInstructions();

        while (!quit) {
            System.out.println("Enter your choice: ");
            choice = scanner.nextInt();
            scanner.nextLine();

            switch (choice) {
                case 0:
                    printInstructions();
                    break;
                case 1:
                    addContact();
                    break;
                case 2:
                    modifyContact();
                    break;
                case 3:
                    removeContact();
                    break;
                case 4:
                    queryContacts();
                    break;
                case 5:
                    System.out.println("Bye.");
                    quit = true;
            }

        }

    }

    public static void printInstructions() {
        System.out.println("\nPress ");
        System.out.println("\t 0 - To print choice options");
        System.out.println("\t 1 - To add a contact");
        System.out.println("\t 2 - To modify a contact");
        System.out.println("\t 3 - To remove a contact");
        System.out.println("\t 4 - To query contacts");
        System.out.println("\t 5 - To quit the application");
    }

    public static void addContact() {
        System.out.print("Enter contact name: ");
        String name = scanner.nextLine();
        if (!mobilePhone.checkForContact(name)) {
            System.out.print("Enter contact phone number: ");
            String number = scanner.nextLine();
            String result = mobilePhone.addContact(name, number);

            if (result != null) {
                System.out.println("Contact added, " + result);
            } else {
                System.out.println("The contact could not be added");
            }

        } else {
            System.out.println("A contact with the name '" + name + "' already exists");
        }
    }

    public static void  modifyContact() {
        System.out.print("Enter contact name to be edited: ");
        String name = scanner.nextLine();

        if (mobilePhone.checkForContact(name)) {
            System.out.print("Enter contact new name (leave blank to not change): ");
            String newName = scanner.nextLine();
            System.out.print("Enter contact new phone number (leave blank to not change): ");
            String newNumber = scanner.nextLine();
            String result = mobilePhone.modifyContact(name, newName , newNumber);

            if (result != null) {
                System.out.println("Contact updated, " + result);
                return;
            }

        }

        System.out.println(notFound(name));
    }

    public static void removeContact() {
        System.out.print("Enter contact name to be deleted: ");
        String name = scanner.nextLine();
        String result = mobilePhone.removeContact(name);

        if (result != null) {
            System.out.println(result);
            return;
        }

        System.out.println(notFound(name));
    }

    public static void queryContacts() {
        System.out.print("Enter contact name to search for (NOTHING returns all contacts): ");
        String name = scanner.nextLine();

        if (name == null || name.length() == 0) {
            String result = mobilePhone.getAllContacts();

            if (result != null) {
                System.out.println("Details for all contacts:\n" + result);
            } else {
                System.out.println("There are not contacts saved, add some");
            }

        } else {
            String result = mobilePhone.getContactDetails(name);

            if (result != null) {
                System.out.println("Details for contact:\nname: " + result);
            } else {
                System.out.println(notFound(name));
            }

        }

    }

    public static String notFound(String name) {
        return "The contact with name '" + name + "' could not be found";
    }

}

