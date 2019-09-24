public class Main {
    public static void main(String[] args) {
//        InputCalculator.inputThenPrintSumAndAverage();
        System.out.println("--------------------");
        System.out.println("getBucketCount(-3.4, 2.1, 1.5, 2) = " + PaintJob.getBucketCount(-3.4,
                2.1, 1.5, 2));
        System.out.println("getBucketCount(3.4, 2.1, 1.5, 2) = " + PaintJob.getBucketCount(3.4,
                2.1, 1.5, 2));
        System.out.println("getBucketCount(2.75, 3.25, 2.5, 1) = " + PaintJob.getBucketCount(2.75,
                3.25, 2.5, 1));
        System.out.println("--------------------");
        System.out.println("getBucketCount(-3.4, 2.1, 1.5) = " + PaintJob.getBucketCount(-3.4,
                2.1, 1.5));
        System.out.println("getBucketCount(3.4, 2.1, 1.5) = " + PaintJob.getBucketCount(3.4,
                2.1, 1.5));
        System.out.println("getBucketCount(7.25, 4.3, 2.35) = " + PaintJob.getBucketCount(7.25,
                4.3, 2.35));
        System.out.println("--------------------");
        System.out.println("getBucketCount(3.4, 1.5) = " + PaintJob.getBucketCount(3.4, 1.5));
        System.out.println("getBucketCount(6.26, 2.2) = " + PaintJob.getBucketCount(6.26, 2.2));
        System.out.println("getBucketCount(3.26, 0.75) = " + PaintJob.getBucketCount(3.23, 0.75));
    }
}
