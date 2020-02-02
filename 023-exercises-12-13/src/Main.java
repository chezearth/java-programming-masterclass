public class Main {
    public static void main(String[] args) {
        NumberInWord.printNumberInWord(-1);
        NumberInWord.printNumberInWord(0);
        NumberInWord.printNumberInWord(1);
        NumberInWord.printNumberInWord(2);
        NumberInWord.printNumberInWord(4);
        NumberInWord.printNumberInWord(7);
        NumberInWord.printNumberInWord(9);
        NumberInWord.printNumberInWord(10);
        NumberInWord.printNumberInWord(1000);

        System.out.println(NumberOfDaysInMonth.getDaysInMonth(1, 2020));
        System.out.println(NumberOfDaysInMonth.getDaysInMonth(2, 2020));
        System.out.println(NumberOfDaysInMonth.getDaysInMonth(2, 2018));
        System.out.println(NumberOfDaysInMonth.getDaysInMonth(-1, 2020));
        System.out.println(NumberOfDaysInMonth.getDaysInMonth(1, -2020));
    }
}
