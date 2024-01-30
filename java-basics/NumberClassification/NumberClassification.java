import java.util.Scanner;

public class NumberClassification {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter an integer number: ");
        int number = scanner.nextInt();

        if (number > 0) {
            System.out.println("The entered number is positive.");
        } else if (number < 0) {
            System.out.println("The entered number is negative.");
        } else {
            System.out.println("The entered number is zero.");
        }

        scanner.close();
    }
}
