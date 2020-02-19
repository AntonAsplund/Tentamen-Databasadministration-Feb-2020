using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TentamenDatabasAntonAsplund
{
    static class PrintTextToConsole
    {
        public static void ReturnToMainMenu()
        {
            Console.WriteLine("Press any key to return to main menu...");
            Console.ReadKey();
            Console.Clear();
        }

        public static void PresentAsciiArtMainMenu()
        {

            Console.ForegroundColor = ConsoleColor.Blue;
            Console.WriteLine("__________                                       __________               __   .__                      ");
            Console.WriteLine("\\______   \\____________     ____  __ __   ____   \\______   \\_____ _______|  | _|__| ____    ____        ");
            Console.WriteLine(" |     ___/\\_  __ \\__  \\   / ___\\|  |  \\_/ __ \\   |     ___/\\__   \\_  __ \\  |/ /  |/    \\  / ___\\       ");
            Console.WriteLine(" |    |     |  | \\// __ \\_/ /_/  >  |  /\\  ___/   |    |     / __ \\|  | \\/    <|  |   |  \\/ /_/  >      ");
            Console.WriteLine(" |____|     |__|  (____  /\\___  /|____/  \\___  >  |____|    (____  /__|  |__|_ \\__|___|  /\\___  /       ");
            Console.WriteLine("                       \\//_____/             \\/                  \\/           \\/       \\//_____/        ");
            Console.WriteLine("________          __        ___.                          ___________    .___.__  __  .__               ");
            Console.WriteLine("\\______ \\ _____ _/  |______ \\_ |__ _____    ______ ____   \\_   _____/  __| _/|__|/  |_|__| ____   ____  ");
            Console.WriteLine(" |    |  \\__   \\   __\\__   \\ | __ \\__   \\  /  ___// __ \\   |    __)_  / __ | |  \\   __\\  |/  _ \\ /    \\ ");
            Console.WriteLine(" |    `   \\/ __ \\|  |  / __ \\| \\_\\ \\/ __ \\_\\___ \\\\  ___/   |        \\/ /_/ | |  ||  | |  (  <_> )   |  \\ ");
            Console.WriteLine("/_______  (____  /__| (____  /___  (____  /____  >\\___  > /_______  /\\____ | |__||__| |__|\\____/|___|  /");
            Console.WriteLine("        \\/     \\/          \\/    \\/     \\/     \\/     \\/          \\/      \\/                         \\/ ");
            Console.ForegroundColor = ConsoleColor.Gray;
        }

        public static void GetMainMenu()
        {
            PresentAsciiArtMainMenu();
            Console.WriteLine("-------------------------------------------------------------------------------------------------------");
            Console.WriteLine("1.   Add new vehicle to parking lot");
            Console.WriteLine("2.   Remove vehicle from parking lot");
            Console.WriteLine("3.   Move parked vehicle to new parking space");
            Console.WriteLine("4.   Search for a specific vehicle through registration number");
            Console.WriteLine("5.   See all vehicles parked more than 48 hours");
            Console.WriteLine("6.   See a list of the parkinglot and its content");
            Console.WriteLine("7.   See a view of all empty spaces");
            Console.WriteLine("8.   Optimize the parked MC's and print work order");
            Console.WriteLine("9.   Optimize all vehicles and print work order");
            Console.WriteLine("10.  Visual presentation of the parking lot ");
            Console.WriteLine("11.  Calculate income per day ");
            Console.WriteLine("12.  See a full record of all past parked vehicles");
            Console.WriteLine("13.  Exit the progam");

        }

        public static void RemoveVehicleMenu()
        {
            Console.WriteLine("By which way do you want to remove the vehicle?");
            Console.WriteLine("-----------------------------------------------");
            Console.WriteLine("1. Remove vehicle with regular hourly rate");
            Console.WriteLine("2. Remove vehicle for free");
        }

        public static void ExitFromMainMenu()
        {
            Console.WriteLine("Thank you for using Prague Parking Database Edition.");
            Console.WriteLine("Press any key shut down the program...");
            Console.ReadKey();
            Console.Clear();
        }

        public static void PrintWorkOrder(Vehicle printWorkOrderVehicle)
        {
            Console.WriteLine("***************************");
            Console.WriteLine(printWorkOrderVehicle.ToString());
        }
        public static void PrintWordOrderMove(Vehicle vehicle)
        {
            Console.WriteLine("***************************");
            Console.WriteLine("Registration number: " + vehicle.registrationNumber);
            Console.WriteLine("Vehicle type: " + vehicle.vehicleType);
            Console.WriteLine("Move from parking space: " + vehicle.oldParkingSpace);
            Console.WriteLine("Move to parking space: " + vehicle.currentParkingSpace);
            Console.WriteLine("***************************");
            
        }
        public static void PrintWordOrder(List<Vehicle> listOfVehicleWorkOrder)
        {
            foreach (var vehicle in listOfVehicleWorkOrder)
            {
                Console.WriteLine("Registration number: " + vehicle.registrationNumber);
                Console.WriteLine("Vehicle type: " + vehicle.vehicleType);
                Console.WriteLine("Move from parking space: " + vehicle.oldParkingSpace);
                Console.WriteLine("Move to parking space: " + vehicle.currentParkingSpace);
                Console.WriteLine("***************************");
            }
        }

        public static void PrintListOfVehicles(List<Vehicle> listOfVehicles)
        {
            int vechileCount = 1;

            Console.WriteLine("************");
            foreach (var vehicle in listOfVehicles)
            {
                Console.WriteLine(vehicle.ToString());
                Console.WriteLine("************");
                if (vechileCount % 10 == 0)
                {
                    Console.WriteLine("Press any key to continue to the next 10 in history");
                    Console.ReadKey();
                    Console.Clear();
                }
                vechileCount++;
            }
        }

        public static void PrintStringListOfParkingSpaces(List<string> listOfParkingSpaceContentString)
        {
            string parkingSpaceNumberSign = "#";
            string registrationNumber = "Registration number(s)";
            string vehicleType = "Type of vehicle(s)";

            Console.WriteLine("{0,-10}{1,-25}{2,-65}", parkingSpaceNumberSign, registrationNumber, vehicleType);
            Console.WriteLine("**************************************************************************");
            int parkingSpaceCounter = 1;
            foreach (var parkingSpace in listOfParkingSpaceContentString)
            {
                Console.Write("");



                if (parkingSpaceCounter%3 == 1)
                {
                    Console.Write("{0,-10}", parkingSpace);
                }
                if (parkingSpaceCounter % 3 == 2)
                {
                    Console.Write("- {0,-25}", parkingSpace);
                }
                if (parkingSpaceCounter % 3 == 0)
                {
                    Console.WriteLine("- {0,-60}", parkingSpace);
                }

                parkingSpaceCounter++;
                
            }
        }
        /// <summary>
        /// Prints a list which contains the info of which parking spaces that are null
        /// </summary>
        /// <param name="listOfEmptyParkingSpaces">A list of int which hold info about empty parking spaces </param>
        public static void PrintListOfEmptySpaces(List<int> listOfEmptyParkingSpaces)
        {
            int noMoreThanTenOnOneLine = 0;

            Console.WriteLine("All empty spaces:");
            Console.WriteLine("*****************");

            foreach (var parkingspaceNumber in listOfEmptyParkingSpaces)
            {
                Console.Write(": {0,2} :", parkingspaceNumber);
                noMoreThanTenOnOneLine++;
                if (noMoreThanTenOnOneLine % 10 == 0)
                {
                    Console.WriteLine("");
                }
            }
            Console.WriteLine("");
        }
        /// <summary>
        /// Prints a visual presentation of the parkinglot based on a list with total info about the parkinglot<br/>
        /// Print every third object in the list because of the format of the incoming list. In it each parking space takes up the string objects.
        /// </summary>
        /// <param name="listOfParkingSpaceContentString">List that holds info of all parking spaces contents in string format</param>
        public static void PrintVisualPresentation(List<string> listOfParkingSpaceContentString)
        {
            int lineRowCount = 1;
            int parkingSpaceCounter = 1;

            foreach (var parkingSpaceInfo in listOfParkingSpaceContentString)
            {
                if (parkingSpaceCounter % 3 == 0)
                {
                    if (lineRowCount % 10 == 1)
                    {
                        Console.Write("*|");
                    }

                    if (parkingSpaceInfo.Contains("MotorCycle"))
                    {


                        if (parkingSpaceInfo.Contains('-'))
                        {
                            Console.ForegroundColor = ConsoleColor.Red;

                            Console.Write("|X|");

                            Console.ForegroundColor = ConsoleColor.Gray;
                        }
                        else
                        {
                            Console.ForegroundColor = ConsoleColor.DarkCyan;

                            Console.Write("|X|");

                            Console.ForegroundColor = ConsoleColor.Gray;
                        }

                    }
                    else if (parkingSpaceInfo.Contains("Car"))
                    {
                        Console.ForegroundColor = ConsoleColor.Red;

                        Console.Write("|X|");

                        Console.ForegroundColor = ConsoleColor.Gray;
                    }
                    else if (parkingSpaceInfo.Contains("Truck"))
                    {
                        Console.ForegroundColor = ConsoleColor.Red;

                        Console.Write("|X|");

                        Console.ForegroundColor = ConsoleColor.Gray;
                    }
                    else
                    {
                        Console.ForegroundColor = ConsoleColor.Green;

                        Console.Write("|X|");

                        Console.ForegroundColor = ConsoleColor.Gray;
                    }

                    if (lineRowCount % 10 == 0)
                    {
                        Console.Write("|* ( {0} - {1} ) ", (lineRowCount - 9), lineRowCount);
                        if (lineRowCount == 10)
                        {
                            Console.WriteLine("  *");
                        }
                        if (10 < lineRowCount && lineRowCount < 99)
                        {
                            Console.WriteLine(" *");
                        }
                        if (lineRowCount == 100)
                        {
                            Console.WriteLine("*");
                        }
                    }

                    lineRowCount++;
                }

                

                parkingSpaceCounter++;
            }

            Console.WriteLine("");
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Green = Empty Spaces");
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("Red - Occupied spaces");
            Console.ForegroundColor = ConsoleColor.DarkCyan;
            Console.WriteLine("DarkCyan - Places with one MC");
            Console.ForegroundColor = ConsoleColor.Gray;

        }

        public static void PrintSeeIncomeDayIntervalMenu()
        {
            Console.WriteLine("View day by day income in which way?");
            Console.WriteLine("------------------------------------");
            Console.WriteLine("1. From today to past day");
            Console.WriteLine("2. From past date to past date");
        }
    }

    
}
