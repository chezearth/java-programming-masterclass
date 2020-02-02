public class DecimalComparator {

    public static boolean areEqualByThreeDecimalPlaces(double num0, double num1) {
        return ((int) (num0 * 1000)) == ((int) (num1 * 1000));
    }

}
