package com.chezearth;

public class Main {

    private static final String INVALID_VALUE = "Invalid value";

    public static void main(String[] args) {
        System.out.println("Hours, minutes and seconds for 217 min 23 sec = " + getDurationString(217, 23));
        System.out.println("Hours, minutes and seconds for 217 min 65 sec = " + getDurationString(217, 65));
        System.out.println("Hours, minutes and seconds for -217 min 23 sec = " + getDurationString(-217, 23));
        System.out.println("Hours, minutes and seconds for 61 min = " + getDurationString(61,0));
        System.out.println("Hours, minutes and seconds for 13043 sec = " + getDurationString(13043));
        System.out.println("Hours, minutes and seconds for -13043 sec = " + getDurationString(-13043));
    }

    private static String getDurationString(long minutes, long seconds) {

        if(minutes < 0 || seconds < 0 || seconds > 59) {
            return INVALID_VALUE;
        }

        return pad((long) (minutes / 60)) + "h "
                + pad(minutes % 60) + "m "
                + pad(seconds) + "s";
    }

    private static String getDurationString(long seconds) {

        if(seconds < 0) {
            return INVALID_VALUE;
        }

        return getDurationString(seconds / 60, seconds % 60);
    }

    private static String pad(long num) {
        return num < 10 ? "0" + num : "" + num;
    }

}
