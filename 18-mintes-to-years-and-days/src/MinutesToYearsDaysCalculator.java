public class MinutesToYearsDaysCalculator {

    private static final String INVALID_VALUE = "Invalid Value";

    public static void printYearsAndDays(long minutes) {

        if(minutes < 0) {
            System.out.println(INVALID_VALUE);
        } else {

            System.out.println(
                    minutes + " min = "
                    + (long) (minutes / 60 / 24 / 365) + " y and "
                    + (long) (minutes % (60 * 24 * 365)) / 60 / 24 + " d"
            );
        }
    }

}
