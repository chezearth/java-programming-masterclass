public class FirstLastDigitSum {

    public static int sumFirstAndLastDigit(int number) {

        if(number < 0) {
            return -1;
        }

        int sum = 0;
        int count = 0;

        do {

            if(count == 0 && number < 10) {
                sum = 2 * number;
            } else if(count == 0 || number / 10 == 0) {
                sum += number % 10;
            }

            count++;
            number /= 10;
        } while(number > 0);

        return sum;
    }
}
