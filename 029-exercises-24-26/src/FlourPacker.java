public class FlourPacker {

    public static boolean canPack(int bigCount, int smallCount, int goal) {

        if (bigCount < 0 || smallCount < 0 || goal < 0) {
            return false;
        }

        int count = 0;
        int rem = 0;

        while (count * 5 <= goal && count <= bigCount) {
            rem = goal - count * 5;
            count++;
        }

            return smallCount >= rem && rem >= 0;
    }
}
