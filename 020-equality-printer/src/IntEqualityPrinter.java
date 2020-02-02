public class IntEqualityPrinter {

    public static final String INVALID_VALUE = "Invalid Value";
    public static final String ALL_EQUAL = "All numbers are equal";
    public static final String ALL_DIFFERENT = "All numbers are different";
    public static final String NEITHER_ALL_OR_DIFFERENT = "Neither all are equal or different";

    public static void printEqual(int num0, int num1, int num2) {

        if(num0 < 0 || num1 < 0 || num2 < 0) {
            System.out.println(INVALID_VALUE);
        } else if(num0 == num1 && num0 == num2) {
            System.out.println(ALL_EQUAL);
        } else if(num0 != num1 && num1 != num2 && num0 != num2) {
            System.out.println(ALL_DIFFERENT);
        } else {
            System.out.println(NEITHER_ALL_OR_DIFFERENT);
        }

    }

}
