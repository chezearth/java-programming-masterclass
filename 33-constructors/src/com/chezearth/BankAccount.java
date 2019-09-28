package com.chezearth;

public class BankAccount {
    private String accountNumber;
    private String customerName;
    private String email;
    private String phoneNumber;
    private double balance;

    public BankAccount() {
        this(
                "100000",
                "Default Customer",
                "default@bank.co.za",
                "0211001000",
                0.0D
        );
        System.out.println("Empty constructor called");
    }

    public BankAccount(
            String accountNumber,
            String customerName,
            String email,
            String phoneNumber,
            double balance
    ) {
        setAccountNumber(accountNumber);
//        this.accountNumber = accountNumber;
        setCustomerName(customerName);
//        this.customerName = customerName;
        setEmail(email);
//        this.email = email;
        setPhoneNumber(phoneNumber);
//        this.phoneNumber = phoneNumber;
        setBalance(balance);
//        this.balance = balance;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public double getBalance() {
        return (double) (Math.round(this.balance * 100)) / 100;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public double deposit(double depositedAmount) {
        this.balance += depositedAmount;
        return (double) (Math.round(this.balance * 100)) / 100;
    }

    public double withdrawal(double withdrawalAmount) {

        if (withdrawalAmount > this.balance) {
            System.out.println("Insufficient Funds");
            return (double) (Math.round(this.balance * 100)) / 100;
        }

        this.balance -= withdrawalAmount;
        return (double) (Math.round(this.balance * 100)) / 100;
    }

}
