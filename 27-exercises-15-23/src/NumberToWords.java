public class NumberToWords {

    public static void numberToWords(int number) {

        if (number < 0) {
            System.out.println("Invalid Value");
        } else {
            int digitCount = getDigitCount(number);
            int revNumber = reverse(number);
            int diffDigitCount = digitCount - getDigitCount(revNumber);
            String result = "";

            do {
                int digit = revNumber % 10;
                revNumber /= 10;

                if (!result.equals("")) {
                    result = result + " ";
                }

                switch (digit) {
                    case 1:
                        result = result + "One";
                        break;
                    case 2:
                        result = result + "Two";
                        break;
                    case 3:
                        result = result + "Three";
                        break;
                    case 4:
                        result = result + "Four";
                        break;
                    case 5:
                        result = result + "Five";
                        break;
                    case 6:
                        result = result + "Six";
                        break;
                    case 7:
                        result = result + "Seven";
                        break;
                    case 8:
                        result = result + "Eight";
                        break;
                    case 9:
                        result = result + "Nine";
                        break;
                    default:
                        result = result + "Zero";
                }

            } while (revNumber > 0);


            while (diffDigitCount > 0) {
                result = result + " " + "Zero";
                diffDigitCount--;
            }

            System.out.println(result);
        }

    }

    public static int reverse(int number) {
        int result = 0;

        int count = getDigitCount(Math.abs(number));

        while (count > 0) {
//            System.out.println("add on: " + (number % 10) * (int) Math.pow(10.0, count - 1));
            result += (number % 10) * (int) Math.pow(10.0, count - 1);
//            System.out.println("result = " + result);
            count--;
            number /= 10;

        }

        return  result;
    }

    public static int getDigitCount(int number) {

        if(number < 0) {
            return -1;
        }

        int count = 0;

        do {
            number /= 10;
            count++;
        } while (number > 0);

        return count;
    }
}
