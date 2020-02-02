public class Main {

    public static void main(String[] args) {
        System.out.println("isPalindrome(-1221) = " + NumberPalindrome.isPalindrome(-1221));
        System.out.println("isPalindrome(707) = " + NumberPalindrome.isPalindrome(707));
        System.out.println("isPalindrome(11212) = " + NumberPalindrome.isPalindrome(11212));
        System.out.println("--------------");
        System.out.println("sumFirstAndLastDigit(252) = " + FirstLastDigitSum.sumFirstAndLastDigit(252));
        System.out.println("sumFirstAndLastDigit(10) = " + FirstLastDigitSum.sumFirstAndLastDigit(10));
        System.out.println("sumFirstAndLastDigit(0) = " + FirstLastDigitSum.sumFirstAndLastDigit(0));
        System.out.println("sumFirstAndLastDigit(5) = " + FirstLastDigitSum.sumFirstAndLastDigit(5));
        System.out.println("sumFirstAndLastDigit(-10) = " + FirstLastDigitSum.sumFirstAndLastDigit(-10));
        System.out.println("--------------");
        System.out.println("getEvenDigitSum(123456789) = " + EvenDigitSum.getEvenDigitSum(123456789));
        System.out.println("getEvenDigitSum(252) = " + EvenDigitSum.getEvenDigitSum(252));
        System.out.println("getEvenDigitSum(-22) = " + EvenDigitSum.getEvenDigitSum(-22));
        System.out.println("--------------");
        System.out.println("hasSharedDigit(12, 23) = " + SharedDigit.hasSharedDigit(12, 23));
        System.out.println("hasSharedDigit(9, 99) = " + SharedDigit.hasSharedDigit(9, 99));
        System.out.println("hasSharedDigit(15, 55) = " + SharedDigit.hasSharedDigit(15, 55));
        System.out.println("hasSharedDigit(12, 13) = " + SharedDigit.hasSharedDigit(12, 13));
        System.out.println("--------------");
        System.out.println("hasSameLastDigit(41, 22, 71) = " + LastDigitChecker.hasSameLastDigit(41,
                22, 71));
        System.out.println("hasSameLastDigit(23, 32, 42) = " + LastDigitChecker.hasSameLastDigit(23,
                32, 42));
        System.out.println("hasSameLastDigit(9, 99, 999) = " + LastDigitChecker.hasSameLastDigit(9,
                99, 999));
        System.out.println("hasSameLastDigit(15, 23, 37) = " + LastDigitChecker.hasSameLastDigit(15,
                23, 37));
        System.out.println("--------------");
        System.out.println("getGreatestCommonDivisor(25, 15) = " + GreatestCommonDivisor.getGreatestCommonDivisor(25, 15));
        System.out.println("getGreatestCommonDivisor(12, 30) = " + GreatestCommonDivisor.getGreatestCommonDivisor(12, 30));
        System.out.println("getGreatestCommonDivisor(9, 18) = " + GreatestCommonDivisor.getGreatestCommonDivisor(9, 18));
        System.out.println("getGreatestCommonDivisor(81, 153) = " + GreatestCommonDivisor.getGreatestCommonDivisor(81, 153));
        System.out.println("getGreatestCommonDivisor(1010, 10) = " + GreatestCommonDivisor.getGreatestCommonDivisor(1010, 10));
        System.out.println("--------------");
        System.out.println("printFactors(6)");
        FactorPrinter.printFactors(6);
        System.out.println("printFactors(32)");
        FactorPrinter.printFactors(32);
        System.out.println("printFactors(10)");
        FactorPrinter.printFactors(10);
        System.out.println("printFactors(-1)");
        FactorPrinter.printFactors(-1);
        System.out.println("--------------");
        System.out.println("isPerfectNumber(6) = " + PerfectNumber.isPerfectNumber(6));
        System.out.println("isPerfectNumber(28) = " + PerfectNumber.isPerfectNumber(28));
        System.out.println("isPerfectNumber(5) = " + PerfectNumber.isPerfectNumber(5));
        System.out.println("isPerfectNumber(-1) = " + PerfectNumber.isPerfectNumber(-1));
        System.out.println("--------------");
        System.out.println("getDigitCount(0) = " + NumberToWords.getDigitCount(0));
        System.out.println("getDigitCount(123) = " + NumberToWords.getDigitCount(123));
        System.out.println("getDigitCount(-12) = " + NumberToWords.getDigitCount(-12));
        System.out.println("getDigitCount(5200) = " + NumberToWords.getDigitCount(5200));
        System.out.println("--------------");
        System.out.println("reverse(-121) = " + NumberToWords.reverse(-121));
        System.out.println("reverse(1212) = " + NumberToWords.reverse(1212));
        System.out.println("reverse(1234) = " + NumberToWords.reverse(1234));
        System.out.println("reverse(100) = " + NumberToWords.reverse(1));
        System.out.println("--------------");
        System.out.println("numberToWords(123)");
        NumberToWords.numberToWords(123);
        System.out.println("numberToWords(1010)");
        NumberToWords.numberToWords(1010);
        System.out.println("numberToWords(1000)");
        NumberToWords.numberToWords(1000);
        System.out.println("numberToWords(-12)");
        NumberToWords.numberToWords(-12);
        System.out.println("numberToWords(0)");
        NumberToWords.numberToWords(0);
        System.out.println("numberToWords(1682507)");
        NumberToWords.numberToWords(1682507);
    }
}
