public class FactorPrinter {

    public static void printFactors(int number) {

        if (number < 1) {
            System.out.println("Invalid Value");
        }

        int counter = 1;

        while (counter <= number) {
            if (number % counter == 0) {
                System.out.println(counter);
            }

            counter++;
        }
    }
}
