package com.chezearth;

public class Main {

    public static void main(String[] args) {
        BankAccount anAccount = new BankAccount();
        System.out.println("Acc number = " + anAccount.getAccountNumber());
        System.out.println("Customer name = " + anAccount.getCustomerName());
        System.out.println("----------");
	    BankAccount myAccount = new BankAccount(
	            "100893",
                "CW Rethman",
                "me@me.com",
                "27711081040",
                -25_000.00
        );
        System.out.println("Acc number = " + myAccount.getAccountNumber());
        System.out.println("Starting balance = " + myAccount.getBalance());
        System.out.println(
                "After deposit, balance = " +
                        myAccount.deposit(49_899.00)
        );
        System.out.println(
                "After withdrawal, balance = " +
                        myAccount.withdrawal(65_000)
        );
        System.out.println(
                "After withdrawal, balance = " +
                        myAccount.withdrawal(21_932.69)
        );
        System.out.println("Ending balance = " + myAccount.getBalance());
        System.out.println("----------");
        VipCustomer newVip0 = new VipCustomer();
        System.out.println("Customer name = " + newVip0.getName());
        System.out.println("Customer credit limit = " + newVip0.getCreditLimit());
        System.out.println("Customer email = " + newVip0.getEmailAddress());
        VipCustomer newVip1 = new VipCustomer("Bob Jones", "bob@youruncle.com");
        System.out.println("Customer name = " + newVip1.getName());
        System.out.println("Customer credit limit = " + newVip1.getCreditLimit());
        System.out.println("Customer email = " + newVip1.getEmailAddress());
        VipCustomer newVip2 = new VipCustomer(
                "John Smith",
                500.0d,
                "john@smithsbrewery.co.uk");
        System.out.println("Customer name = " + newVip2.getName());
        System.out.println("Customer credit limit = " + newVip2.getCreditLimit());
        System.out.println("Customer email = " + newVip2.getEmailAddress());
    }
}
