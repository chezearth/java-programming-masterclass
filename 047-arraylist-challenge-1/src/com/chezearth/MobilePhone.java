package com.chezearth;

import java.util.ArrayList;

public class MobilePhone {
    private ArrayList<Contact> contactsArr = new ArrayList<Contact>();

//    private Contact findContactObject(String name) {
//        Contact contact = new Contact(name, );
//    }

    public void addContact(String name, String phoneNumber) {
        Contact contact = new Contact(name, phoneNumber);
        if (!findContact(contact)) {
            contactsArr.add(contact);
        } else {
            System.out.println("Contact " + name + " already exists");
        }
    }

//    public void modifyContact(String name, String newName, String newNumber) {
////        boolean contactIndex = findContact(name);
//        Contact contact = new Contact(name)
//
//        if (findContact()) {
//            Contact contact = contactsArr.get(contactIndex);
//
//            if (newName != null) {
//                contact.setName(newName);
//            }
//
//            if (newNumber != null) {
//                contact.setPhoneNumber(newNumber);
//            }
//
//        }
//    }

//    public void removeContact(String name) {
//        int contactIndex = findContact(name);
//
//        if (contactIndex >= 0) {
//            contactsArr.remove(contactIndex);
//        }
//    }

    public void searchContact(String name) {
//        contactsArr.
    }

    private boolean findContact(Contact contact) {
        return contactsArr.contains(contact);
    }

}
