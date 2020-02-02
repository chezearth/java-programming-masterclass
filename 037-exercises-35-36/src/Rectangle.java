public class Rectangle {
    private double width;
    private double length;

    public double positiveOnly(double number) {

        if (number < 0) {
            return 0D;
        }

        return number;
    }

    public Rectangle(double width, double length) {
        this.width = positiveOnly(width);
        this.length = positiveOnly(length);
    }

    public double getWidth() {
        return width;
    }

    public double getLength() {
        return length;
    }

    public double getArea() {
        return width * length;
    }

}
