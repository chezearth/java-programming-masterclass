public class BarkingDog {

    public static boolean shouldWakeUp(boolean barking, int hourOfDay) {
        return barking && hourOfDay >= 0 && hourOfDay < 8 || barking && hourOfDay > 22 && hourOfDay < 24;
    }

}
