public class SharedDigit {

    public static boolean hasSharedDigit(int num0, int num1) {

        if(num0 < 10 || num1 < 10 || num0 > 99 || num1 > 99) {
            return false;
        }

        while(num0 > 0) {
            int num1Test = num1;

            while(num1Test > 0) {

                if(num0 % 10 == num1Test % 10) {
                    return true;
                }

                num1Test /= 10;
            }

            num0 /= 10;
        }

        return false;
    }
}
