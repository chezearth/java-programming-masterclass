public class LargestPrime {

    public static int getLargestPrime(int number) {

        if (number < 2) {
            return -1;
        }

        int count = 2;
        int result = -1;

        while (count <= number) {

            int primeCounter = 2;
            boolean primeTest = true;

            while (primeCounter < count) {
                primeTest = primeTest && !(count % primeCounter == 0);
                primeCounter++;
            }

            if (number % count == 0 && primeTest) {
                result = count;
            }

            count++;
        }

        return result;
    }

}
