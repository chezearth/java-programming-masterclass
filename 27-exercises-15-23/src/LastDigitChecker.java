public class LastDigitChecker {

    public static boolean hasSameLastDigit(int num0, int num1, int num2) {
        return isValid(num0) &&
                isValid(num1) &&
                isValid(num2) &&
                (num0 % 10 == num1 % 10 || num0 % 10 == num2 % 10 || num1 % 10 == num2 % 10);
    }

    public static boolean isValid(int num) {

        if(num < 10 || num > 1000) {
            return false;
        }

        return true;
    }
}
