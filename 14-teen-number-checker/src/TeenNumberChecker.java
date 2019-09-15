public class TeenNumberChecker {


    public static boolean hasTeen(int num0, int num1, int num2) {
        return isTeen(num0) || isTeen(num1) || isTeen(num2);
    }

    public static boolean isTeen(int num) {
        return num > 12 && num < 20;
    }

}
