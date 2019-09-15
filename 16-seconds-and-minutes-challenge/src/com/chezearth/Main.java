package com.chezearth;

public class Main {

    public static void main(String[] args) {
        System.out.println("Hours, minutes and seconds for 217 min 23 sec = " + getDurationString(217, 23));
        System.out.println("Hours, minutes and seconds for 217 min 65 sec = " + getDurationString(217, 65));
        System.out.println("Hours, minutes and seconds for -217 min 23 sec = " + getDurationString(-217, 23));
        System.out.println("Hours, minutes and seconds for 61 min = " + getDurationString(61,0));
        System.out.println("Hours, minutes and seconds for 13043 sec = " + getDurationString(13043));
        System.out.println("Hours, minutes and seconds for -13043 sec = " + getDurationString(-13043));
    }

    public static String getDurationString(int minutes, int seconds) {

        if(minutes < 0 || seconds < 0 || seconds > 59) {
            return "Invalid value";
        }

        return pad((int) (minutes / 60)) + "h "
                + pad(minutes % 60) + "m "
                + pad(seconds) + "s";
    }

    public static String getDurationString(int seconds) {

        if(seconds < 0) {
            return "Invalid value";
        }

        return pad((int) (seconds / 3600)) + "h "
                + pad((int) ((seconds % 3600) / 60)) + "m "
                + pad((seconds % 3600) % 60) + "s";
    }

    public static String pad(int num) {
        return num < 10 ? "0" + num : "" + num;
    }

}
