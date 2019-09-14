public class MegaBytesConverter {

    public static void printMegaBytesAndKiloBytes(int kiloBytes) {
        System.out.println(
                kiloBytes < 0 ?
                "Invalid Value" :
                kiloBytes + " KB = " + Math.floorDiv(kiloBytes, 1024) + " MB and " + kiloBytes % 1024 + " KB");
    }

}
