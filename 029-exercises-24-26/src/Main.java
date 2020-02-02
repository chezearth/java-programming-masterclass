public class Main {

    public static void main(String[] args) {
        System.out.println("canPack(1, 0, 4) = " + FlourPacker.canPack(1, 0, 4));
        System.out.println("canPack(1, 0, 5) = " + FlourPacker.canPack(1, 0, 5));
        System.out.println("canPack(0, 5, 4) = " + FlourPacker.canPack(0, 5, 4));
        System.out.println("canPack(2, 2, 11) = " + FlourPacker.canPack(2, 2, 11));
        System.out.println("canPack(-3, 2, 12) = " + FlourPacker.canPack(-3, 2, 12));
        System.out.println("canPack(0, 5, 6) = " + FlourPacker.canPack(0, 5, 6));
        System.out.println("canPack(2, 1, 5) = " + FlourPacker.canPack(2, 1, 5));
        System.out.println("-----------------");
        System.out.println("getLargestPrime(21) = " + LargestPrime.getLargestPrime(21));
        System.out.println("getLargestPrime(217) = " + LargestPrime.getLargestPrime(217));
        System.out.println("getLargestPrime(0) = " + LargestPrime.getLargestPrime(0));
        System.out.println("getLargestPrime(45) = " + LargestPrime.getLargestPrime(45));
        System.out.println("getLargestPrime(-1) = " + LargestPrime.getLargestPrime(-1));
        System.out.println("getLargestPrime(1) = " + LargestPrime.getLargestPrime(1));
        System.out.println("getLargestPrime(2) = " + LargestPrime.getLargestPrime(2));
        System.out.println("getLargestPrime(3) = " + LargestPrime.getLargestPrime(3));
        System.out.println("getLargestPrime(4) = " + LargestPrime.getLargestPrime(4));
        System.out.println("getLargestPrime(5) = " + LargestPrime.getLargestPrime(5));
        System.out.println("getLargestPrime(6) = " + LargestPrime.getLargestPrime(6));
        System.out.println("getLargestPrime(7) = " + LargestPrime.getLargestPrime(7));
        System.out.println("getLargestPrime(8) = " + LargestPrime.getLargestPrime(8));
        System.out.println("getLargestPrime(9) = " + LargestPrime.getLargestPrime(9));
        System.out.println("getLargestPrime(10) = " + LargestPrime.getLargestPrime(10));
        System.out.println("-----------------");
        DiagonalStar.printSquareStar(5);
        DiagonalStar.printSquareStar(8);
    }

}
