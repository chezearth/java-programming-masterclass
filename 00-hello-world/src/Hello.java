public class Hello {

    public static void main(String[] args) {

        System.out.println("Hello, Charles!");
        int myFirstNumber = (10 + 5) + (2 * 10);
        int mySecondNumber = 12;
        int myThirdNumber = myFirstNumber * 2;

        int myTotal = myFirstNumber + mySecondNumber + myThirdNumber;

        int myDifference = 1000 - myTotal;

        System.out.println(myFirstNumber);
        System.out.println(myTotal);
        System.out.println(myDifference);

        if(args.length > 0) {
            System.out.println("args =" + args[0]);
        } else {
            System.out.println("No args!");
        }

    }
}
