public class Main {

    public static void main(String[] args) {
        Wall wall = new Wall(5, 4);
        System.out.println("area= " + wall.getArea());
        wall.setHeight(-1.5);
        System.out.println("width= " + wall.getWidth());
        System.out.println("height= " + wall.getHeight());
        System.out.println("area= " + wall.getArea());
        System.out.println("-------------");
        Point first = new Point(6, 5);
        Point second = new Point(3,1);
        System.out.println("distance(0,0)= " + first.distance());
        System.out.println("distance(second)= " + first.distance(second));
        System.out.println("distance(2,2)= " + first.distance(2, 2));
        Point point = new Point();
        System.out.println("distance()= " + point.distance());
        System.out.println("-------------");
        Carpet carpet = new Carpet(3.5D);
        Floor floor = new Floor(2.75D, 4.0D);
        Calculator calculator = new Calculator(floor, carpet);
        System.out.println("total= " + calculator.getTotalCost());
        carpet = new Carpet(1.5D);
        floor = new Floor(5.4D, 4.5D);
        calculator = new Calculator(floor, carpet);
        System.out.println("total= " + calculator.getTotalCost());
        System.out.println("-------------");
        ComplexNumber one = new ComplexNumber(1.0D, 1.0D);
        ComplexNumber number = new ComplexNumber(2.5D, -1.5D);
        one.add(1,1);
        System.out.println("one.real= " + one.getReal());
        System.out.println("one.imaginery= " + one.getImaginary());
        one.subtract(number);
        System.out.println("one.real= " + one.getReal());
        System.out.println("one.imaginery= " + one.getImaginary());
        number.subtract(one);
        System.out.println("number.real= " + number.getReal());
        System.out.println("number.imaginery= " + number.getImaginary());
    }

}
