using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace TentamenDatabasAntonAsplund
{
    class UserInputs
    {
        /// <summary>
        /// Retrieves the input from the user of which registration number the user want to input. <br/>
        /// Checks if users input contains any forbbiden characters or an invalid length
        /// </summary>
        /// <returns></returns>
        public static string GetVehicleRegistrationNumber()
        {
            bool correctUserInput = false;
            string registrationNumber = "";

            char[] forbiddenSigns = new char[] { '!', '\"', '#', '%', '&', '/', '(', ')', '=', '?', '´', '§', '½', '@', '£', '$', '{', '[', ']', '}', '\\', '^', ' ', '¨', '~', '\'', '-', '_', ':', '.', ';', ',', 'µ', '>', '<', '|' };

            Console.WriteLine("Please enter registration number of the vehicle");

            while (correctUserInput == false)
            {
                registrationNumber = Console.ReadLine();
                if (registrationNumber.Length < 3 || registrationNumber.Length > 10)
                {
                    correctUserInput = false;
                    Console.WriteLine("You have entered a registrationumber longer than 10 characters or shorter than 3");
                    Console.Write("Try again: ");
                }
                else
                {
                    correctUserInput = true;
                }
                if (registrationNumber.ToLower().IndexOfAny(forbiddenSigns) > -1)
                {
                    correctUserInput = false;
                    Console.WriteLine("You have entered a fobbiden character.");
                    Console.Write("Try again: ");
                }
            }


            return registrationNumber;
        }
        /// <summary>
        /// Reterieves the input from the user of which vehicle the user has choosen
        /// </summary>
        /// <returns></returns>
        public static int GetVehicleType()
        {
            Console.WriteLine("Which vehicle do you want to add?");
            Console.WriteLine("1. Car");
            Console.WriteLine("2. MC");

            int vehicleTypeChoice = GetOneToTwo();


            return vehicleTypeChoice;
        }
        /// <summary>
        /// Gets one int input from user in the range from one to two. With repetative input until sucessfull.
        /// </summary>
        /// <returns></returns>
        public static int GetOneToTwo()
        {
            bool correctUserInput = false;
            int userInput = 0;

            Console.Write("\n Please enter a number between one and two: ");


            while (correctUserInput == false)
            {
                correctUserInput = int.TryParse(Console.ReadLine(), out userInput);
                if (correctUserInput == false)
                {
                    Console.Write("Please enter a correct number: ");
                }
                if (userInput < 1 || userInput > 2)
                {
                    Console.WriteLine("Please enter a number between 1 and 2");
                    correctUserInput = false;
                }
            }

            return userInput;

        }
        /// <summary>
        /// Gets the users input for main menu choice
        /// </summary>
        /// <returns></returns>
        public static int GetUserInputMainMenu()
        {
            int userMainMenuChoice = 0;
            bool correctUserInput = false;

            while (correctUserInput == false)
            {
                correctUserInput = int.TryParse(Console.ReadLine(), out userMainMenuChoice);
                if (correctUserInput == false)
                {
                    Console.Write("Please enter a correct number without letters: ");
                }
                if (userMainMenuChoice < 1 || userMainMenuChoice > 13)
                {
                    Console.WriteLine("Please enter a number between 1 and 13");
                    correctUserInput = false;
                }
            }

            return userMainMenuChoice;
        }
        /// <summary>
        /// Gets the users input for which vehicle registration number they want
        /// </summary>
        /// <returns></returns>
        public static int GetParkingLotNumber()
        {
            int userParkingSpaceChoice = 0;
            bool correctUserInput = false;

            Console.Write("Please enter a parkingspot number: ");

            while (correctUserInput == false)
            {
                correctUserInput = int.TryParse(Console.ReadLine(), out userParkingSpaceChoice);
                if (correctUserInput == false)
                {
                    Console.Write("Please enter a correct number without letters: ");
                }
                if (userParkingSpaceChoice < 1 || userParkingSpaceChoice > 100)
                {
                    Console.WriteLine("Please enter a number between 1 and 100");
                    correctUserInput = false;
                }
            }

            return userParkingSpaceChoice;
        }
        /// <summary>
        /// Gets the date for which the user want to search when looking at the past financial situation
        /// </summary>
        /// <returns></returns>
        public static DateTime GetDateForIncomeView()
        {
            bool correctUserInput = false;

            DateTime userDateTimeChoice = DateTime.MinValue;

            Console.WriteLine("Please enter year for search in (YYYY) format: ");

            int userYearChoice = 0;
            while (correctUserInput == false)
            {

                correctUserInput = int.TryParse(Console.ReadLine(), out userYearChoice);
                if (correctUserInput == false)
                {
                    Console.WriteLine("Enter a valid number: ");
                }
                if (userYearChoice < 1000 || userYearChoice > 9999)
                {
                    Console.WriteLine("Please enter a year in the format of YYYY i.e. \"1988\": ");
                    correctUserInput = false;
                }

            }

            correctUserInput = false;

            Console.WriteLine("Please enter month for search in (MM) format: ");

            int userMonthChoice = 0;
            while (correctUserInput == false)
            {
                correctUserInput = int.TryParse(Console.ReadLine(), out userMonthChoice);
                if (correctUserInput == false)
                {
                    Console.WriteLine("Enter a valid number: ");
                }
                if (userMonthChoice < 1 || userMonthChoice > 99)
                {
                    Console.WriteLine("Please enter a valid month in the format of MM i.e. \"02\": ");
                    correctUserInput = false;
                }
            }

            correctUserInput = false;

            Console.WriteLine("Please enter day for search in (DD) format: ");

            int userDayChoice = 0;
            while (correctUserInput == false)
            {
                correctUserInput = int.TryParse(Console.ReadLine(), out userDayChoice);
                if (correctUserInput == false)
                {
                    Console.WriteLine("Enter a valid number: ");
                }
                if (userDayChoice < 1 || userDayChoice > 99)
                {
                    Console.WriteLine("Please enter a valid day in the format of DD i.e. \"31\": ");
                    correctUserInput = false;
                }
            }
            try
            {

                userDateTimeChoice = new DateTime(userYearChoice, userMonthChoice, userDayChoice);
            }
            catch 
            {
                Console.WriteLine("You have entered a date isn't a real date, try again..");
            }

            return userDateTimeChoice;

        }



    }
}
