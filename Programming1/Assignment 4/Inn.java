/*
 * Name: Yi Siang, Chang
 * Program: Business Information Technology
 * Course: ADEV-1008 Programming 1
 * Created: 2022-10-31
 * Updated: 2022-10-31
 */

// import java.lang.*; //Java imports the java.lang package by default.
import java.util.Scanner;

/*
 * A program to calculate "cost of the visit".
 *
 * @author Yi-Siang Chang
 * @version 1.0.0
 */

public class Inn{

	public static void main(String[] args){

		//call the methods
		int stayDays = getStayDays();

		String mealCode = getMealCode();
		double total = calculateTotal(stayDays, mealCode);

//        System.out.println("Enter the number of days of the visit: " + days);  // do not need that

        System.out.print("The total cost of the visit is " + total);

    }


		//method examples:
		public static int getStayDays() {
			int days = 0;
			// days= get user input

			Scanner keyboardInput = new Scanner(System.in);
			System.out.print("Enter the number of days of the visit: ");
			days = keyboardInput.nextInt();

			return days;
		}

		public static String getMealCode() {
			String mealCode = "0";

			Scanner keyboradInput = new Scanner(System.in);
			System.out.print("Enter the meal code plan (A, B, N): ");
			mealCode = keyboradInput.next();  //.charAt(0)

			return mealCode;
		}

		public static double calculateTotal(int days, String code) {
			double total = 0;

			//do calculation based on days and code

			// not mealCode
			if(code.toUpperCase().equals("A")) {  // if(code.toUpperCase() == 'A' is for char
//				System.out.println("The total cost of the visit is " + 169.00 * days);
				total = 169.00 * days;
			}
			else if(code.toUpperCase().equals("B")) {
				total = 112.00 * days;
			}
			else if(code.toUpperCase().equals("N")) {
				total = 99.99 * days;
			}

			return total;
		}

}