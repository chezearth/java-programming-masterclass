public class NumberPalindrome {

    public static boolean isPalindrome(int number) {
        int reverse = 0;
        int placeHolder = Math.abs(number);

        while(placeHolder > 0) {
            int lastDigit = placeHolder % 10;
            reverse *= 10;
            reverse += lastDigit;
            placeHolder /= 10;
        }

        return reverse == Math.abs(number);
    }
}
