public class GreatestCommonDivisor {

    public static int getGreatestCommonDivisor(int first, int second) {

        if (first < 10 || second < 10) {
            return -1;
        }

        int gcd = 1;
        int counter = 1;

        while (counter <= Math.min(first, second)) {
            if (first % counter == 0 && second % counter == 0) {
                gcd = counter;
            }

            counter++;
        }

        return gcd;
    }
}
