public class Main {

    public static void main(String[] args) {
        System.out.println("Number -3.1756 is equal to -3.175 up to 3 decimal places - " + DecimalComparator.areEqualByThreeDecimalPlaces(-3.1756, -3.175));
        System.out.println("Number 3.175 is equal to 3.176 up to 3 decimal places - " + DecimalComparator.areEqualByThreeDecimalPlaces(3.175, 3.176));
        System.out.println("Number 3.0 is equal to 3.0 up to 3 decimal places - " + DecimalComparator.areEqualByThreeDecimalPlaces(3.0, 3.0));
        System.out.println("Number -3.123 is equal to 3.123 up to 3 decimal places - " + DecimalComparator.areEqualByThreeDecimalPlaces(-3.123, 3.123));
    }

}
