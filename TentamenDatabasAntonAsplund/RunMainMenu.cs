using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace TentamenDatabasAntonAsplund
{
    public static class MainMenu
    {

        public static void Run()
        {
            bool stayInMainMenu = true;


            while (stayInMainMenu)
            {
                PrintTextToConsole.GetMainMenu();
                int mainMenuChoice = UserInputs.GetUserInputMainMenu();
                Console.Clear();

                switch (mainMenuChoice)
                {
                    case 1: //Addvehicle 
                        {
                            int parkingSpaceNumber = SQLQuerys.AddVehicle();
                            Console.WriteLine("The vehicle has been assigned to parking spot {0}.", parkingSpaceNumber);
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 2: //Remove vehicle, remove vehicle for free 
                        {
                            PrintTextToConsole.RemoveVehicleMenu();
                            int removeVehicleMenuChoice = UserInputs.GetOneToTwo();
                            Vehicle removeThisVehicle = new Vehicle();

                            switch (removeVehicleMenuChoice)
                            {
                                case 1:
                                    {
                                        bool forFree = false;
                                        removeThisVehicle = SQLQuerys.RemoveVehicle(forFree);
                                        break;
                                    }
                                case 2:
                                    {
                                        bool forFree = true;
                                        removeThisVehicle = SQLQuerys.RemoveVehicle(forFree);
                                        break;
                                    }
                            
                            }

                            Console.WriteLine(removeThisVehicle.ToString());
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 3: //Move a vehicle. 
                        {
                            Vehicle moveThisVehicle = new Vehicle();
                            moveThisVehicle = SQLQuerys.MoveVehicle();

                            if (moveThisVehicle.currentParkingSpace > 0)
                            {
                                PrintTextToConsole.PrintWordOrderMove(moveThisVehicle);
                            }
                            else 
                            {
                                Console.WriteLine("No vehicle with matching registration number has been found.");
                            }
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 4: //Search for a vehicle. 
                        {
                            Vehicle serachForThisVehicle = SQLQuerys.SearchForSpecificVehicle();

                            if (serachForThisVehicle.currentParkingSpace > 0)
                            {
                                PrintTextToConsole.PrintWorkOrder(serachForThisVehicle);
                            }
                            else
                            {
                                Console.WriteLine("No vehicle with matching registration number has been found.");
                            }

                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 5: //See all cars parked more than 48Hours 
                        {
                            List<Vehicle> listVehiclesMoreThan2Days = SQLQuerys.SeeVehiclesParkedMoreThen48Hours();
                            PrintTextToConsole.PrintListOfVehicles(listVehiclesMoreThan2Days);
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 6: //See entire parking with contents printed on console 
                        {
                            List<string> listOfParkingSpaceContentString = SQLQuerys.SeeFullParkingLot();
                            PrintTextToConsole.PrintStringListOfParkingSpaces(listOfParkingSpaceContentString);
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 7: //See which parking lot that are empty 
                        {
                            List<int> listOfEmptyParkingSpaces = SQLQuerys.SeeAllEmptyParkingSpaces();
                            PrintTextToConsole.PrintListOfEmptySpaces(listOfEmptyParkingSpaces);
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 8: //Optimize the parked MC's and print workorder 
                        {
                            bool sucessfullOptimization = SQLQuerys.OptimizeParkedMC();
                            if (sucessfullOptimization)
                            {
                                List<Vehicle> listOfVehicleWorkOrder = SQLQuerys.GetListVehicleMoveWorkOrder();
                                PrintTextToConsole.PrintWordOrder(listOfVehicleWorkOrder);
                                SQLQuerys.DeleteFromWorkOrder();
                            }
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 9: // Optimize the entire parking lot and print workorder 
                        {
                            bool sucessfullOptimization = SQLQuerys.OptimizeEntireParkingLot();
                            if (sucessfullOptimization)
                            {
                                List<Vehicle> listOfVehicleWorkOrder = SQLQuerys.GetListVehicleMoveWorkOrder();
                                PrintTextToConsole.PrintWordOrder(listOfVehicleWorkOrder);
                                SQLQuerys.DeleteFromWorkOrder();
                            }
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 10: //Visual presentation of the parkinglot 
                        {
                            List<string> listOfParkingSpaceContentString = SQLQuerys.SeeFullParkingLot();
                            PrintTextToConsole.PrintVisualPresentation(listOfParkingSpaceContentString);
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 11: //See income per day between certain day interval
                        {
                            PrintTextToConsole.PrintSeeIncomeDayIntervalMenu();
                            int incomePerDayMenuChoice = UserInputs.GetOneToTwo();

                            switch (incomePerDayMenuChoice)
                            {
                                case 1:
                                    {
                                        SQLQuerys.CalculateIncomeDuringTodayAndPastDate();
                                        break;
                                    }
                                case 2:
                                    {
                                        SQLQuerys.CaluculateIncomeDuringPastDateAndPastDate();
                                        break;
                                    }
                            }



                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 12: //See a full history of all past parked vehicles 
                        {
                            List<Vehicle> listOfVehicleInArchive = SQLQuerys.SeeFullHistoryTable();
                            PrintTextToConsole.PrintListOfVehicles(listOfVehicleInArchive);
                            PrintTextToConsole.ReturnToMainMenu();
                            break;
                        }
                    case 13: //Exit the program DONE
                        {
                            stayInMainMenu = false;
                            PrintTextToConsole.ExitFromMainMenu();
                            break;
                        }
                }
            }
        }
}
}
