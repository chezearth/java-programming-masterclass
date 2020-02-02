public class Main {
    public static void main(String[] args) {
        System.out.println("Dogs not barking @ 0 hrs = " + BarkingDog.shouldWakeUp(false, 0));
        System.out.println("Dogs not barking @ 4 hrs = " + BarkingDog.shouldWakeUp(false, 4));
        System.out.println("Dogs barking @ -1 hrs = " + BarkingDog.shouldWakeUp(true, -1));
        System.out.println("Dogs barking @ 0 hrs = " + BarkingDog.shouldWakeUp(true, 0));
        System.out.println("Dogs barking @ 4 hrs = " + BarkingDog.shouldWakeUp(true, 4));
        System.out.println("Dogs barking @ 8 hrs = " + BarkingDog.shouldWakeUp(true, 8));
        System.out.println("Dogs barking @ 9 hrs = " + BarkingDog.shouldWakeUp(true, 9));
        System.out.println("Dogs barking @ 22 hrs = " + BarkingDog.shouldWakeUp(true, 22));
        System.out.println("Dogs barking @ 23 hrs = " + BarkingDog.shouldWakeUp(true, 23));
        System.out.println("Dogs barking @ 24 hrs = " + BarkingDog.shouldWakeUp(true, 24));
        System.out.println("Dogs barking @ 25 hrs = " + BarkingDog.shouldWakeUp(true, 25));
    }
}
