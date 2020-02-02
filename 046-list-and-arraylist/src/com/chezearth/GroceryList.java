package com.chezearth;

import javax.swing.text.StringContent;
import java.lang.reflect.Array;
import java.util.ArrayList;

public class GroceryList {
    private ArrayList<String> groceryList = new ArrayList<String>();

    public void addGroceryItem(String item) {
        groceryList.add(item.toLowerCase());
    }

    public void printGroceryList() {
        System.out.println("You have " + groceryList.size() + " items in your grocery list");

        for (int i = 0; i < groceryList.size(); i++) {
            System.out.println(i + 1 + ". " + groceryList.get(i));
        }
    }

    public void modifyGroceryItem(String oldItem, String newItem) {
        int position = findGroceryItem(oldItem);

        if (position >= 0) {
            String currItem = groceryList.get(position);
            modifyGroceryItem(position, newItem);
            System.out.println("Grocery item " + (position + 1)
                    + " has been modified from " + currItem
                    + " to " + groceryList.get(position)
            );
        } else {
            System.out.println(oldItem + " doesn't exist");
        }

    }
    private void modifyGroceryItem(int position, String newItem) {
            groceryList.set(position, newItem.toLowerCase());
    }

    public void removeGroceryItem(String item) {
        int position = findGroceryItem(item);

        if (position >= 0) {
            String currItem = groceryList.get(position);
            removeGroceryItem(position);
            System.out.println("Grocery item " + (position + 1)
                    + ", " + currItem
                    + ", has been removed. "
                    + "There are now " + groceryList.size()
                    + " items in your grocery list"
            );
        } else {
            System.out.println("The item at position " + position + " doesn't exist");
        }
    }
    private void removeGroceryItem(int position) {
        groceryList.remove(position);
    }

    public String searchGroceryItem(String searchItem) {
        int position = findGroceryItem(searchItem);
        if (position >= 0) {
            String item = groceryList.get(position);
            System.out.println("Found " + item + " in our grocery list");
            return item;
        } else {
            System.out.println("Item " + searchItem + " is not in the grocery list");
            return null;
        }
    }

    private int findGroceryItem(String searchItem) {
        return groceryList.indexOf(searchItem.toLowerCase());
    }
}

