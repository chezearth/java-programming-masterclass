public class LeapYear {

    public static boolean isLeapYear(int year) {
        return (year >= 1 && year <= 9999) && (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    }

}
