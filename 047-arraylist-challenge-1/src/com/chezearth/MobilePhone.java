package com.chezearth;

import java.util.ArrayList;

public class MobilePhone {
    private ArrayList<Contact> contactsArr = new ArrayList<Contact>();

    public String addContact(String name, String phoneNumber) {
        Contact contact = getContactByName(name);
        if (contact == null) {
            Contact newContact = new Contact(name, phoneNumber);
            contactsArr.add(newContact);
            return makeContactDetails(newContact);
        }

        return null;
    }

    public String  modifyContact(String name, String newName, String newNumber) {
        Contact contact = getContactByName(name);

        if (contact != null) {

            if (newName != null && newName.length() != 0) {
                contact.setName(newName);
            }

            if (newNumber != null && newNumber.length() != 0) {
                contact.setPhoneNumber(newNumber);
            }

            return  makeContactDetails(contact);
        }

        return null;
    }

    public String removeContact(String name) {
        Contact contact = getContactByName(name);

        if (contact != null) {
            contactsArr.remove(contact);
            return  "Contact with name '" + contact.getName() + "' deleted";
        }

        return null;
    }

    public boolean checkForContact(String name) {
        return (getContactByName(name) != null);
    }

    public String getContactDetails(String name) {
        return makeContactDetails(getContactByName(name));
    }

    public String getAllContacts() {
        String contactListString = "";

        if (contactsArr.size() > 0) {

            for (int i = 0; i < contactsArr.size(); i++) {
                Contact contact = contactsArr.get(i);
                contactListString = contactListString + makeContactDetails(contact) + "\n";
            }

            return contactListString.trim();
        }

        return null;
    }

    private Contact getContactByName(String name) {

        for (int i = 0; i < contactsArr.size(); i++) {
            Contact contact = contactsArr.get(i);

            if (contact.getName().trim().toLowerCase().equals(name.trim().toLowerCase())) {
                return contact;
            }

        }

        return null;
    }

    private String makeContactDetails(Contact contact) {

        if (contact != null) {
            return "name: "
                    + contact.getName()
                    + ", phone Number: "
                    + contact.getPhoneNumber();
        }

        return null;
    }

}
